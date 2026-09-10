#!/usr/bin/env bash
#
# Assert that every version touchpoint agrees, and that no stale repository
# URLs remain. Run before any Marketplace submission.
set -uo pipefail

fail=0
check() { # check <label> <expected> <actual>
  if [ "$2" = "$3" ]; then
    printf '  PASS  %-46s %s\n' "$1" "$3"
  else
    printf '  FAIL  %-46s expected %s, got %s\n' "$1" "$2" "$3"; fail=1
  fi
}

# NB: the VERSION line in deploy.sh carries a trailing comment, so this
# pattern must not anchor with $.
VERSION="$(sed -n 's/^VERSION="${VERSION:-\([^}]*\)}".*/\1/p' deploy.sh)"
[ -n "$VERSION" ] || { echo "FATAL: could not read VERSION from deploy.sh"; exit 1; }
TRACK="${VERSION%.*}"
echo "Release version: $VERSION (track $TRACK)"
echo
echo "Version touchpoints:"

check "schema.yaml publishedVersion" "$VERSION" \
  "$(sed -n "s/^  publishedVersion: *['\"]\(.*\)['\"]/\1/p" schema.yaml)"

check "schema.yaml releaseNote" "$VERSION" \
  "$(sed -n 's/.*SYNTASA platform release \([0-9.]*\).*/\1/p' schema.yaml)"

check "chart/syntasa/Chart.yaml version" "$VERSION" \
  "$(sed -n 's/^version: *\(.*\)/\1/p' chart/syntasa/Chart.yaml)"

check "chart/syntasa/values.yaml publishedVersion" "$VERSION" \
  "$(sed -n 's/^publishedVersion: *"\(.*\)"/\1/p' chart/syntasa/values.yaml)"

check "application.yaml descriptor version" "$VERSION" \
  "$(sed -n "s/^    version: *'\(.*\)'/\1/p" chart/syntasa/templates/application.yaml)"

check "data-test Chart.yaml version" "$VERSION" \
  "$(sed -n 's/^version: *\(.*\)/\1/p' data-test/chart/syntasa-test/Chart.yaml)"

echo
echo "Release type:"
check "schema.yaml releaseTypes" "Security" \
  "$(sed -n 's/^ *- \(Security\|Feature\|BugFix\)$/\1/p' schema.yaml | head -1)"

echo
echo "Stale repository URLs (want 0):"
# The real repo is syntasa-google-marketplace-sentiment-anlytics. Any bare
# 'syntasa-google-marketplace' not followed by '-sentiment' is stale.
stale=$(grep -rn 'syntasa-google-marketplace' \
          --include='*.yaml' --include='*.md' . 2>/dev/null \
        | grep -v '/\.git/' \
        | grep -v 'sentiment-anlytics' \
        | grep -v 'docs/superpowers/' \
        | grep -v 'MARKETPLACE_RUNBOOK' \
        | wc -l | tr -d ' ')
check "stale old-repo URL count" "0" "$stale"
if [ "$stale" != "0" ]; then
  grep -rn 'syntasa-google-marketplace' --include='*.yaml' --include='*.md' . 2>/dev/null \
    | grep -v '/\.git/' | grep -v 'sentiment-anlytics' \
    | grep -v 'docs/superpowers/' | grep -v 'MARKETPLACE_RUNBOOK' | sed 's/^/        /'
fi

echo
echo "Misspelling guard (the repo name really is 'anlytics'):"
# Exclude docs/superpowers/ -- the spec and plan deliberately quote the typo
# in order to warn against it, and matching those is a false positive.
bad=$(grep -rn 'anlyticse' --include='*.yaml' --include='*.md' . 2>/dev/null \
      | grep -v '/\.git/' | grep -v 'docs/superpowers/' | wc -l | tr -d ' ')
check "occurrences of typo 'anlyticse'" "0" "$bad"

echo
[ "$fail" -eq 0 ] && echo "ALL CHECKS PASSED" || echo "CHECKS FAILED"
exit "$fail"
