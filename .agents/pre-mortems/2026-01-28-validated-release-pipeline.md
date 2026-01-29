# Pre-Mortem: Validated Release Pipeline

**Date:** 2026-01-28
**Spec:** `.agents/specs/2026-01-28-validated-release-pipeline.md`

## Summary

Building a 3-stage release pipeline (build → validate → publish) to prevent shipping broken binaries. Four failure experts identified **8 CRITICAL**, **12 HIGH**, and **15 MEDIUM** severity issues across integration boundaries, operations, data integrity, and edge cases.

**Top Risk:** The current `release.yml` is a single-stage workflow that ships immediately on tag push. The validation stage exists only in the design document — it's not implemented. This is the root cause of the v1.0.9-v1.0.11 incident.

---

## Simulation Findings

### CRITICAL (Must Fix Before Implementation)

| # | Issue | Category | Why It Will Fail |
|---|-------|----------|------------------|
| 1 | **Validation stage not implemented** | Ops | Current workflow has single goreleaser job. No validation gate exists. Broken binaries ship immediately. |
| 2 | **`scripts/validate-release.sh` doesn't exist** | Ops | Design doc references this file but it's not created. Validation job will fail with "file not found". |
| 3 | **Version injection fails silently** | Data | If ldflags path wrong, binary ships with `version = "dev"`. No check catches this before publish. |
| 4 | **macOS runner architecture mismatch** | Integration | `macos-latest` may be arm64 or x86_64. Downloading wrong binary causes "Bad CPU type" error. |
| 5 | **Cross-job output context loss** | Integration | Build job outputs version to `$GITHUB_OUTPUT`. If this fails silently, validate job gets empty string. |
| 6 | **Homebrew TAP token expiry** | Integration | If token expires between validate and publish, formula push fails but release is already created. Partial state. |
| 7 | **Zero-byte or corrupted binary** | Edge | No integrity check. Empty binary passes file existence check but crashes on execution. |
| 8 | **Version string matching too permissive** | Edge | `grep -q "1.0.12"` matches substrings. Could pass with malformed version like `v1.0.12-dirty`. |

### HIGH (Should Fix)

| # | Issue | Risk | Mitigation |
|---|-------|------|------------|
| 1 | GoReleaser version drift | Breaking changes in "latest" | Pin version: `version: '~> v2'` |
| 2 | Artifact corruption during upload/download | Checksum never verified | Add SHA256 verification between jobs |
| 3 | Tag deletion race condition | Tag deleted while workflow running | Verify tag exists before publish |
| 4 | GitHub API rate limit | Multiple rapid releases exhaust quota | Check rate limit before publish |
| 5 | No workflow_dispatch trigger | Can't manually re-run failed release | Add `workflow_dispatch` to triggers |
| 6 | Partial publish state | Release created but formula fails | Split into separate jobs with rollback |
| 7 | Git tag format not validated | Non-semver tags cause formula issues | Require `^v[0-9]+\.[0-9]+\.[0-9]+$` |
| 8 | Concurrent tag pushes | Race condition, corrupt artifacts | Add `concurrency` group |
| 9 | Status command may fail unexpectedly | Blocks release unnecessarily | Test in clean environment |
| 10 | Binary output to stderr not captured | Misses initialization errors | Use `2>&1` consistently |
| 11 | Homebrew formula invalid characters | Special chars in version break formula | Validate formula before push |
| 12 | Artifact decompression race | Filesystem cache issues | Add `sync` and integrity check |

### MEDIUM (Consider)

- Artifact retention policy (set `retention-days: 1`)
- No observability/alerting on release
- No runbook for failed release cleanup
- Help flag variants not all tested (`-h` vs `--help`)
- Cross-platform validation only tests darwin-arm64
- Formula audit not run before push
- Release notes auto-generation missing
- Shell exit code propagation issues
- Job dependency ordering not explicit
- Idempotency on retry (duplicate releases)

---

## Ambiguities Found

1. **Which macOS runner architecture?** — `macos-latest` could be either arm64 or x86_64. Spec says "darwin-arm64 runner" but workflow uses `macos-latest`.

2. **What if `ao status` fails?** — Spec says "allowed to fail gracefully" but doesn't define what exit codes are acceptable.

3. **GoReleaser split build/publish** — Spec assumes `--skip=publish` then `--skip=build` works, but this is untested with current goreleaser version.

4. **Formula generation location** — Where does GoReleaser put the generated formula? Needs to be extracted for validation.

---

## Spec Enhancement Recommendations

### Add to Section 2.1 (Workflow Structure)

