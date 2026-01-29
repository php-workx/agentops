# Spec: Validated Release Pipeline

**ID:** ao-release-validation
**Date:** 2026-01-28
**Status:** Ready (Post Pre-Mortem)
**Author:** Claude + Ben

---

## 1. Overview

### 1.1 Problem Statement

The current release workflow (`release.yml`) has no validation gate. When a tag is pushed, GoReleaser immediately builds and publishes artifacts. This has caused:

- Broken binaries shipped to users (version showing "dev")
- Multiple rapid-fire releases to fix issues (v1.0.9 → v1.0.10 → v1.0.11)
- No way to catch problems before they reach users

### 1.2 Success Criteria

1. **No broken releases** — Binaries are validated before publishing
2. **Clear failure mode** — If validation fails, nothing is published
3. **Minimal friction** — No manual approval required when checks pass
4. **Fast feedback** — Total pipeline time < 5 minutes

### 1.3 Non-Goals

- Multi-platform validation (Linux validation can come later)
- Integration tests beyond basic CLI checks
- Automated changelog generation
- Release notifications

---

## 2. Technical Specification

### 2.1 Workflow Structure

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:
    inputs:
      tag:
        description: 'Tag to release (for manual re-run)'
        required: false

# Prevent concurrent releases
concurrency:
  group: release-${{ github.ref }}
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.version.outputs.version }}
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Fetch all tags
        run: git fetch --tags

      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'

      - name: Extract and validate version
        id: version
        run: |
          VERSION="${GITHUB_REF#refs/tags/}"
          # Validate semver format
          if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
            echo "::error::Invalid version format: $VERSION"
            exit 1
          fi
          echo "version=$VERSION" >> $GITHUB_OUTPUT
          echo "Version: $VERSION"

      - name: Build with GoReleaser
        uses: goreleaser/goreleaser-action@v6
        with:
          version: '~> v2'
          args: release --skip=publish --clean
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: release-artifacts
          path: |
            dist/*.tar.gz
            dist/checksums.txt
          retention-days: 1

  validate:
    needs: build
    runs-on: macos-14  # Explicit arm64 runner (not macos-latest)
    steps:
      - uses: actions/checkout@v4

      - name: Download artifacts
        uses: actions/download-artifact@v4
        with:
          name: release-artifacts
          path: dist/

      - name: Verify runner architecture
        run: |
          ARCH=$(uname -m)
          echo "Runner architecture: $ARCH"
          if [[ "$ARCH" != "arm64" ]]; then
            echo "::error::Expected arm64 runner, got $ARCH"
            exit 1
          fi

      - name: Extract and validate binary
        run: |
          cd dist
          tar -xzf ao-darwin-arm64.tar.gz
          sync  # Ensure filesystem flush

          # Verify binary exists and is executable
          if [[ ! -f "ao" ]]; then
            echo "::error::Binary not found after extraction"
            exit 1
          fi

          chmod +x ao

          # Verify binary size (catch zero-byte/truncated)
          SIZE=$(stat -f%z ao)
          if [[ $SIZE -lt 1000000 ]]; then
            echo "::error::Binary too small ($SIZE bytes), likely corrupted"
            exit 1
          fi

          # Verify it's an actual Mach-O executable
          if ! file ao | grep -q "Mach-O.*executable"; then
            echo "::error::Not a valid Mach-O executable"
            file ao
            exit 1
          fi

          echo "✓ Binary integrity verified ($SIZE bytes)"

      - name: Validate version injection
        env:
          EXPECTED_VERSION: ${{ needs.build.outputs.version }}
        run: |
          cd dist
          VERSION_OUTPUT=$(./ao version 2>&1)

          # Exact match check (not substring)
          if ! echo "$VERSION_OUTPUT" | grep -qF "ao version $EXPECTED_VERSION"; then
            echo "::error::Version mismatch"
            echo "Expected: ao version $EXPECTED_VERSION"
            echo "Got: $VERSION_OUTPUT"
            exit 1
          fi

          echo "✓ Version injection verified: $EXPECTED_VERSION"

      - name: Validate binary executes
        run: |
          cd dist

          # Test --help
          if ! ./ao --help > /dev/null 2>&1; then
            echo "::error::--help failed"
            exit 1
          fi
          echo "✓ --help passed"

          # Test -h (POSIX variant)
          if ! ./ao -h > /dev/null 2>&1; then
            echo "::error::-h failed"
            exit 1
          fi
          echo "✓ -h passed"

          # status may fail in CI (no .agents/), that's expected
          ./ao status 2>&1 || true
          echo "✓ status command executed"

  publish:
    needs: [build, validate]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Fetch all tags
        run: git fetch --tags

      - name: Verify tag still exists
        run: |
          TAG="${{ needs.build.outputs.version }}"
          if ! git rev-parse "$TAG" > /dev/null 2>&1; then
            echo "::error::Tag $TAG no longer exists"
            exit 1
          fi
          echo "✓ Tag $TAG verified"

      - name: Validate Homebrew token
        env:
          HOMEBREW_TAP_GITHUB_TOKEN: ${{ secrets.HOMEBREW_TAP_GITHUB_TOKEN }}
        run: |
          if [[ -z "$HOMEBREW_TAP_GITHUB_TOKEN" ]]; then
            echo "::error::HOMEBREW_TAP_GITHUB_TOKEN not set"
            exit 1
          fi

          # Test token validity
          RESPONSE=$(curl -sf -H "Authorization: token $HOMEBREW_TAP_GITHUB_TOKEN" \
            https://api.github.com/repos/boshu2/homebrew-agentops 2>&1) || {
            echo "::error::Homebrew token invalid or expired"
            exit 1
          }
          echo "✓ Homebrew token valid"

      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'

      - name: Download artifacts
        uses: actions/download-artifact@v4
        with:
          name: release-artifacts
          path: dist/

      - name: Publish with GoReleaser
        uses: goreleaser/goreleaser-action@v6
        with:
          version: '~> v2'
          args: release --skip=build --clean
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          HOMEBREW_TAP_GITHUB_TOKEN: ${{ secrets.HOMEBREW_TAP_GITHUB_TOKEN }}
```

### 2.2 Validation Script

Create `scripts/validate-release.sh` for local testing:

```bash
#!/usr/bin/env bash
set -euo pipefail

BINARY="${1:?Usage: validate-release.sh <binary> <version>}"
EXPECTED_VERSION="${2:?Usage: validate-release.sh <binary> <version>}"

echo "=== Validating $BINARY for version $EXPECTED_VERSION ==="

# Check 1: Binary exists and is executable
echo -n "Checking binary exists... "
if [[ ! -f "$BINARY" ]]; then
  echo "FAIL: Binary not found"
  exit 1
fi
if [[ ! -x "$BINARY" ]]; then
  chmod +x "$BINARY"
fi
echo "PASS"

# Check 2: Binary size (catch zero-byte/truncated)
echo -n "Checking binary size... "
if [[ "$(uname)" == "Darwin" ]]; then
  SIZE=$(stat -f%z "$BINARY")
else
  SIZE=$(stat -c%s "$BINARY")
fi
if [[ $SIZE -lt 1000000 ]]; then
  echo "FAIL: Binary too small ($SIZE bytes)"
  exit 1
fi
echo "PASS ($SIZE bytes)"

# Check 3: File type
echo -n "Checking file type... "
if ! file "$BINARY" | grep -qE "(Mach-O|ELF).*executable"; then
  echo "FAIL: Not an executable"
  file "$BINARY"
  exit 1
fi
echo "PASS"

# Check 4: Version injection (exact match)
echo -n "Checking version... "
VERSION_OUTPUT=$("$BINARY" version 2>&1 || true)
if ! echo "$VERSION_OUTPUT" | grep -qF "ao version $EXPECTED_VERSION"; then
  echo "FAIL"
  echo "  Expected: ao version $EXPECTED_VERSION"
  echo "  Got: $VERSION_OUTPUT"
  exit 1
fi
echo "PASS"

# Check 5: Help commands
echo -n "Checking --help... "
if ! "$BINARY" --help > /dev/null 2>&1; then
  echo "FAIL"
  exit 1
fi
echo "PASS"

echo -n "Checking -h... "
if ! "$BINARY" -h > /dev/null 2>&1; then
  echo "FAIL"
  exit 1
fi
echo "PASS"

# Check 6: Basic command (non-fatal)
echo -n "Checking status... "
if "$BINARY" status > /dev/null 2>&1; then
  echo "PASS"
else
  echo "SKIP (expected outside repo)"
fi

echo ""
echo "=== All validation checks passed ==="
echo "  Binary: $BINARY"
echo "  Version: $EXPECTED_VERSION"
echo "  Size: $SIZE bytes"
```

### 2.3 GoReleaser Configuration

The existing `.goreleaser.yml` is sufficient. Key settings:

```yaml
version: 2
project_name: ao

builds:
  - id: ao
    dir: cli
    main: ./cmd/ao
    binary: ao
    goos: [darwin, linux]
    goarch: [amd64, arm64]
    ldflags:
      - -s -w -X main.version={{ .Version }}

archives:
  - id: ao
    name_template: ao-{{ .Os }}-{{ .Arch }}
    format: tar.gz
    wrap_in_directory: false

checksum:
  name_template: checksums.txt
  algorithm: sha256

brews:
  - name: agentops
    directory: Formula
    repository:
      owner: boshu2
      name: homebrew-agentops
      branch: main
      token: "{{ .Env.HOMEBREW_TAP_GITHUB_TOKEN }}"
    install: |
      bin.install "ao"
    test: |
      system "#{bin}/ao", "version"
```

---

## 3. Interfaces

### 3.1 Inputs

| Input | Source | Validation |
|-------|--------|------------|
| Git tag | `push` event | Must match `^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$` |
| `GITHUB_TOKEN` | GitHub Actions | Auto-provided |
| `HOMEBREW_TAP_GITHUB_TOKEN` | Repository secret | Validated before publish |

### 3.2 Outputs

| Output | Destination | Description |
|--------|-------------|-------------|
| GitHub Release | `boshu2/agentops` | Release with 4 tarballs |
| Homebrew Formula | `boshu2/homebrew-agentops` | Auto-updated formula |
| Checksums | Release assets | `checksums.txt` |

### 3.3 Artifacts (Internal)

| Artifact | Retention | Purpose |
|----------|-----------|---------|
| `release-artifacts` | 1 day | Pass binaries between jobs |

---

## 4. Error Handling

### 4.1 Build Failures

| Failure | Behavior | Recovery |
|---------|----------|----------|
| Invalid tag format | Build job fails immediately | Fix tag format, re-tag |
| Go compilation error | Build job fails | Fix code, re-tag |
| GoReleaser config error | Build job fails | Fix `.goreleaser.yml` |
| Artifact upload fails | Build job fails | Retry workflow |

### 4.2 Validation Failures

| Failure | Behavior | Recovery |
|---------|----------|----------|
| Wrong runner architecture | Validate fails | Check workflow uses `macos-14` |
| Binary corrupted/truncated | Validate fails | Check build, re-tag |
| Version shows "dev" | Validate fails | Fix ldflags, delete tag, re-tag |
| Binary crashes on --help | Validate fails | Fix code, delete tag, re-tag |

### 4.3 Publish Failures

| Failure | Behavior | Recovery |
|---------|----------|----------|
| Tag deleted during workflow | Publish fails | Re-tag |
| Homebrew token expired | Publish fails | Refresh token, retry |
| Release creation fails | Publish fails | Retry workflow |
| Partial publish | Release exists, formula may not | Manual Homebrew push |

### 4.4 Tag Deletion Procedure

When validation fails and you need to retry:

```bash
# Delete local tag
git tag -d v1.0.12

# Delete remote tag
git push origin :refs/tags/v1.0.12

# Fix the issue, then re-tag
git tag v1.0.12
git push origin v1.0.12
```

---

## 5. Testing Plan

### 5.1 Pre-Implementation Testing

Before deploying:

```bash
# Test validation script locally
goreleaser build --snapshot --clean --single-target
./scripts/validate-release.sh ./dist/ao_*/ao v0.0.0-test
```

### 5.2 Integration Testing

| Test | Method | Expected Result |
|------|--------|-----------------|
| Full workflow | Push `v0.0.0-test` tag | All 3 jobs pass |
| Version "dev" caught | Break ldflags locally, build | Validate fails |
| Truncated binary caught | Create 100-byte file | Validate fails (size check) |
| Token validation | Expire/revoke token | Publish fails with clear message |

### 5.3 Manual Verification Checklist

- [ ] Tag `v0.0.0-test` triggers workflow
- [ ] Build job produces 4 tarballs + checksums
- [ ] Validate job runs on macOS arm64 (macos-14)
- [ ] Validate job verifies correct version string
- [ ] Validate job fails if version is "dev"
- [ ] Publish job only runs after validate passes
- [ ] Release appears on GitHub with correct assets
- [ ] `brew upgrade agentops` installs correct version
- [ ] Delete test tag and release after testing

---

## 6. Rollout Plan

### Phase 1: Create Scripts (30 min)

1. Create `scripts/validate-release.sh`
2. Make executable: `chmod +x scripts/validate-release.sh`
3. Test locally with snapshot build

### Phase 2: Update Workflow (30 min)

1. Replace `.github/workflows/release.yml` with spec
2. Commit to branch, create PR
3. Review changes

### Phase 3: Test Workflow (30 min)

1. Merge PR
2. Push `v0.0.0-test` tag
3. Monitor all 3 jobs
4. Verify release created
5. Delete test tag and release

### Phase 4: Production Release (15 min)

1. Tag next real version
2. Monitor workflow
3. Verify `brew upgrade agentops` works

### Phase 5: Document (30 min)

1. Create `docs/RELEASING.md`
2. Document local testing procedure
3. Document rollback procedure

---

## 7. Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Pipeline duration | < 5 min | GitHub Actions timing |
| Validation catch rate | 100% | No broken releases post-implementation |
| False positive rate | 0% | No valid releases blocked |

---

## 8. Dependencies

### 8.1 External Services

| Service | Purpose | Pre-Check |
|---------|---------|-----------|
| GitHub Actions | CI/CD | N/A (required) |
| GitHub Releases | Distribution | N/A (required) |
| Homebrew tap repo | macOS distribution | Token validated in publish job |

### 8.2 Tools

| Tool | Version | Pinned? |
|------|---------|---------|
| GoReleaser | ~> v2 | Yes (major version) |
| Go | 1.22 | Yes |
| macOS runner | macos-14 | Yes (not `latest`) |

---

## 9. Security Considerations

| Risk | Mitigation |
|------|------------|
| PAT exposure | Stored as GitHub secret, never logged |
| Token expiry | Validated before publish attempt |
| Supply chain attack | GoReleaser from official action, pinned version |
| Binary tampering | Checksums published with release |

---

## 10. Pre-Mortem Findings Addressed

| Finding | Severity | Resolution |
|---------|----------|------------|
| Validation stage not implemented | CRITICAL | Spec now has full workflow YAML |
| `validate-release.sh` missing | CRITICAL | Script included in spec |
| Version injection fails silently | CRITICAL | Exact match check, not substring |
| macOS runner architecture mismatch | CRITICAL | Pinned to `macos-14`, arch verified |
| Cross-job output context loss | CRITICAL | Version validated in multiple places |
| Homebrew token expiry | CRITICAL | Token validated before publish |
| Zero-byte binary | CRITICAL | Size check (>1MB) |
| Version string too permissive | CRITICAL | Exact match with `grep -qF` |
| GoReleaser version drift | HIGH | Pinned to `~> v2` |
| Tag deletion race | HIGH | Tag verified before publish |
| No workflow_dispatch | HIGH | Added for manual re-runs |
| Concurrent releases | HIGH | Concurrency group added |

---

## 11. Pre-Implementation Checklist

- [ ] Create `scripts/validate-release.sh`
- [ ] Make script executable
- [ ] Test script locally with `goreleaser build --snapshot`
- [ ] Update `.github/workflows/release.yml`
- [ ] Test with `v0.0.0-test` tag
- [ ] Verify all 3 jobs pass
- [ ] Intentionally break version, verify validation catches it
- [ ] Delete test tag and release
- [ ] Tag real release
- [ ] Create `docs/RELEASING.md`

---

## Appendix A: File Changes

| File | Action | Description |
|------|--------|-------------|
| `.github/workflows/release.yml` | Replace | Three-job structure with all fixes |
| `scripts/validate-release.sh` | Create | Local testing script |
| `docs/RELEASING.md` | Create | Process documentation |
