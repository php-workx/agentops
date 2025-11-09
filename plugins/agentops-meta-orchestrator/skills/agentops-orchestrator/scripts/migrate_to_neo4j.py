#!/usr/bin/env python3
"""
Bulk Migration to Neo4j

One-time script to populate Neo4j with:
1. 400+ plugins from marketplace scans
2. Similarity relationships between plugins
3. Existing patterns from filesystem
4. Pattern-to-plugin USES relationships
"""

import argparse
import yaml
from pathlib import Path
from typing import List, Dict, Any

from plugin_scanner import PluginScanner
from neo4j_connector import Neo4jConnector


class Neo4jMigration:
    def __init__(self, neo4j_connector: Neo4jConnector):
        self.neo4j = neo4j_connector
        self.patterns_dir = Path("~/.claude/skills/meta-orchestrator/patterns").expanduser()

    def run_full_migration(self, min_similarity: float = 0.3):
        """Execute complete migration process"""
        print("="*70)
        print("NEO4J BULK MIGRATION")
        print("="*70)

        # Step 1: Setup schema
        print("\n" + "="*70)
        print("STEP 1: Schema Setup")
        print("="*70)
        self.neo4j.setup_schema()

        # Step 2: Scan and load plugins
        print("\n" + "="*70)
        print("STEP 2: Plugin Marketplace Scan & Load")
        print("="*70)
        plugins = self._scan_plugins()
        self._load_plugins(plugins)

        # Step 3: Compute similarities
        print("\n" + "="*70)
        print("STEP 3: Compute Plugin Similarities")
        print("="*70)
        self._compute_similarities(min_similarity)

        # Step 4: Load existing patterns
        print("\n" + "="*70)
        print("STEP 4: Load Existing Patterns")
        print("="*70)
        patterns = self._load_patterns_from_filesystem()
        self._import_patterns(patterns)

        # Step 5: Link patterns to plugins
        print("\n" + "="*70)
        print("STEP 5: Link Patterns to Plugins")
        print("="*70)
        self._link_patterns_to_plugins(patterns)

        # Step 6: Show statistics
        print("\n" + "="*70)
        print("MIGRATION COMPLETE - DATABASE STATISTICS")
        print("="*70)
        self._show_stats()

    def _scan_plugins(self) -> List[Dict[str, Any]]:
        """Scan all plugin marketplaces"""
        print("🔍 Scanning plugin marketplaces...")
        scanner = PluginScanner()
        plugins = scanner.scan_all_marketplaces()
        scanner.print_summary()
        return plugins

    def _load_plugins(self, plugins: List[Dict[str, Any]]):
        """Bulk load plugins into Neo4j"""
        if not plugins:
            print("⚠️  No plugins to load")
            return

        self.neo4j.bulk_create_plugins(plugins)

    def _compute_similarities(self, min_similarity: float):
        """Compute plugin similarity relationships"""
        self.neo4j.compute_plugin_similarities(min_similarity)

    def _load_patterns_from_filesystem(self) -> List[Dict[str, Any]]:
        """Load all existing patterns from filesystem"""
        print("📂 Loading patterns from filesystem...")

        patterns = []

        # Scan all lifecycle stages
        for stage in ["discovered", "validated", "learned"]:
            stage_dir = self.patterns_dir / stage
            if not stage_dir.exists():
                print(f"   ⚠️  Directory not found: {stage_dir}")
                continue

            # Find pattern files (markdown with YAML frontmatter)
            for pattern_file in stage_dir.glob("*.md"):
                try:
                    pattern = self._parse_pattern_file(pattern_file)
                    if pattern:
                        pattern["_stage"] = stage
                        pattern["_file"] = str(pattern_file)
                        patterns.append(pattern)
                        print(f"   ✓ Loaded: {pattern.get('pattern', {}).get('name', pattern_file.name)}")
                except Exception as e:
                    print(f"   ⚠️  Failed to load {pattern_file}: {e}")

            # Also check for YAML files
            for pattern_file in stage_dir.glob("*.yaml"):
                try:
                    with open(pattern_file, 'r') as f:
                        pattern = yaml.safe_load(f)
                        if pattern:
                            pattern["_stage"] = stage
                            pattern["_file"] = str(pattern_file)
                            patterns.append(pattern)
                            print(f"   ✓ Loaded: {pattern.get('pattern', {}).get('name', pattern_file.name)}")
                except Exception as e:
                    print(f"   ⚠️  Failed to load {pattern_file}: {e}")

        print(f"\n✅ Loaded {len(patterns)} patterns from filesystem")
        return patterns

    def _parse_pattern_file(self, file_path: Path) -> Dict[str, Any] | None:
        """Parse pattern file with YAML frontmatter"""
        with open(file_path, 'r') as f:
            content = f.read()

        # Check for YAML frontmatter
        if not content.startswith('---'):
            return None

        # Split frontmatter from body
        parts = content.split('---', 2)
        if len(parts) < 3:
            return None

        # Parse YAML frontmatter
        frontmatter = yaml.safe_load(parts[1])

        # Extract pattern data
        if isinstance(frontmatter, dict):
            # Some patterns have frontmatter metadata
            # Reconstruct pattern structure
            pattern = {
                "pattern": {
                    "id": frontmatter.get("pattern_id", file_path.stem),
                    "name": frontmatter.get("name", file_path.stem),
                    "description": frontmatter.get("description", ""),
                    "domain": frontmatter.get("category", frontmatter.get("domain", "general")),
                    "subdomain": frontmatter.get("subcategory", frontmatter.get("subdomain", "")),
                    "task_keywords": frontmatter.get("task_keywords", []),
                    "plugin_sequence": frontmatter.get("plugin_sequence", []),
                    "metrics": {
                        "total_executions": frontmatter.get("executions", 1),
                        "successful_executions": frontmatter.get("executions", 1),
                        "failed_executions": 0,
                        "success_rate": frontmatter.get("success_rate", 1.0),
                        "avg_completion_time": 0
                    },
                    "known_issues": frontmatter.get("known_issues", []),
                    "environment_requirements": frontmatter.get("environment_requirements", []),
                    "tags": frontmatter.get("tags", []),
                    "last_updated": frontmatter.get("last_used", frontmatter.get("created", "")),
                    "created": frontmatter.get("created", "")
                }
            }
            return pattern

        return None

    def _import_patterns(self, patterns: List[Dict[str, Any]]):
        """Import patterns into Neo4j"""
        if not patterns:
            print("⚠️  No patterns to import")
            return

        print(f"📦 Importing {len(patterns)} patterns...")

        success_count = 0
        for pattern in patterns:
            try:
                if self.neo4j.create_pattern(pattern):
                    success_count += 1
            except Exception as e:
                pattern_id = pattern.get("pattern", {}).get("id", "unknown")
                print(f"   ⚠️  Failed to import pattern {pattern_id}: {e}")

        print(f"✅ Imported {success_count}/{len(patterns)} patterns successfully")

    def _link_patterns_to_plugins(self, patterns: List[Dict[str, Any]]):
        """Create USES relationships from patterns to plugins"""
        print("🔗 Linking patterns to plugins...")

        link_count = 0
        for pattern in patterns:
            pattern_data = pattern.get("pattern", {})
            pattern_id = pattern_data.get("id", "")
            plugin_sequence = pattern_data.get("plugin_sequence", [])

            if not pattern_id or not plugin_sequence:
                continue

            try:
                self.neo4j.link_pattern_to_plugins(pattern_id, plugin_sequence)
                link_count += len(plugin_sequence)
            except Exception as e:
                print(f"   ⚠️  Failed to link pattern {pattern_id}: {e}")

        print(f"✅ Created {link_count} USES relationships")

    def _show_stats(self):
        """Display database statistics"""
        stats = self.neo4j.get_stats()

        print(f"\nPlugins: {stats['plugins']}")
        print(f"Patterns: {stats['patterns']}")
        print(f"Total Relationships: {stats['total_relationships']}")
        print(f"  ├─ SIMILAR_TO: {stats['similarity_relationships']}")
        print(f"  └─ USES: {stats['uses_relationships']}")

        print("\n" + "="*70)
        print("🎉 Migration Complete!")
        print("="*70)

        print("\nNext steps:")
        print("1. Verify data: Open Neo4j Browser at http://localhost:7474")
        print("2. Run sample queries:")
        print("   - MATCH (p:Plugin) RETURN p LIMIT 25")
        print("   - MATCH (pat:Pattern) RETURN pat")
        print("   - MATCH (p1:Plugin)-[s:SIMILAR_TO]->(p2:Plugin) RETURN p1, s, p2 LIMIT 10")
        print("3. Test pattern recommendations:")
        print("   - Update pattern_storage.py to dual-write to Neo4j")
        print("   - Execute a new workflow and verify data sync")


def main():
    parser = argparse.ArgumentParser(description="Bulk migration to Neo4j")
    parser.add_argument("--neo4j-uri", default=None, help="Neo4j connection URI")
    parser.add_argument("--neo4j-user", default=None, help="Neo4j username")
    parser.add_argument("--neo4j-password", default=None, help="Neo4j password")
    parser.add_argument("--min-similarity", type=float, default=0.3,
                       help="Minimum similarity score for relationships (0.0-1.0)")

    args = parser.parse_args()

    # Connect to Neo4j
    print("🔌 Connecting to Neo4j...")
    try:
        with Neo4jConnector(
            uri=args.neo4j_uri,
            user=args.neo4j_user,
            password=args.neo4j_password
        ) as neo4j:
            # Run migration
            migration = Neo4jMigration(neo4j)
            migration.run_full_migration(min_similarity=args.min_similarity)

    except Exception as e:
        print(f"\n❌ Migration failed: {e}")
        print("\nTroubleshooting:")
        print("1. Check that Neo4j is running: docker ps or podman ps")
        print("2. Verify NEO4J_PASSWORD environment variable is set")
        print("3. Ensure connection details are correct (default: bolt://localhost:7687)")
        return 1

    return 0


if __name__ == "__main__":
    exit(main())
