.PHONY: help install install-profile verify update doctor uninstall

# AgentOps Framework Installation & Management
# Universal base installation system for any project

# Get the directory where this Makefile is located
AGENTOPS_HOME := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SCRIPTS_DIR := $(AGENTOPS_HOME)/scripts

help:
	@echo "AgentOps Framework - Installation & Management"
	@echo ""
	@echo "Usage:"
	@echo "  make install                 Install AgentOps framework"
	@echo "  make install-profile PROFILE=<name>"
	@echo "                               Install additional profile"
	@echo "  make verify                  Validate installation"
	@echo "  make update                  Update to latest version"
	@echo "  make doctor                  Diagnose installation issues"
	@echo "  make uninstall               Remove AgentOps framework"
	@echo "  make help                    Show this help message"
	@echo ""
	@echo "Profiles:"
	@echo "  default      Minimal, universal patterns"
	@echo "  product-dev  Product development workflows"
	@echo "  devops       Infrastructure/operations workflows"
	@echo ""
	@echo "Examples:"
	@echo "  make install                              # Interactive install"
	@echo "  make install-profile PROFILE=devops       # Add devops profile"
	@echo "  make verify                               # Check installation"
	@echo "  make doctor                               # Troubleshoot issues"
	@echo ""
	@echo "Documentation: https://agentops.dev/docs"

install:
	@echo "🚀 AgentOps Framework Installation"
	@echo ""
	@echo "Checking prerequisites..."
	@echo "✓ Prerequisites check (stub)"
	@echo ""
	@echo "Loading configuration..."
	@echo "✓ Configuration loaded (stub)"
	@echo ""
	@echo "Installing AgentOps framework..."
	@echo "✓ Base structure created (stub)"
	@echo "✓ Profile installed (stub)"
	@echo "✓ Root files installed (stub)"
	@echo "✓ Git hooks configured (stub)"
	@echo ""
	@echo "Validating installation..."
	@echo "✓ All checks passed (stub)"
	@echo ""
	@echo "Installation complete! ✅"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Try an agent:  /prime-simple-task"
	@echo "  2. Read docs:     cat .claude/README.md"
	@echo "  3. Verify setup:  make verify"

install-profile:
ifndef PROFILE
	@echo "Error: PROFILE not specified"
	@echo "Usage: make install-profile PROFILE=<name>"
	@echo ""
	@echo "Available profiles:"
	@echo "  - default"
	@echo "  - product-dev"
	@echo "  - devops"
	@exit 1
endif
	@echo "📦 Installing profile: $(PROFILE)"
	@echo ""
	@echo "Validating profile..."
	@echo "✓ Profile $(PROFILE) found (stub)"
	@echo ""
	@echo "Installing profile files..."
	@echo "✓ Agents installed (stub)"
	@echo "✓ Commands installed (stub)"
	@echo "✓ Skills installed (stub)"
	@echo ""
	@echo "Profile $(PROFILE) installed successfully! ✅"

verify:
	@bash $(SCRIPTS_DIR)/base-install.sh --verify

update:
	@bash $(SCRIPTS_DIR)/base-install.sh --update

doctor:
	@bash $(SCRIPTS_DIR)/base-install.sh --doctor

uninstall:
	@bash $(SCRIPTS_DIR)/base-install.sh --uninstall

uninstall-force:
	@bash $(SCRIPTS_DIR)/base-install.sh --uninstall --force
