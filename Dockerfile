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
# Pinned 2026-11-05, resolved from :latest.
# Bumped 2026-11-05 from sha256:dab57d60: clears CVE-2026-78663, CVE-2026-56857
# (Go stdlib) and CVE-2026-111497 (brotli), all three flagged by Marketplace
# validation on 2026-11-05. Findings 11 -> 6. kubectl now 1.37.2 (go1.26.10).
#
# Previously bumped from sha256:6a6d7059 (2026-09-09): that base shipped helm 4.3.1
# (go1.27.2) and kubectl 1.37.1 (go1.26.8), clearing CVE-2026-39821 -- the
# finding Google granted an exemption for on 8.4 -- plus 12 others.
# Findings 24 -> 11, CRITICAL 1 -> 0. Re-derive .trivyignore on every bump.
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm/onbuild@sha256:142cee99f77afd33f0fb2918c76ade900c2d4b257958f62ab9738a6118dc5b34

# Add timeouts so we don't have to wait a full 5 minutes for the deployer to timeout
ENV WAIT_FOR_READY_TIMEOUT 120
ENV TESTER_TIMEOUT 120
