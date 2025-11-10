.PHONY: help validate test test-marketplace test-plugins clean install

# Default target
help:
	@echo "AgentOps Marketplace - Available Commands"
	@echo "=========================================="
	@echo ""
	@echo "Development:"
	@echo "  make validate          Run all validation checks"
	@echo "  make test              Run test suite (same as validate)"
	@echo "  make test-marketplace  Validate marketplace.json only"
	@echo "  make test-plugins      Validate plugin manifests only"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean             Clean temporary files"
	@echo "  make install           Install development dependencies"
	@echo ""
	@echo "Usage:"
	@echo "  make <command>"
	@echo ""

# Run all validations
validate: test-marketplace test-plugins
	@echo ""
	@echo "✅ All validations passed!"
	@echo ""

# Alias for validate
test: validate

# Validate marketplace.json
test-marketplace:
	@echo "Validating marketplace.json..."
	@python3 tests/validate_marketplace.py

# Validate plugin manifests
test-plugins:
	@echo "Validating plugin manifests..."
	@python3 tests/validate_plugins.py

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type f -name ".DS_Store" -delete
	@echo "✅ Clean complete"

# Install development dependencies (if needed in future)
install:
	@echo "Installing development dependencies..."
	@pip3 install --user PyYAML
	@echo "✅ Dependencies installed"
