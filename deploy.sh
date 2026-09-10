#!/usr/bin/env bash
#
# Build, scan and publish the SYNTASA Marketplace deployer image.
#
#   VERSION=8.4.0 ./deploy.sh      # build, scan, push
#   SKIP_PUSH=1 ./deploy.sh        # build and scan only
#
# Marketplace requires every image in a release to carry BOTH the track tag
# (8.4) and the full version (8.4.0), on the deployer path AND on the root
# image path, and both tags on a path must resolve to the same digest.
set -euo pipefail

# ---- release configuration --------------------------------------------------
VERSION="${VERSION:-8.4.0}"        # full release version
TRACK="${TRACK:-${VERSION%.*}}"    # 8.4.0 -> 8.4

export PROJECT="$(gcloud config get-value project | tr ':' '/')"
export REGISTRY="${REGISTRY:-gcr.io/syntasa-public}"
export APP_NAME="${APP_NAME:-syntasa-behaviorial-sentiment-analytics}"

# Consumed by the base image's ONBUILD triggers and by schema.yaml.
export DEPLOYER_TAG_SEM="$TRACK"
export DEPLOYER_TAG="$VERSION"
export TAG="$VERSION"

DEPLOYER="$REGISTRY/$APP_NAME/deployer"
ROOT_IMAGE="$REGISTRY/$APP_NAME"
SKIP_PUSH="${SKIP_PUSH:-0}"
BUILDER="${BUILDER:-mp-builder}"

# Marketplace REQUIRES this manifest annotation on every image in a release.
# Without it Producer Portal fails validation before it starts:
#   "Failed to process container images from schema file: Missing annotation
#    com.googleapis.cloudmarketplace.product.service.name in manifest of image"
# It is a MANIFEST annotation, not a config label -- `docker inspect` will not
# show it, and a Dockerfile LABEL will not produce it. Plain `docker build` +
# `docker push` cannot write it; buildx --annotation can.
# Note the value uses the correctly spelled solution id ("behavioral"), unlike
# the registry path ("behaviorial").
# https://cloud.google.com/marketplace/docs/partners/migrations/container-image-annotations
MP_ANNOTATION="com.googleapis.cloudmarketplace.product.service.name=services/syntasa-behavioral-sentiment-analytics.endpoints.syntasa-public.cloud.goog"

echo "==> Building $DEPLOYER:$VERSION (track $TRACK)"

# ---- build ------------------------------------------------------------------
# --pull: never reuse a stale local base. The base is digest-pinned in the
# Dockerfile, so this fetches that exact digest.
# The default "docker" buildx driver cannot write OCI media types or manifest
# annotations. A docker-container builder can, and the annotation is mandatory
# (see MP_ANNOTATION above), so ensure one exists.
if ! docker buildx inspect "$BUILDER" >/dev/null 2>&1; then
  echo "==> Creating buildx builder '$BUILDER' (docker-container driver)"
  docker buildx create --name "$BUILDER" --driver docker-container >/dev/null
fi

# Phase 1: build locally so the scan gate can inspect it before anything is
# published. --load keeps it in the local docker image store.
docker buildx build --builder "$BUILDER" --pull --load \
  --build-arg REGISTRY="$REGISTRY" \
  --build-arg APP_NAME="$APP_NAME" \
  --build-arg TAG="$TAG" \
  --build-arg PROJECT="$PROJECT" \
  --tag "$DEPLOYER:$DEPLOYER_TAG" \
  --tag "$DEPLOYER:$DEPLOYER_TAG_SEM" \
  .

# ---- scan gate --------------------------------------------------------------
# Fails the build on any HIGH/CRITICAL not explicitly excused in .trivyignore.
# Every excused CVE is documented there with its package and binary path.
echo "==> Scanning $DEPLOYER:$DEPLOYER_TAG"
trivy image --timeout 30m --scanners vuln --pkg-types library,os \
  --severity HIGH,CRITICAL --exit-code 1 \
  --ignorefile .trivyignore \
  "$DEPLOYER:$DEPLOYER_TAG"

echo "==> Scan gate passed"

if [ "$SKIP_PUSH" = "1" ]; then
  echo "==> SKIP_PUSH=1 -- built and scanned, not pushing."
  exit 0
fi

# ---- publish ----------------------------------------------------------------
# Phase 2: re-run the same build with --push so buildx can write the Marketplace
# manifest annotation. The base is digest-pinned and the context unchanged, so
# this is a cache hit producing identical content -- but the pushed image is
# re-verified below rather than assumed.
#
# Marketplace requires the root path to carry the same version tags as the
# deployer, so all four tags are produced in one push.
echo "==> Pushing with Marketplace annotation"
# oci-mediatypes=true is required: annotations are dropped on Docker v2
# manifests. provenance/sbom are disabled so the push is a plain image manifest
# rather than an index, matching the other images in this listing.
docker buildx build --builder "$BUILDER" --pull \
  --provenance=false --sbom=false \
  --output "type=image,oci-mediatypes=true,push=true" \
  --annotation "manifest:$MP_ANNOTATION" \
  --build-arg REGISTRY="$REGISTRY" \
  --build-arg APP_NAME="$APP_NAME" \
  --build-arg TAG="$TAG" \
  --build-arg PROJECT="$PROJECT" \
  --tag "$DEPLOYER:$DEPLOYER_TAG" \
  --tag "$DEPLOYER:$DEPLOYER_TAG_SEM" \
  --tag "$ROOT_IMAGE:$DEPLOYER_TAG" \
  --tag "$ROOT_IMAGE:$DEPLOYER_TAG_SEM" \
  .

# ---- post-push verification -------------------------------------------------
# The annotation is the difference between a release that validates and one that
# is rejected before validation even starts. Never assume it landed.
echo "==> Verifying Marketplace annotation on pushed images"
_tok="$(gcloud auth print-access-token)"
_ok=1
for _ref in "$DEPLOYER:$DEPLOYER_TAG" "$DEPLOYER:$DEPLOYER_TAG_SEM" \
            "$ROOT_IMAGE:$DEPLOYER_TAG" "$ROOT_IMAGE:$DEPLOYER_TAG_SEM"; do
  _path="${_ref%:*}"; _tag="${_ref##*:}"; _path="${_path#gcr.io/}"
  _val=$(curl -sS -H "Authorization: Bearer $_tok" \
    -H 'Accept: application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.v2+json, application/vnd.oci.image.manifest.v1+json' \
    "https://gcr.io/v2/$_path/manifests/$_tag" \
    | jq -r '(.annotations // {})["com.googleapis.cloudmarketplace.product.service.name"] // "MISSING"')
  if [ "$_val" = "MISSING" ]; then
    echo "    FAIL  $_ref -- annotation MISSING"; _ok=0
  else
    echo "    ok    $_ref"
  fi
done
[ "$_ok" -eq 1 ] || { echo "==> Annotation missing; Producer Portal will reject this. Aborting."; exit 1; }

echo "==> Pushed $VERSION and $TRACK to deployer and root paths."
echo "==> Remaining images still need $TRACK/$VERSION tags -- see plan Task 11."
