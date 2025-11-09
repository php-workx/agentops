#!/usr/bin/env python3
"""
Neo4j Connector

Provides connection and data operations for Neo4j graph database.
"""

import os
from typing import List, Dict, Any, Optional
from datetime import datetime


class Neo4jConnector:
    """
    Neo4j connector for plugin and pattern graph operations.

    Requires: pip install neo4j

    Environment variables:
        NEO4J_URI - Neo4j connection URI (default: bolt://localhost:7687)
        NEO4J_USER - Neo4j username (default: neo4j)
        NEO4J_PASSWORD - Neo4j password (required)
    """

    def __init__(self, uri: Optional[str] = None, user: Optional[str] = None, password: Optional[str] = None):
        """Initialize Neo4j connection"""
        try:
            from neo4j import GraphDatabase
        except ImportError:
            raise ImportError("Neo4j driver not installed. Run: pip install neo4j")

        self.uri = uri or os.getenv("NEO4J_URI", "bolt://localhost:7687")
        self.user = user or os.getenv("NEO4J_USER", "neo4j")
        self.password = password or os.getenv("NEO4J_PASSWORD")

        if not self.password:
            raise ValueError("NEO4J_PASSWORD environment variable must be set")

        self.driver = GraphDatabase.driver(self.uri, auth=(self.user, self.password))

        # Verify connection
        self.driver.verify_connectivity()
        print(f"✓ Connected to Neo4j at {self.uri}")

    def close(self):
        """Close Neo4j connection"""
        if self.driver:
            self.driver.close()
            print("✓ Neo4j connection closed")

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    # ===== SCHEMA SETUP =====

    def setup_schema(self):
        """Create constraints and indexes"""
        print("🔧 Setting up Neo4j schema...")

        with self.driver.session() as session:
            # Constraints
            session.run("""
                CREATE CONSTRAINT plugin_name_unique IF NOT EXISTS
                FOR (p:Plugin) REQUIRE p.name IS UNIQUE
            """)

            session.run("""
                CREATE CONSTRAINT pattern_id_unique IF NOT EXISTS
                FOR (p:Pattern) REQUIRE p.pattern_id IS UNIQUE
            """)

            session.run("""
                CREATE CONSTRAINT execution_id_unique IF NOT EXISTS
                FOR (e:Execution) REQUIRE e.execution_id IS UNIQUE
            """)

            # Indexes
            session.run("""
                CREATE INDEX plugin_category IF NOT EXISTS
                FOR (p:Plugin) ON (p.category)
            """)

            session.run("""
                CREATE INDEX plugin_success_rate IF NOT EXISTS
                FOR (p:Plugin) ON (p.success_rate)
            """)

            session.run("""
                CREATE INDEX pattern_category IF NOT EXISTS
                FOR (p:Pattern) ON (p.category)
            """)

            session.run("""
                CREATE INDEX pattern_success_rate IF NOT EXISTS
                FOR (p:Pattern) ON (p.success_rate)
            """)

            session.run("""
                CREATE INDEX pattern_status IF NOT EXISTS
                FOR (p:Pattern) ON (p.status)
            """)

            # Full-text search indexes
            try:
                session.run("""
                    CREATE FULLTEXT INDEX plugin_search IF NOT EXISTS
                    FOR (p:Plugin) ON EACH [p.name, p.description]
                """)
            except:
                # May fail if already exists in older Neo4j versions
                pass

            try:
                session.run("""
                    CREATE FULLTEXT INDEX pattern_search IF NOT EXISTS
                    FOR (p:Pattern) ON EACH [p.name, p.description]
                """)
            except:
                pass

        print("✓ Schema setup complete")

    # ===== PLUGIN OPERATIONS =====

    def create_plugin(self, plugin_data: Dict[str, Any]) -> bool:
        """Create a single plugin node"""
        with self.driver.session() as session:
            result = session.run("""
                MERGE (p:Plugin {name: $name})
                SET p.description = $description,
                    p.category = $category,
                    p.marketplace = $marketplace,
                    p.version = $version,
                    p.success_rate = $success_rate,
                    p.total_uses = COALESCE(p.total_uses, 0),
                    p.last_used = $last_used,
                    p.tags = $tags
                RETURN p.name as name
            """,
                name=plugin_data["name"],
                description=plugin_data.get("description", ""),
                category=plugin_data.get("category", "general"),
                marketplace=plugin_data.get("marketplace", "unknown"),
                version=plugin_data.get("version", "1.0.0"),
                success_rate=plugin_data.get("estimated_success_rate", 0.0),
                last_used=None,
                tags=plugin_data.get("tags", [])
            )

            return result.single() is not None

    def bulk_create_plugins(self, plugins: List[Dict[str, Any]]) -> int:
        """Bulk create plugin nodes"""
        print(f"📦 Bulk creating {len(plugins)} plugins...")

        count = 0
        with self.driver.session() as session:
            # Use UNWIND for batch processing
            result = session.run("""
                UNWIND $plugins as plugin
                MERGE (p:Plugin {name: plugin.name})
                SET p.description = plugin.description,
                    p.category = plugin.category,
                    p.marketplace = plugin.marketplace,
                    p.version = plugin.version,
                    p.success_rate = plugin.success_rate,
                    p.total_uses = 0,
                    p.last_used = null,
                    p.tags = plugin.tags
                RETURN count(p) as count
            """,
                plugins=[{
                    "name": p["name"],
                    "description": p.get("description", ""),
                    "category": p.get("category", "general"),
                    "marketplace": p.get("marketplace", "unknown"),
                    "version": p.get("version", "1.0.0"),
                    "success_rate": p.get("estimated_success_rate", 0.0),
                    "tags": p.get("tags", [])
                } for p in plugins]
            )

            count = result.single()["count"]

        print(f"✓ Created {count} plugin nodes")
        return count

    def compute_plugin_similarities(self, min_similarity: float = 0.3):
        """Compute and create SIMILAR_TO relationships based on tag overlap"""
        print(f"🔗 Computing plugin similarities (min similarity: {min_similarity})...")

        with self.driver.session() as session:
            result = session.run("""
                MATCH (p1:Plugin), (p2:Plugin)
                WHERE id(p1) < id(p2)
                  AND size(p1.tags) > 0
                  AND size(p2.tags) > 0
                WITH p1, p2,
                     [tag IN p1.tags WHERE tag IN p2.tags] as shared_tags,
                     p1.tags + [tag IN p2.tags WHERE NOT tag IN p1.tags] as all_tags
                WITH p1, p2, shared_tags, all_tags,
                     toFloat(size(shared_tags)) / size(all_tags) as similarity
                WHERE similarity >= $min_similarity
                MERGE (p1)-[s:SIMILAR_TO]-(p2)
                SET s.similarity_score = similarity,
                    s.shared_tags = shared_tags,
                    s.computed_at = datetime()
                RETURN count(s) as count
            """, min_similarity=min_similarity)

            count = result.single()["count"]

        print(f"✓ Created {count} similarity relationships")
        return count

    # ===== PATTERN OPERATIONS =====

    def create_pattern(self, pattern_data: Dict[str, Any]) -> bool:
        """Create a single pattern node"""
        pattern = pattern_data.get("pattern", pattern_data)

        with self.driver.session() as session:
            result = session.run("""
                MERGE (p:Pattern {pattern_id: $pattern_id})
                SET p.name = $name,
                    p.description = $description,
                    p.category = $category,
                    p.success_rate = $success_rate,
                    p.executions = $executions,
                    p.status = $status,
                    p.workflow_steps = $workflow_steps,
                    p.created_at = datetime($created_at),
                    p.last_used = datetime($last_used)
                RETURN p.pattern_id as pattern_id
            """,
                pattern_id=pattern.get("id", pattern.get("pattern_id", "unknown")),
                name=pattern.get("name", "Unnamed Pattern"),
                description=pattern.get("description", ""),
                category=pattern.get("domain", pattern.get("category", "general")),
                success_rate=pattern.get("metrics", {}).get("success_rate", 0.0),
                executions=pattern.get("metrics", {}).get("total_executions", 0),
                status=self._determine_pattern_status(pattern.get("metrics", {})),
                workflow_steps=str(pattern.get("plugin_sequence", [])),
                created_at=pattern.get("created", datetime.utcnow().isoformat() + "Z"),
                last_used=pattern.get("last_updated", datetime.utcnow().isoformat() + "Z")
            )

            return result.single() is not None

    def _determine_pattern_status(self, metrics: Dict[str, Any]) -> str:
        """Determine pattern status from metrics"""
        executions = metrics.get("total_executions", 0)
        success_rate = metrics.get("success_rate", 0.0)

        if executions >= 20 and success_rate >= 0.90:
            return "learned"
        elif executions >= 5 and success_rate >= 0.80:
            return "validated"
        else:
            return "discovered"

    def link_pattern_to_plugins(self, pattern_id: str, plugin_sequence: List[Dict[str, Any]]):
        """Create USES relationships from pattern to plugins"""
        with self.driver.session() as session:
            for i, step in enumerate(plugin_sequence, 1):
                plugin_name = step.get("plugin", "")
                if not plugin_name:
                    continue

                session.run("""
                    MATCH (pat:Pattern {pattern_id: $pattern_id})
                    MATCH (plugin:Plugin {name: $plugin_name})
                    MERGE (pat)-[u:USES]->(plugin)
                    SET u.step_number = $step_number,
                        u.required = true,
                        u.purpose = $purpose
                """,
                    pattern_id=pattern_id,
                    plugin_name=plugin_name,
                    step_number=i,
                    purpose=step.get("purpose", "")
                )

    # ===== EXECUTION OPERATIONS =====

    def create_execution(self, execution_data: Dict[str, Any]) -> bool:
        """Create an execution node"""
        with self.driver.session() as session:
            result = session.run("""
                CREATE (e:Execution {
                    execution_id: $execution_id,
                    task_description: $task_description,
                    status: $status,
                    duration_ms: $duration_ms,
                    started_at: datetime($started_at),
                    completed_at: datetime($completed_at),
                    error_message: $error_message
                })
                RETURN e.execution_id as execution_id
            """,
                execution_id=execution_data.get("execution_id", ""),
                task_description=execution_data.get("task_description", ""),
                status=execution_data.get("status", "unknown"),
                duration_ms=int(execution_data.get("duration_ms", 0)),
                started_at=execution_data.get("started_at", datetime.utcnow().isoformat() + "Z"),
                completed_at=execution_data.get("completed_at", datetime.utcnow().isoformat() + "Z"),
                error_message=execution_data.get("error_message", "")
            )

            return result.single() is not None

    def link_execution_to_pattern(self, execution_id: str, pattern_id: str):
        """Link execution to pattern"""
        with self.driver.session() as session:
            session.run("""
                MATCH (e:Execution {execution_id: $execution_id})
                MATCH (p:Pattern {pattern_id: $pattern_id})
                MERGE (e)-[:IMPLEMENTS]->(p)
            """, execution_id=execution_id, pattern_id=pattern_id)

    # ===== QUERY OPERATIONS =====

    def get_plugin_count(self) -> int:
        """Get total number of plugins"""
        with self.driver.session() as session:
            result = session.run("MATCH (p:Plugin) RETURN count(p) as count")
            return result.single()["count"]

    def get_pattern_count(self) -> int:
        """Get total number of patterns"""
        with self.driver.session() as session:
            result = session.run("MATCH (p:Pattern) RETURN count(p) as count")
            return result.single()["count"]

    def get_relationship_count(self, rel_type: str = None) -> int:
        """Get total number of relationships"""
        with self.driver.session() as session:
            if rel_type:
                result = session.run(f"MATCH ()-[r:{rel_type}]->() RETURN count(r) as count")
            else:
                result = session.run("MATCH ()-[r]->() RETURN count(r) as count")
            return result.single()["count"]

    def search_patterns(self, query: str, limit: int = 5) -> List[Dict[str, Any]]:
        """Search patterns by keywords"""
        with self.driver.session() as session:
            result = session.run("""
                MATCH (p:Pattern)
                WHERE p.name CONTAINS $query OR p.description CONTAINS $query
                RETURN p.pattern_id as pattern_id,
                       p.name as name,
                       p.description as description,
                       p.success_rate as success_rate,
                       p.executions as executions,
                       p.status as status
                ORDER BY p.success_rate DESC, p.executions DESC
                LIMIT $limit
            """, query=query, limit=limit)

            return [record.data() for record in result]

    def find_similar_plugins(self, plugin_name: str, min_similarity: float = 0.5, limit: int = 5) -> List[Dict[str, Any]]:
        """Find plugins similar to the given plugin"""
        with self.driver.session() as session:
            result = session.run("""
                MATCH (p:Plugin {name: $plugin_name})-[s:SIMILAR_TO]-(similar:Plugin)
                WHERE s.similarity_score >= $min_similarity
                RETURN similar.name as name,
                       similar.description as description,
                       similar.category as category,
                       similar.success_rate as success_rate,
                       s.similarity_score as similarity,
                       s.shared_tags as shared_tags
                ORDER BY s.similarity_score DESC, similar.success_rate DESC
                LIMIT $limit
            """, plugin_name=plugin_name, min_similarity=min_similarity, limit=limit)

            return [record.data() for record in result]

    def get_stats(self) -> Dict[str, Any]:
        """Get database statistics"""
        stats = {
            "plugins": self.get_plugin_count(),
            "patterns": self.get_pattern_count(),
            "total_relationships": self.get_relationship_count(),
            "similarity_relationships": self.get_relationship_count("SIMILAR_TO"),
            "uses_relationships": self.get_relationship_count("USES")
        }
        return stats
