#!/usr/bin/env python3
"""
Pattern Matcher Script

Matches user requests to existing patterns in the pattern library.
"""

import argparse
import yaml
from pathlib import Path
from typing import List, Dict, Any, Tuple
from datetime import datetime
import re


class PatternMatcher:
    def __init__(self, base_dir: str = "~/.claude/skills/meta-orchestrator"):
        self.base_dir = Path(base_dir).expanduser()
        self.patterns_dir = self.base_dir / "patterns"
        self.pattern_library = []
        
        # Load all patterns
        self._load_patterns()
    
    def _load_patterns(self):
        """Load all patterns from filesystem"""
        # Priority: learned > validated > discovered
        for stage in ["learned", "validated", "discovered"]:
            stage_dir = self.patterns_dir / stage
            if not stage_dir.exists():
                continue
            
            for pattern_file in stage_dir.glob("*.yaml"):
                try:
                    with open(pattern_file, 'r') as f:
                        pattern_data = yaml.safe_load(f)
                        pattern_data["pattern"]["_stage"] = stage
                        pattern_data["pattern"]["_file"] = str(pattern_file)
                        self.pattern_library.append(pattern_data["pattern"])
                except Exception as e:
                    print(f"⚠️ Failed to load {pattern_file}: {e}")
        
        print(f"✓ Loaded {len(self.pattern_library)} patterns")
    
    def extract_keywords(self, text: str) -> List[str]:
        """Extract keywords from text"""
        # Convert to lowercase and split
        words = text.lower().split()
        
        # Remove common stop words
        stop_words = {
            "a", "an", "the", "with", "and", "or", "for", "to", "from", 
            "in", "on", "at", "by", "of", "as", "is", "are", "was", "were",
            "build", "create", "make", "setup", "set", "up", "my", "i", "me"
        }
        
        keywords = [w for w in words if w not in stop_words and len(w) > 2]
        
        return keywords
    
    def match_patterns(self, user_request: str, top_k: int = 3) -> List[Tuple[Dict[str, Any], float]]:
        """Match user request to patterns"""
        
        # Extract keywords from request
        request_keywords = set(self.extract_keywords(user_request))
        
        if not request_keywords:
            print("⚠️ No keywords extracted from request")
            return []
        
        print(f"Keywords extracted: {request_keywords}")
        
        # Find candidates with keyword overlap
        candidates = []
        
        for pattern in self.pattern_library:
            pattern_keywords = set(pattern.get("task_keywords", []))
            overlap = request_keywords & pattern_keywords
            
            if len(overlap) >= 2:  # At least 2 matching keywords
                keyword_score = len(overlap) / len(pattern_keywords) if pattern_keywords else 0
                candidates.append((pattern, keyword_score))
        
        if not candidates:
            print("⚠️ No matching patterns found (need at least 2 keyword matches)")
            return []
        
        print(f"Found {len(candidates)} candidate patterns")
        
        # Rank candidates
        ranked = self._rank_patterns(candidates)
        
        # Return top K
        return ranked[:top_k]
    
    def _rank_patterns(self, candidates: List[Tuple[Dict[str, Any], float]]) -> List[Tuple[Dict[str, Any], float]]:
        """Rank patterns by multiple factors"""
        
        weights = {
            "keyword_match": 0.4,
            "success_rate": 0.3,
            "usage_count": 0.2,
            "recency": 0.1
        }
        
        scored_patterns = []
        
        for pattern, keyword_score in candidates:
            metrics = pattern.get("metrics", {})
            
            # Normalize metrics to 0-1 range
            keyword_norm = keyword_score
            success_norm = metrics.get("success_rate", 0.0)
            usage_norm = min(metrics.get("total_executions", 0) / 100, 1.0)
            recency_norm = self._calculate_recency_score(pattern.get("last_updated"))
            
            # Calculate weighted score
            total_score = (
                keyword_norm * weights["keyword_match"] +
                success_norm * weights["success_rate"] +
                usage_norm * weights["usage_count"] +
                recency_norm * weights["recency"]
            )
            
            scored_patterns.append((pattern, total_score))
        
        # Sort by score (descending)
        scored_patterns.sort(key=lambda x: x[1], reverse=True)
        
        return scored_patterns
    
    def _calculate_recency_score(self, last_updated: str | None) -> float:
        """Calculate recency score (more recent = higher score)"""
        if not last_updated:
            return 0.0
        
        try:
            updated_date = datetime.fromisoformat(last_updated.replace('Z', '+00:00'))
            days_ago = (datetime.now(updated_date.tzinfo) - updated_date).days
            
            if days_ago < 7:
                return 1.0
            elif days_ago < 30:
                return 0.8
            elif days_ago < 90:
                return 0.5
            else:
                return 0.2
        except:
            return 0.5  # Default for parsing errors
    
    def display_results(self, matches: List[Tuple[Dict[str, Any], float]]):
        """Display matching patterns in a readable format"""
        
        if not matches:
            print("\n❌ No matching patterns found")
            print("\nSuggestions:")
            print("  - Try broader keywords")
            print("  - Check if patterns exist: ls ~/.claude/skills/meta-orchestrator/patterns/")
            print("  - This might be a new workflow that will create a pattern!")
            return
        
        print(f"\n✅ Found {len(matches)} matching pattern(s):\n")
        
        for i, (pattern, score) in enumerate(matches, 1):
            print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print(f"Match {i}: {pattern.get('name', 'Unnamed Pattern')}")
            print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            print(f"Pattern ID: {pattern.get('id', 'unknown')}")
            print(f"Match Score: {score:.3f} (0.0-1.0)")
            print(f"Stage: {pattern.get('_stage', 'unknown')}")
            print(f"Domain: {pattern.get('domain', 'unknown')}")
            
            metrics = pattern.get("metrics", {})
            print(f"\nMetrics:")
            print(f"  Success Rate: {metrics.get('success_rate', 0):.1%}")
            print(f"  Total Executions: {metrics.get('total_executions', 0)}")
            print(f"  Avg Completion Time: {metrics.get('avg_completion_time', 0):.1f} minutes")
            
            print(f"\nPlugin Sequence ({len(pattern.get('plugin_sequence', []))} steps):")
            for j, step in enumerate(pattern.get('plugin_sequence', []), 1):
                print(f"  {j}. {step.get('plugin', 'unknown')} - {step.get('purpose', '')}")
            
            known_issues = pattern.get('known_issues', [])
            if known_issues:
                print(f"\nKnown Issues ({len(known_issues)}):")
                for issue in known_issues[:3]:  # Show max 3
                    print(f"  • {issue.get('issue', 'Unknown')} (occurred {issue.get('frequency', 0)} times)")
            
            print(f"\nFile: {pattern.get('_file', 'unknown')}")
            print()
    
    def get_recommendation(self, matches: List[Tuple[Dict[str, Any], float]]) -> Dict[str, Any] | None:
        """Get top recommendation with explanation"""
        if not matches:
            return None
        
        top_pattern, top_score = matches[0]
        
        # Determine confidence level
        if top_score >= 0.8:
            confidence = "High"
            explanation = "Strong match on keywords, high success rate, and well-tested"
        elif top_score >= 0.6:
            confidence = "Medium"
            explanation = "Good keyword match and reasonable success rate"
        else:
            confidence = "Low"
            explanation = "Partial keyword match, consider if this is the right pattern"
        
        # Compare to alternatives
        if len(matches) > 1:
            second_score = matches[1][1]
            score_diff = top_score - second_score
            
            if score_diff < 0.1:
                explanation += ". Note: Very close alternative available (see Match 2)"
        
        recommendation = {
            "pattern": top_pattern,
            "score": top_score,
            "confidence": confidence,
            "explanation": explanation
        }
        
        return recommendation


def main():
    parser = argparse.ArgumentParser(description="Pattern Matcher")
    parser.add_argument("request", help="User request to match against patterns")
    parser.add_argument("--top-k", type=int, default=3, help="Number of top matches to return")
    parser.add_argument("--base-dir", default="~/.claude/skills/meta-orchestrator", help="Base directory for patterns")
    parser.add_argument("--recommend", action="store_true", help="Show detailed recommendation")
    
    args = parser.parse_args()
    
    # Initialize matcher
    print("🔍 Initializing pattern matcher...")
    matcher = PatternMatcher(args.base_dir)
    
    # Match patterns
    print(f"\n📊 Matching request: \"{args.request}\"")
    matches = matcher.match_patterns(args.request, args.top_k)
    
    # Display results
    matcher.display_results(matches)
    
    # Show recommendation if requested
    if args.recommend and matches:
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🎯 RECOMMENDATION")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        
        recommendation = matcher.get_recommendation(matches)
        if recommendation:
            print(f"\nUse Pattern: {recommendation['pattern']['name']}")
            print(f"Confidence: {recommendation['confidence']}")
            print(f"Score: {recommendation['score']:.3f}")
            print(f"\nReason: {recommendation['explanation']}")
            print()


if __name__ == "__main__":
    main()
