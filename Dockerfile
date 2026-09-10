# Base pinned by digest deliberately.
#
# This image supplies helm and kubectl; every CVE Google has flagged against the
# deployer originates here, not in this repository (see the design spec, 2.2 and
# 2.7). Pinning makes the image we scan, verify and submit provably identical.
#
# Bump this digest as a conscious step at each release, then re-derive
# .trivyignore. Leaving it floating is what produced 256 findings over nine
# months.
#
# Pinned 2026-09-09, resolved from :latest.
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild@sha256:6a6d705987be9dacb976540b02901250bf09324c2fdc641f64c014da696bd198

# Add timeouts so we don't have to wait a full 5 minutes for the deployer to timeout
ENV WAIT_FOR_READY_TIMEOUT 120
ENV TESTER_TIMEOUT 120
