#!/usr/bin/env python3
"""
Pattern Storage Automation Script

Automates pattern extraction, storage, lifecycle management, and metrics tracking.
Supports dual-write to filesystem and Neo4j graph database.
"""

import argparse
import json
import yaml
import os
import uuid
from datetime import datetime
from pathlib import Path
from typing import Dict, Any, Optional

try:
    from neo4j_connector import Neo4jConnector
    NEO4J_AVAILABLE = True
except ImportError:
    NEO4J_AVAILABLE = False


class PatternStorage:
    def __init__(self, base_dir: str = "~/.claude/skills/meta-orchestrator", neo4j_connector: Optional['Neo4jConnector'] = None):
        self.base_dir = Path(base_dir).expanduser()
        self.patterns_dir = self.base_dir / "patterns"
        self.metrics_dir = self.base_dir / "metrics"
        self.neo4j = neo4j_connector

        # Create directory structure
        self._init_directories()

        if self.neo4j:
            print("✓ Neo4j dual-write enabled")
    
    def _init_directories(self):
        """Create directory structure if not exists"""
        (self.patterns_dir / "discovered").mkdir(parents=True, exist_ok=True)
        (self.patterns_dir / "validated").mkdir(parents=True, exist_ok=True)
        (self.patterns_dir / "learned").mkdir(parents=True, exist_ok=True)
        (self.patterns_dir / "deprecated").mkdir(parents=True, exist_ok=True)
        self.metrics_dir.mkdir(parents=True, exist_ok=True)
    
    def extract_pattern(self, workflow_result: Dict[str, Any]) -> Dict[str, Any]:
        """Extract pattern from workflow execution result"""
        
        # Generate pattern ID
        pattern_id = self._generate_pattern_id(workflow_result)
        
        # Check if pattern already exists
        existing_pattern = self._find_existing_pattern(pattern_id)
        
        if existing_pattern:
            # Update existing pattern
            pattern = self._update_pattern(existing_pattern, workflow_result)
        else:
            # Create new pattern
            pattern = self._create_pattern(pattern_id, workflow_result)
        
        return pattern
    
    def _generate_pattern_id(self, workflow_result: Dict[str, Any]) -> str:
        """Generate unique pattern ID from workflow"""
        task_desc = workflow_result.get("task_description", "")
        
        # Extract keywords and create ID
        keywords = task_desc.lower().split()[:5]
        pattern_id = "-".join(keywords) + "-v1"
        
        return pattern_id.replace(" ", "-").replace(",", "")
    
    def _find_existing_pattern(self, pattern_id: str) -> Dict[str, Any] | None:
        """Find existing pattern across all lifecycle stages"""
        for stage in ["discovered", "validated", "learned"]:
            pattern_file = self.patterns_dir / stage / f"{pattern_id}.yaml"
            if pattern_file.exists():
                with open(pattern_file, 'r') as f:
                    return yaml.safe_load(f)
        return None
    
    def _create_pattern(self, pattern_id: str, workflow_result: Dict[str, Any]) -> Dict[str, Any]:
        """Create new pattern from workflow result"""
        
        pattern = {
            "pattern": {
                "id": pattern_id,
                "name": workflow_result.get("task_description", "Unnamed Pattern"),
                "description": workflow_result.get("task_description", ""),
                "domain": self._infer_domain(workflow_result),
                "subdomain": "",
                "task_keywords": self._extract_keywords(workflow_result),
                "plugin_sequence": self._extract_plugin_sequence(workflow_result),
                "metrics": {
                    "total_executions": 1,
                    "successful_executions": 1 if workflow_result.get("success") else 0,
                    "failed_executions": 0 if workflow_result.get("success") else 1,
                    "success_rate": 1.0 if workflow_result.get("success") else 0.0,
                    "avg_completion_time": workflow_result.get("execution_time", 0)
                },
                "known_issues": [],
                "environment_requirements": workflow_result.get("environment_requirements", []),
                "tags": self._extract_tags(workflow_result),
                "last_updated": datetime.utcnow().isoformat() + "Z",
                "created": datetime.utcnow().isoformat() + "Z"
            }
        }
        
        return pattern
    
    def _update_pattern(self, existing_pattern: Dict[str, Any], workflow_result: Dict[str, Any]) -> Dict[str, Any]:
        """Update existing pattern with new execution data"""
        
        pattern = existing_pattern["pattern"]
        metrics = pattern["metrics"]
        
        # Update execution counts
        metrics["total_executions"] += 1
        if workflow_result.get("success"):
            metrics["successful_executions"] += 1
        else:
            metrics["failed_executions"] += 1
        
        # Recalculate success rate
        metrics["success_rate"] = metrics["successful_executions"] / metrics["total_executions"]
        
        # Update average completion time
        old_avg = metrics["avg_completion_time"]
        new_time = workflow_result.get("execution_time", 0)
        total = metrics["total_executions"]
        metrics["avg_completion_time"] = (old_avg * (total - 1) + new_time) / total
        
        # Add any new known issues
        if not workflow_result.get("success"):
            error = workflow_result.get("error", "Unknown error")
            self._add_known_issue(pattern, error)
        
        # Update timestamp
        pattern["last_updated"] = datetime.utcnow().isoformat() + "Z"
        
        return existing_pattern
    
    def _infer_domain(self, workflow_result: Dict[str, Any]) -> str:
        """Infer domain from workflow result"""
        task = workflow_result.get("task_description", "").lower()
        
        if any(kw in task for kw in ["api", "web", "frontend", "backend", "next", "react"]):
            return "web-development"
        elif any(kw in task for kw in ["docker", "kubernetes", "deploy", "ci/cd", "pipeline"]):
            return "devops"
        elif any(kw in task for kw in ["etl", "data", "bigquery", "spark", "airflow"]):
            return "data-engineering"
        elif any(kw in task for kw in ["security", "audit", "vulnerability", "secret"]):
            return "security"
        elif any(kw in task for kw in ["test", "pytest", "jest", "e2e"]):
            return "testing"
        elif any(kw in task for kw in ["ml", "model", "pytorch", "tensorflow", "training"]):
            return "ai-ml"
        else:
            return "general"
    
    def _extract_keywords(self, workflow_result: Dict[str, Any]) -> list:
        """Extract keywords from workflow result"""
        task = workflow_result.get("task_description", "").lower()
        
        # Common words to ignore
        stop_words = {"a", "an", "the", "with", "and", "or", "for", "to", "from", "in", "on"}
        
        keywords = [word for word in task.split() if word not in stop_words]
        return keywords[:10]  # Limit to 10 keywords
    
    def _extract_plugin_sequence(self, workflow_result: Dict[str, Any]) -> list:
        """Extract plugin sequence from workflow result"""
        steps = workflow_result.get("steps", [])
        
        sequence = []
        for step in steps:
            sequence.append({
                "plugin": step.get("plugin", ""),
                "purpose": step.get("purpose", ""),
                "avg_time": step.get("execution_time", 0),
                "success_rate": 1.0 if step.get("success") else 0.0
            })
        
        return sequence
    
    def _extract_tags(self, workflow_result: Dict[str, Any]) -> list:
        """Extract tags from workflow result"""
        tags = []
        task = workflow_result.get("task_description", "").lower()
        
        # Domain tags
        if "api" in task:
            tags.append("api")
        if any(kw in task for kw in ["auth", "authentication"]):
            tags.append("authentication")
        if "cache" in task or "caching" in task:
            tags.append("caching")
        if "deploy" in task:
            tags.append("deployment")
        if "test" in task:
            tags.append("testing")
        
        return tags
    
    def _add_known_issue(self, pattern: Dict[str, Any], error: str):
        """Add or update known issue in pattern"""
        issues = pattern.get("known_issues", [])
        
        # Check if issue already exists
        for issue in issues:
            if issue["issue"] == error:
                issue["frequency"] += 1
                return
        
        # Add new issue
        issues.append({
            "issue": error,
            "frequency": 1,
            "fix": "Manual investigation required"
        })
    
    def save_pattern(self, pattern: Dict[str, Any]) -> str:
        """Save pattern to appropriate lifecycle stage (filesystem + Neo4j)"""
        pattern_data = pattern["pattern"]
        pattern_id = pattern_data["id"]
        metrics = pattern_data["metrics"]

        # Determine lifecycle stage
        stage = self._determine_stage(metrics)

        # Save to filesystem
        pattern_file = self.patterns_dir / stage / f"{pattern_id}.yaml"
        with open(pattern_file, 'w') as f:
            yaml.dump(pattern, f, default_flow_style=False, sort_keys=False)

        print(f"✓ Pattern saved to filesystem: {pattern_file}")

        # Also save to Neo4j if enabled
        if self.neo4j:
            try:
                self.neo4j.create_pattern(pattern)
                print(f"✓ Pattern synced to Neo4j: {pattern_id}")

                # Link pattern to plugins
                plugin_sequence = pattern_data.get("plugin_sequence", [])
                if plugin_sequence:
                    self.neo4j.link_pattern_to_plugins(pattern_id, plugin_sequence)
                    print(f"✓ Linked pattern to {len(plugin_sequence)} plugins")

            except Exception as e:
                print(f"⚠️  Neo4j sync failed: {e}")
                print("   (Pattern still saved to filesystem)")

        return str(pattern_file)
    
    def _determine_stage(self, metrics: Dict[str, Any]) -> str:
        """Determine lifecycle stage for pattern"""
        executions = metrics["total_executions"]
        success_rate = metrics["success_rate"]
        
        if executions >= 20 and success_rate >= 0.90:
            return "learned"
        elif executions >= 5 and success_rate >= 0.80:
            return "validated"
        else:
            return "discovered"
    
    def log_execution(self, pattern_id: str, success: bool, duration: float, task_description: str = ""):
        """Log execution to metrics file and Neo4j"""
        timestamp = datetime.utcnow().isoformat() + "Z"
        log_file = self.metrics_dir / "executions.log"

        # Log to filesystem
        with open(log_file, 'a') as f:
            f.write(f"{timestamp},{pattern_id},{'success' if success else 'failure'},{duration}\n")

        print(f"✓ Execution logged to filesystem: {log_file}")

        # Also log to Neo4j if enabled
        if self.neo4j:
            try:
                execution_id = f"exec_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}"
                execution_data = {
                    "execution_id": execution_id,
                    "task_description": task_description,
                    "status": "success" if success else "failed",
                    "duration_ms": int(duration * 60 * 1000),  # Convert minutes to ms
                    "started_at": timestamp,
                    "completed_at": timestamp,
                    "error_message": "" if success else "Execution failed"
                }

                self.neo4j.create_execution(execution_data)
                self.neo4j.link_execution_to_pattern(execution_id, pattern_id)
                print(f"✓ Execution synced to Neo4j: {execution_id}")

            except Exception as e:
                print(f"⚠️  Neo4j execution logging failed: {e}")
    
    def update_success_rate(self, pattern_id: str, success_rate: float):
        """Update success rate log"""
        timestamp = datetime.utcnow().isoformat() + "Z"
        log_file = self.metrics_dir / "success_rates.log"
        
        with open(log_file, 'a') as f:
            f.write(f"{timestamp},{pattern_id},{success_rate}\n")
        
        print(f"✓ Success rate updated: {log_file}")
    
    def update_pattern_index(self, pattern: Dict[str, Any]):
        """Update pattern index in README.md"""
        pattern_data = pattern["pattern"]
        index_file = self.patterns_dir / "README.md"
        
        # Read existing index
        if index_file.exists():
            with open(index_file, 'r') as f:
                content = f.read()
        else:
            content = "# Pattern Library\n\n"
        
        # Add or update pattern entry
        entry = f"- **{pattern_data['name']}** ({pattern_data['id']})\n"
        entry += f"  - Success rate: {pattern_data['metrics']['success_rate']:.1%}\n"
        entry += f"  - Executions: {pattern_data['metrics']['total_executions']}\n"
        entry += f"  - Domain: {pattern_data['domain']}\n\n"
        
        # Append if not exists
        if pattern_data['id'] not in content:
            content += entry
        
        with open(index_file, 'w') as f:
            f.write(content)
        
        print(f"✓ Pattern index updated: {index_file}")


