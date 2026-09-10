# Republish Google's metering agent into our registry, unmodified.
#
# WHY THIS EXISTS
# schema.yaml declares an `ubbagent` image, so Marketplace requires a copy in
# OUR registry carrying the release version tags. The content is entirely
# Google's; the only thing we add is the mandatory Marketplace manifest
# annotation, applied at push time by buildx (see build-ubbagent.sh).
#
# WHY IT WAS REFRESHED FOR 8.4
# The copy in our registry dated from 2026-03-17. Producer Portal rejected the
# 8.4 release with 14 CVEs against it. Google's own current release (0.2.13,
# 2026-07-15) clears 13 of those 14.
#
# Bump this tag when Google publishes a newer agent:
#   gcloud container images list-tags gcr.io/cloud-marketplace-tools/metering/ubbagent
FROM gcr.io/cloud-marketplace-tools/metering/ubbagent:0.2.13

# Patch the Alpine OpenSSL packages.
#
# Producer Portal blocked the 8.4 release on CVE-2026-63073 and CVE-2026-75803
# against openssl 3.5.7-r0 (our scanner reports the same package/fix pair as
# CVE-2026-14456 -- different feeds, same remedy). Google's 0.2.13 ships
# 3.5.7-r0; Alpine 3.23 main has 3.5.8-r0.
#
# This is the point where we stop republishing Google's image verbatim and start
# maintaining a patched variant: OS packages only, never the ubbagent binary.
# When Google publishes a newer agent, bump the FROM above and re-check whether
# this RUN is still needed -- drop it as soon as their image carries the fix.
#
# Deliberately no `USER root`: if the base runs as root this works unchanged, and
# if it does not, the build fails loudly rather than silently escalating the
# container's privileges.
RUN apk upgrade --no-cache libcrypto3 libssl3
