# Test Suite

Automated validation tests for the AgentOps marketplace.

## Overview

This test suite validates:
- Marketplace structure and configuration
- Plugin manifests and metadata
- Component files and structure
- Documentation quality
- Token budget accuracy

## Running Tests

### Quick Validation

```bash
# Run all tests
make test

# Or directly with Python
python3 tests/validate_marketplace.py
python3 tests/validate_plugins.py
```

### Individual Tests

```bash
# Validate marketplace.json only
python3 tests/validate_marketplace.py

# Validate plugin manifests only
python3 tests/validate_plugins.py
```

## Test Files

### `validate_marketplace.py`

Validates `.claude-plugin/marketplace.json`:
- ✅ JSON syntax
- ✅ Required fields (name, owner, plugins)
- ✅ Plugin references
- ✅ External marketplace links
- ✅ Schema compliance

**Exit codes:**
- `0`: All validations passed
- `1`: Validation errors found

### `validate_plugins.py`

Validates individual plugin manifests:
- ✅ JSON syntax in `plugin.json`
- ✅ Required fields (name, version, description, author, license)
- ✅ Semantic versioning (X.Y.Z)
- ✅ Component declarations
- ✅ Component file existence
- ⚠️ Token budget accuracy (warning only)
- ⚠️ README.md presence (warning only)

**Exit codes:**
- `0`: All validations passed (warnings OK)
- `1`: Validation errors found

## CI/CD Integration

Tests run automatically via GitHub Actions on:
- Push to main branch
- Pull requests
- Manual workflow dispatch

See `.github/workflows/validate.yml` for complete CI/CD pipeline.

## Adding New Tests

### Create New Test File

```bash
# Create new test script
touch tests/test_new_feature.py
chmod +x tests/test_new_feature.py
```

### Test Template

```python
#!/usr/bin/env python3
"""
Test description.
"""

import sys
from pathlib import Path


def main():
    """Main test function."""
    repo_root = Path(__file__).parent.parent

    print("=================================")
    print("Test Name")
    print("=================================")
    print()

    # Your test logic here
    errors = []

    if errors:
        print("❌ Test failed")
        for error in errors:
            print(f"  - {error}")
        sys.exit(1)

    print("✅ Test passed!")


if __name__ == '__main__':
    main()
```

### Add to Makefile

```makefile
test: test-marketplace test-plugins test-new-feature

test-new-feature:
	@echo "Running new feature test..."
	python3 tests/test_new_feature.py
```

### Add to CI/CD

Update `.github/workflows/validate.yml`:

```yaml
- name: Run new feature test
  run: python3 tests/test_new_feature.py
```

## Test Coverage

### Currently Tested

- [x] Marketplace JSON structure
- [x] Plugin manifests
- [x] Required fields
- [x] Component files existence
- [x] Semantic versioning
- [x] Token budget format
- [x] External marketplace links

### Planned Tests

- [ ] Agent frontmatter YAML validation
- [ ] Command markdown structure
- [ ] Skill documentation completeness
- [ ] Link checking (external URLs)
- [ ] Token budget accuracy (actual word count)
- [ ] Security scanning (credentials, secrets)
- [ ] Performance testing (context usage)

## Best Practices

### Writing Tests

**Do:**
- ✅ Test one thing per file
- ✅ Clear error messages
- ✅ Exit code 0 for success, 1 for failure
- ✅ Print summary at the end
- ✅ Use emojis for visual clarity (✅ ❌ ⚠️)

**Don't:**
- ❌ Test multiple concerns in one file
- ❌ Silent failures
- ❌ Complex test logic
- ❌ External dependencies (keep tests fast)

### Test Output Format

```
=================================
Test Name
=================================

Running test step 1...
✅ Step 1 passed

Running test step 2...
❌ Step 2 failed
  - Error detail 1
  - Error detail 2

=================================
Test Summary
=================================

Passed: 1
Failed: 1

❌ Test failed
```

## Debugging Failed Tests

### Marketplace Validation Failures

```bash
# Check JSON syntax manually
python3 -m json.tool .claude-plugin/marketplace.json

# Validate schema
python3 tests/validate_marketplace.py
```

### Plugin Validation Failures

```bash
# Check specific plugin
python3 -m json.tool plugins/plugin-name/.claude-plugin/plugin.json

# Validate all plugins
python3 tests/validate_plugins.py
```

### CI/CD Failures

1. Check GitHub Actions logs
2. Reproduce locally: `make test`
3. Fix issues
4. Re-run: `make test`
5. Commit fixes

## Performance

All tests should complete in:
- **Marketplace validation:** <1 second
- **Plugin validation:** <3 seconds
- **Full test suite:** <10 seconds

If tests are slower, investigate and optimize.

## Contributing

When adding features to the marketplace:

1. **Write tests first** (TDD)
2. **Run tests locally:** `make test`
3. **Ensure CI passes** before merging
4. **Document new tests** in this README

See [CONTRIBUTING.md](../CONTRIBUTING.md) for full guidelines.

## Resources

### Python Testing
- [pytest Documentation](https://docs.pytest.org/)
- [unittest Documentation](https://docs.python.org/3/library/unittest.html)

### JSON Schema
- [JSON Schema Guide](https://json-schema.org/learn/getting-started-step-by-step)
- [Anthropic Plugin Schema](https://code.claude.com/docs/en/plugins)

### CI/CD
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Our CI/CD Workflow](../.github/workflows/validate.yml)

---

**Questions?** Open an issue or see [CONTRIBUTING.md](../CONTRIBUTING.md)