def main():
    parser = argparse.ArgumentParser(description="Pattern Storage Automation")
    parser.add_argument("--workflow-result", required=True, help="Path to workflow result JSON file")
    parser.add_argument("--pattern-id", help="Optional pattern ID (auto-generated if not provided)")
    parser.add_argument("--base-dir", default="~/.claude/skills/meta-orchestrator", help="Base directory for patterns")
    parser.add_argument("--enable-neo4j", action="store_true", help="Enable Neo4j dual-write")
    parser.add_argument("--neo4j-uri", default=None, help="Neo4j connection URI")
    parser.add_argument("--neo4j-user", default=None, help="Neo4j username")
    parser.add_argument("--neo4j-password", default=None, help="Neo4j password")

    args = parser.parse_args()

    # Load workflow result
    with open(args.workflow_result, 'r') as f:
        workflow_result = json.load(f)

    # Initialize Neo4j connector if requested
    neo4j_connector = None
    if args.enable_neo4j:
        if not NEO4J_AVAILABLE:
            print("⚠️  Neo4j connector not available. Install with: pip install neo4j")
            print("   Continuing with filesystem-only storage...")
        else:
            try:
                neo4j_connector = Neo4jConnector(
                    uri=args.neo4j_uri,
                    user=args.neo4j_user,
                    password=args.neo4j_password
                )
            except Exception as e:
                print(f"⚠️  Failed to connect to Neo4j: {e}")
                print("   Continuing with filesystem-only storage...")

    # Initialize storage
    storage = PatternStorage(args.base_dir, neo4j_connector=neo4j_connector)
    
    # Extract or update pattern
    print("🔍 Extracting pattern...")
    pattern = storage.extract_pattern(workflow_result)
    
    # Save pattern
    print("💾 Saving pattern...")
    pattern_file = storage.save_pattern(pattern)
    
    # Log execution
    print("📊 Logging execution...")
    pattern_id = pattern["pattern"]["id"]
    storage.log_execution(
        pattern_id,
        workflow_result.get("success", False),
        workflow_result.get("execution_time", 0),
        task_description=workflow_result.get("task_description", "")
    )

    # Update success rate
    storage.update_success_rate(
        pattern_id,
        pattern["pattern"]["metrics"]["success_rate"]
    )

    # Update index
    print("📚 Updating pattern index...")
    storage.update_pattern_index(pattern)

    # Close Neo4j connection if active
    if neo4j_connector:
        neo4j_connector.close()

    print("\n✅ Pattern storage complete!")
    print(f"Pattern ID: {pattern_id}")
    print(f"Pattern file: {pattern_file}")
    print(f"Success rate: {pattern['pattern']['metrics']['success_rate']:.1%}")
    print(f"Total executions: {pattern['pattern']['metrics']['total_executions']}")

    if args.enable_neo4j:
        if neo4j_connector:
            print("✓ Pattern synced to Neo4j")
        else:
            print("⚠️  Neo4j sync was requested but failed - data saved to filesystem only")


if __name__ == "__main__":
    main()
