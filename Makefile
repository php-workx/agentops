# Makefile for agentops (Orchestration Layer)
# Part of the Trinity: Mind (Philosophy) → Engine (Orchestration) → Voice (Presentation)

.PHONY: help trinity-validate trinity-status clean

# Default target
help:
	@echo "agentops - Orchestration Layer (The Engine)"
	@echo ""
	@echo "Trinity Targets:"
	@echo "  make trinity-validate  - Validate Trinity alignment across all repos"
	@echo "  make trinity-status    - Show Trinity integration status"
	@echo "  make help              - Show this help message"
	@echo ""
	@echo "Part of the Trinity architecture (v0.9.0)"

# Validate Trinity alignment
trinity-validate:
	@echo "Running Trinity validation..."
	@./scripts/validate-trinity.sh

# Show Trinity status
trinity-status:
	@echo "================================================"
	@echo "Trinity Integration Status"
	@echo "================================================"
	@echo ""
	@echo "Repository: agentops (Orchestration Layer - The Engine)"
	@echo "Role: Implement HOW to execute patterns"
	@echo ""
	@if [ -f VERSION ]; then \
		echo "Version: $$(cat VERSION)"; \
	else \
		echo "Version: NOT SET"; \
	fi
	@echo ""
	@echo "Universal files:"
	@if [ -f docs/project/TRINITY.md ]; then echo "  ✓ docs/project/TRINITY.md"; else echo "  ✗ docs/project/TRINITY.md"; fi
	@if [ -f VERSION ]; then echo "  ✓ VERSION"; else echo "  ✗ VERSION"; fi
	@if [ -f docs/project/MISSION.md ]; then echo "  ✓ docs/project/MISSION.md"; else echo "  ✗ docs/project/MISSION.md"; fi
	@echo ""
	@echo "Documentation:"
	@if [ -d docs/trinity ]; then echo "  ✓ docs/trinity/"; else echo "  ✗ docs/trinity/"; fi
	@if [ -f docs/trinity/implementation-map.md ]; then echo "  ✓ docs/trinity/implementation-map.md"; else echo "  ✗ docs/trinity/implementation-map.md"; fi
	@echo ""
	@echo "Sibling repositories:"
	@if [ -d ../12-factor-agentops ]; then echo "  ✓ 12-factor-agentops (Mind)"; else echo "  ✗ 12-factor-agentops (Mind) - NOT FOUND"; fi
	@if [ -d ../agentops-showcase ]; then echo "  ✓ agentops-showcase (Voice)"; else echo "  ✗ agentops-showcase (Voice) - NOT FOUND"; fi
	@echo ""
	@echo "For full validation: make trinity-validate"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type d -name "__pycache__" -delete 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean complete"
