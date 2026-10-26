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
# Pinned 2026-10-26, resolved from :latest.
# Bumped from sha256:6a6d7059 (2026-09-09): the newer base ships helm 4.3.1
# (go1.27.2) and kubectl 1.37.1 (go1.26.8), clearing CVE-2026-39821 -- the
# finding Google granted an exemption for on 8.4 -- plus 12 others.
# Findings 24 -> 11, CRITICAL 1 -> 0. Re-derive .trivyignore on every bump.
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild@sha256:dab57d602f8eb40a9543928696ff4ee26785094a66354717242cb67c43010443

# Add timeouts so we don't have to wait a full 5 minutes for the deployer to timeout
ENV WAIT_FOR_READY_TIMEOUT 120
ENV TESTER_TIMEOUT 120