```yaml
# Pin runner and GoReleaser versions
validate:
  runs-on: macos-14  # Explicit arm64, not macos-latest

- uses: goreleaser/goreleaser-action@v6
  with:
    version: '~> v2'  # Pin major version

# Add workflow concurrency
concurrency:
  group: release-${{ github.ref }}
  cancel-in-progress: false

# Add workflow_dispatch trigger
on:
  push:
    tags: ['v*']
  workflow_dispatch:
    inputs:
      tag:
        description: 'Tag to release'
        required: true
```

### Add to Section 2.2 (Validation Script)

```bash
#!/usr/bin/env bash
set -euo pipefail

BINARY="${1:?Usage: validate-release.sh <binary> <version>}"
EXPECTED_VERSION="${2:?Usage: validate-release.sh <binary> <version>}"

# Check binary exists and is executable
[[ -f "$BINARY" ]] || { echo "FAIL: Binary not found"; exit 1; }
[[ -x "$BINARY" ]] || chmod +x "$BINARY"

# Check binary size > 1MB (catch zero-byte/truncated)
SIZE=$(stat -f%z "$BINARY" 2>/dev/null || stat -c%s "$BINARY")
[[ $SIZE -lt 1000000 ]] && { echo "FAIL: Binary too small ($SIZE bytes)"; exit 1; }

# Check it's actually an executable
file "$BINARY" | grep -qE "(Mach-O|ELF).*executable" || { echo "FAIL: Not an executable"; exit 1; }

# Check version injection (exact match, not substring)
VERSION_OUTPUT=$("$BINARY" version 2>&1)
if ! echo "$VERSION_OUTPUT" | grep -qF "ao version $EXPECTED_VERSION"; then
  echo "FAIL: Version mismatch"
  echo "Expected: ao version $EXPECTED_VERSION"
  echo "Got: $VERSION_OUTPUT"
  exit 1
fi

# Check help works
"$BINARY" --help > /dev/null 2>&1 || { echo "FAIL: --help failed"; exit 1; }
"$BINARY" -h > /dev/null 2>&1 || { echo "FAIL: -h failed"; exit 1; }

# Status may fail in CI (no .agents/), that's OK
"$BINARY" status 2>&1 || true

echo "PASS: All validation checks passed"
echo "  Binary: $BINARY"
echo "  Version: $EXPECTED_VERSION"
echo "  Size: $SIZE bytes"
```

### Add to Section 4 (Error Handling)

```yaml
# Pre-publish token validation
- name: Validate Homebrew token
  env:
    HOMEBREW_TAP_GITHUB_TOKEN: ${{ secrets.HOMEBREW_TAP_GITHUB_TOKEN }}
  run: |
    [[ -n "$HOMEBREW_TAP_GITHUB_TOKEN" ]] || { echo "Token not set"; exit 1; }
    curl -sf -H "Authorization: token $HOMEBREW_TAP_GITHUB_TOKEN" \
      https://api.github.com/repos/boshu2/homebrew-agentops > /dev/null \
      || { echo "Token invalid or expired"; exit 1; }

# Verify tag still exists before publish
- name: Verify tag exists
  run: |
    git fetch --tags
    git rev-parse "${{ github.ref_name }}" > /dev/null \
      || { echo "Tag no longer exists"; exit 1; }
```

### Add Section 11: Pre-Implementation Checklist

- [ ] Create `scripts/validate-release.sh` with integrity checks
- [ ] Update `release.yml` to 3-job structure
- [ ] Pin GoReleaser version to `~> v2`
- [ ] Change `macos-latest` to `macos-14`
- [ ] Add `workflow_dispatch` trigger
- [ ] Add `concurrency` group
- [ ] Add token validation step
- [ ] Add tag existence verification
- [ ] Test with `v0.0.0-test` tag before production use

---

## Verdict

**[ ] READY** — Proceed to implementation
**[X] NEEDS WORK** — Address critical issues first

### Required Before Implementation

1. **Create `scripts/validate-release.sh`** — The validation logic. Without this, the validation job fails immediately.

2. **Rewrite `release.yml`** — Current workflow is single-stage. Must implement 3-job structure from spec.

3. **Pin versions** — GoReleaser and macOS runner must be pinned to avoid drift.

4. **Add integrity checks** — Binary size, file type, exact version match.

5. **Add token validation** — Pre-publish check that Homebrew token works.

### Test Plan Before Production

1. Push `v0.0.0-test` tag
2. Verify build produces 4 artifacts
3. Verify validate job runs on arm64 macOS
4. Intentionally break version injection, verify validation catches it
5. Verify publish only runs after validate passes
6. Delete test tag and release
7. Then proceed with real release

---

## Risk Summary

| Severity | Count | Action |
|----------|-------|--------|
| CRITICAL | 8 | Must fix before any release |
| HIGH | 12 | Should fix before production use |
| MEDIUM | 15+ | Address in future iterations |

**Estimated fix time:** 2-3 hours for critical issues, 4-5 hours total.
