#!/usr/bin/env bash
#
# Republish Google's metering agent into our registry for a release.
#   VERSION=8.4.0 ./ubbagent/build-ubbagent.sh
#
# Annotations are MANIFEST annotations. They require a docker-container buildx
# builder and OCI media types -- the default docker driver drops them silently.
# See deploy.sh for the same mechanism and the reasoning behind it.
set -euo pipefail

VERSION="${VERSION:-8.4.0}"
TRACK="${TRACK:-${VERSION%.*}}"
REGISTRY="${REGISTRY:-gcr.io/syntasa-public}"
APP_NAME="${APP_NAME:-syntasa-behaviorial-sentiment-analytics}"
BUILDER="${BUILDER:-mp-builder}"
IMAGE="$REGISTRY/$APP_NAME/ubbagent"
MP_ANNOTATION="com.googleapis.cloudmarketplace.product.service.name=services/syntasa-behavioral-sentiment-analytics.endpoints.syntasa-public.cloud.goog"

if ! docker buildx inspect "$BUILDER" >/dev/null 2>&1; then
  docker buildx create --name "$BUILDER" --driver docker-container >/dev/null
fi

docker buildx build --builder "$BUILDER" --pull \
  --provenance=false --sbom=false \
  --output "type=image,oci-mediatypes=true,push=true" \
  --annotation "manifest:$MP_ANNOTATION" \
  --tag "$IMAGE:$VERSION" --tag "$IMAGE:$TRACK" \
  "$(dirname "$0")"

echo "==> Verifying annotation"
_tok="$(gcloud auth print-access-token)"
for _tag in "$VERSION" "$TRACK"; do
  _val=$(curl -sS -H "Authorization: Bearer $_tok" \
    -H 'Accept: application/vnd.oci.image.manifest.v1+json, application/vnd.docker.distribution.manifest.v2+json' \
    "https://gcr.io/v2/${IMAGE#gcr.io/}/manifests/$_tag" \
    | jq -r '(.annotations // {})["com.googleapis.cloudmarketplace.product.service.name"] // "MISSING"')
  [ "$_val" = "MISSING" ] && { echo "    FAIL $IMAGE:$_tag annotation MISSING"; exit 1; }
  echo "    ok   $IMAGE:$_tag"
done

# NOTE when scanning afterwards: scan BY DIGEST, not by tag. A stale local image
# under the same tag will be scanned instead of the one just pushed, which
# produced a badly misleading result during the 8.4 release.
