// Neo4j Cypher Queries for Pattern Discovery & Recommendations
// Use these in Neo4j Browser (http://localhost:7474) or via Python driver

// =================================================================
// SECTION 1: DATABASE OVERVIEW & STATISTICS
// =================================================================

// 1.1 Count all nodes by type
MATCH (n)
RETURN labels(n)[0] as node_type, count(n) as count
ORDER BY count DESC;

// 1.2 Count all relationships by type
MATCH ()-[r]->()
RETURN type(r) as relationship_type, count(r) as count
ORDER BY count DESC;

// 1.3 Get database summary
MATCH (n)
WITH labels(n)[0] as type, count(n) as count
RETURN collect({type: type, count: count}) as node_summary
UNION
MATCH ()-[r]->()
WITH type(r) as rel_type, count(r) as count
RETURN collect({type: rel_type, count: count}) as relationship_summary;

// =================================================================
// SECTION 2: PLUGIN QUERIES
// =================================================================

// 2.1 View all plugins sorted by success rate
MATCH (p:Plugin)
RETURN p.name as plugin,
       p.category as category,
       p.success_rate as success_rate,
       p.marketplace as marketplace,
       p.tags as tags
ORDER BY p.success_rate DESC
LIMIT 20;

// 2.2 Find plugins by category
MATCH (p:Plugin)
WHERE p.category = 'web-development'
RETURN p.name, p.description, p.success_rate, p.tags
ORDER BY p.success_rate DESC;

// 2.3 Search plugins by tag
MATCH (p:Plugin)
WHERE 'api' IN p.tags
RETURN p.name, p.category, p.success_rate, p.tags
ORDER BY p.success_rate DESC;

// 2.4 Find plugins with high success rate in specific domain
MATCH (p:Plugin)
WHERE p.category = 'devops'
  AND p.success_rate >= 0.90
RETURN p.name, p.description, p.success_rate
ORDER BY p.success_rate DESC;

// =================================================================
// SECTION 3: PLUGIN SIMILARITY & ALTERNATIVES
// =================================================================

// 3.1 Find similar plugins to a specific plugin
MATCH (p:Plugin {name: 'fastapi-scaffolder'})-[s:SIMILAR_TO]-(similar:Plugin)
WHERE s.similarity_score >= 0.5
RETURN similar.name as alternative,
       similar.description as description,
       s.similarity_score as similarity,
       s.shared_tags as shared_tags,
       similar.success_rate as success_rate
ORDER BY s.similarity_score DESC, similar.success_rate DESC
LIMIT 10;

// 3.2 Find fallback plugins when primary fails
// (Higher similarity + equal/better success rate)
MATCH (primary:Plugin {name: 'jwt-auth-plugin'})-[s:SIMILAR_TO]-(alt:Plugin)
WHERE s.similarity_score >= 0.6
  AND alt.success_rate >= primary.success_rate
RETURN alt.name as fallback_option,
       alt.description as description,
       s.similarity_score as similarity,
       alt.success_rate as success_rate,
       primary.success_rate as primary_success_rate
ORDER BY s.similarity_score DESC;

// 3.3 Find most connected plugins (useful in many patterns)
MATCH (p:Plugin)-[s:SIMILAR_TO]-()
WITH p, count(s) as connections
RETURN p.name as plugin,
       p.category as category,
       connections,
       p.success_rate as success_rate
ORDER BY connections DESC
LIMIT 15;

// 3.4 Visualize similarity clusters
MATCH path = (p1:Plugin)-[s:SIMILAR_TO]-(p2:Plugin)
WHERE p1.category = 'web-development'
  AND s.similarity_score >= 0.7
RETURN path
LIMIT 50;

// =================================================================
// SECTION 4: PATTERN DISCOVERY
// =================================================================

// 4.1 View all patterns with details
MATCH (pat:Pattern)
RETURN pat.pattern_id as id,
       pat.name as name,
       pat.category as category,
       pat.success_rate as success_rate,
       pat.executions as times_used,
       pat.status as status,
       pat.created_at as created
ORDER BY pat.success_rate DESC, pat.executions DESC;

// 4.2 Search patterns by keyword (full-text search)
CALL db.index.fulltext.queryNodes("pattern_search", "api authentication")
YIELD node, score
RETURN node.pattern_id as id,
       node.name as name,
       node.success_rate as success_rate,
       node.executions as executions,
       score as relevance_score
ORDER BY score DESC, node.success_rate DESC
LIMIT 5;

// 4.3 Find patterns by status (learned, validated, discovered)
MATCH (p:Pattern)
WHERE p.status = 'learned'
RETURN p.pattern_id, p.name, p.success_rate, p.executions
ORDER BY p.executions DESC;

// 4.4 Find patterns with high success rate
MATCH (p:Pattern)
WHERE p.success_rate >= 0.90
RETURN p.pattern_id as id,
       p.name as name,
       p.success_rate as success_rate,
       p.executions as proven_uses,
       p.category as category
ORDER BY p.success_rate DESC, p.executions DESC;

// =================================================================
// SECTION 5: PATTERN-PLUGIN RELATIONSHIPS
// =================================================================

// 5.1 Get complete workflow for a pattern
MATCH (pat:Pattern {pattern_id: 'build-rest-api-with-v1'})-[u:USES]->(plugin:Plugin)
RETURN pat.name as pattern,
       u.step_number as step,
       plugin.name as plugin,
       u.purpose as what_it_does,
       plugin.success_rate as plugin_success_rate
ORDER BY u.step_number;

// 5.2 Find all patterns using a specific plugin
MATCH (pat:Pattern)-[u:USES]->(plugin:Plugin {name: 'fastapi-scaffolder'})
RETURN pat.name as pattern,
       pat.success_rate as pattern_success,
       u.step_number as step,
       u.purpose as usage
ORDER BY pat.success_rate DESC;

// 5.3 Find patterns in same category as another pattern
MATCH (target:Pattern {pattern_id: 'build-rest-api-with-v1'})
MATCH (similar:Pattern)
WHERE similar.category = target.category
  AND similar.pattern_id <> target.pattern_id
RETURN similar.pattern_id as related_pattern,
       similar.name as name,
       similar.success_rate as success_rate,
       similar.executions as times_used
ORDER BY similar.success_rate DESC;

// 5.4 Visualize pattern workflow (graph view)
MATCH path = (pat:Pattern {pattern_id: 'build-rest-api-with-v1'})-[u:USES]->(plugin:Plugin)
RETURN path;

// =================================================================
// SECTION 6: EXECUTION TRACKING
// =================================================================

// 6.1 View recent executions
MATCH (exec:Execution)
RETURN exec.execution_id as id,
       exec.task_description as task,
       exec.status as status,
       exec.duration_ms as duration_ms,
       exec.started_at as timestamp
ORDER BY exec.started_at DESC
LIMIT 20;

// 6.2 Track pattern performance over time
MATCH (pat:Pattern {pattern_id: 'build-rest-api-with-v1'})<-[:IMPLEMENTS]-(exec:Execution)
RETURN exec.started_at as timestamp,
       exec.status as status,
       exec.duration_ms as duration,
       exec.task_description as task
ORDER BY exec.started_at DESC;

// 6.3 Calculate pattern success rate from executions
MATCH (pat:Pattern)<-[:IMPLEMENTS]-(exec:Execution)
WITH pat,
     count(exec) as total_executions,
     sum(CASE WHEN exec.status = 'success' THEN 1 ELSE 0 END) as successes
RETURN pat.pattern_id as pattern,
       pat.name as name,
       total_executions,
       successes,
       toFloat(successes) / total_executions as calculated_success_rate,
       pat.success_rate as stored_success_rate
ORDER BY calculated_success_rate DESC;

// 6.4 Find patterns with most executions (popular workflows)
MATCH (pat:Pattern)<-[:IMPLEMENTS]-(exec:Execution)
WITH pat, count(exec) as execution_count
RETURN pat.pattern_id as pattern,
       pat.name as name,
       execution_count,
       pat.success_rate as success_rate
ORDER BY execution_count DESC
LIMIT 10;

// =================================================================
// SECTION 7: INTELLIGENT RECOMMENDATIONS
// =================================================================

// 7.1 Recommend patterns for a new task (by keyword similarity)
// User wants: "build web api with caching"
CALL db.index.fulltext.queryNodes("pattern_search", "web api caching")
YIELD node, score
WHERE node.success_rate >= 0.8
RETURN node.pattern_id as recommended_pattern,
       node.name as pattern_name,
       score as keyword_match_score,
       node.success_rate as quality_score,
       node.executions as popularity,
       (score * 0.4 + node.success_rate * 0.4 + (toFloat(node.executions) / 10) * 0.2) as combined_score
ORDER BY combined_score DESC
LIMIT 5;

// 7.2 Recommend alternative plugins when one fails
// Primary plugin failed: fastapi-scaffolder
MATCH (failed:Plugin {name: 'fastapi-scaffolder'})-[s:SIMILAR_TO]-(alt:Plugin)
WHERE s.similarity_score >= 0.5
  AND alt.success_rate >= failed.success_rate
WITH alt, s,
     (s.similarity_score * 0.6 + alt.success_rate * 0.4) as recommendation_score
RETURN alt.name as alternative_plugin,
       alt.description as description,
       s.similarity_score as similarity,
       alt.success_rate as success_rate,
       recommendation_score
ORDER BY recommendation_score DESC
LIMIT 5;

// 7.3 Find best pattern for specific domain + success criteria
MATCH (pat:Pattern)
WHERE pat.category = 'web-development'
  AND pat.success_rate >= 0.85
  AND pat.executions >= 3
RETURN pat.pattern_id as pattern,
       pat.name as name,
       pat.success_rate as quality,
       pat.executions as proven_uses,
       (pat.success_rate * 0.7 + (toFloat(pat.executions) / 20) * 0.3) as recommendation_score
ORDER BY recommendation_score DESC
LIMIT 5;

// 7.4 Suggest similar patterns (for exploration)
MATCH (target:Pattern {pattern_id: 'build-rest-api-with-v1'})-[:USES]->(shared_plugin:Plugin)<-[:USES]-(similar:Pattern)
WHERE similar.pattern_id <> target.pattern_id
WITH similar, count(shared_plugin) as shared_plugins
RETURN similar.pattern_id as related_pattern,
       similar.name as name,
       shared_plugins as plugins_in_common,
       similar.success_rate as success_rate
ORDER BY shared_plugins DESC, similar.success_rate DESC
LIMIT 5;

// =================================================================
// SECTION 8: ANALYTICS & INSIGHTS
// =================================================================

// 8.1 Pattern success rate distribution
MATCH (p:Pattern)
WITH CASE
  WHEN p.success_rate >= 0.9 THEN 'Excellent (90%+)'
  WHEN p.success_rate >= 0.8 THEN 'Good (80-90%)'
  WHEN p.success_rate >= 0.7 THEN 'Fair (70-80%)'
  ELSE 'Needs improvement (<70%)'
END as quality_tier, count(p) as pattern_count
RETURN quality_tier, pattern_count
ORDER BY pattern_count DESC;

// 8.2 Plugin usage frequency across patterns
MATCH (plugin:Plugin)<-[:USES]-(pat:Pattern)
WITH plugin, count(pat) as usage_count
RETURN plugin.name as plugin,
       plugin.category as category,
       usage_count as used_in_patterns,
       plugin.success_rate as success_rate
ORDER BY usage_count DESC
LIMIT 15;

// 8.3 Category distribution
MATCH (p:Plugin)
WITH p.category as category, count(p) as plugin_count
RETURN category,
       plugin_count,
       toFloat(plugin_count) / toFloat(60) * 100 as percentage
ORDER BY plugin_count DESC;

// 8.4 Average pattern success rate by category
MATCH (pat:Pattern)
WITH pat.category as category,
     avg(pat.success_rate) as avg_success,
     count(pat) as pattern_count
RETURN category,
       round(avg_success * 100) / 100 as average_success_rate,
       pattern_count
ORDER BY avg_success DESC;

// 8.5 Find plugins never used in any pattern (candidates for testing)
MATCH (p:Plugin)
WHERE NOT (p)<-[:USES]-(:Pattern)
RETURN p.name as unused_plugin,
       p.category as category,
       p.success_rate as estimated_success,
       p.description as description
ORDER BY p.success_rate DESC
LIMIT 10;

// =================================================================
// SECTION 9: MAINTENANCE & CLEANUP
// =================================================================

// 9.1 Find duplicate patterns (same plugins, different IDs)
MATCH (p1:Pattern)-[:USES]->(plugin:Plugin)<-[:USES]-(p2:Pattern)
WHERE id(p1) < id(p2)
WITH p1, p2, collect(plugin.name) as shared_plugins
WHERE size(shared_plugins) >= 3
RETURN p1.pattern_id as pattern1,
       p2.pattern_id as pattern2,
       shared_plugins,
       size(shared_plugins) as plugins_in_common
ORDER BY plugins_in_common DESC;

// 9.2 Find orphaned nodes (no relationships)
MATCH (n)
WHERE NOT (n)--()
RETURN labels(n)[0] as type,
       count(n) as orphaned_count;

// 9.3 Update pattern status based on metrics
MATCH (p:Pattern)
WHERE p.executions >= 20 AND p.success_rate >= 0.90 AND p.status <> 'learned'
SET p.status = 'learned'
RETURN p.pattern_id as promoted_pattern,
       p.name as name,
       'discovered/validated -> learned' as promotion;

// 9.4 Archive low-performing patterns
MATCH (p:Pattern)
WHERE p.success_rate < 0.60
SET p.status = 'deprecated'
RETURN p.pattern_id as deprecated_pattern,
       p.name as name,
       p.success_rate as success_rate,
       'Moved to deprecated' as action;

// =================================================================
// SECTION 10: ADVANCED QUERIES
// =================================================================

// 10.1 Find optimal workflow path (highest success rate plugins)
MATCH (pat:Pattern {pattern_id: 'build-rest-api-with-v1'})-[u:USES]->(plugin:Plugin)
WITH pat, collect({step: u.step_number, plugin: plugin.name, success: plugin.success_rate}) as workflow
RETURN pat.name as pattern,
       workflow,
       reduce(total = 1.0, step IN workflow | total * step.success) as estimated_workflow_success
ORDER BY estimated_workflow_success DESC;

// 10.2 Find workflow bottlenecks (lowest success plugins in chain)
MATCH (pat:Pattern)-[u:USES]->(plugin:Plugin)
WITH pat, plugin, u
ORDER BY u.step_number
WITH pat,
     collect({step: u.step_number, plugin: plugin.name, success: plugin.success_rate}) as steps
RETURN pat.pattern_id as pattern,
       [step IN steps WHERE step.success < 0.85 | step] as potential_bottlenecks;

// 10.3 Calculate pattern similarity based on shared plugins
MATCH (p1:Pattern)-[:USES]->(shared:Plugin)<-[:USES]-(p2:Pattern)
WHERE id(p1) < id(p2)
WITH p1, p2, collect(shared.name) as shared_plugins,
     [(p1)-[:USES]->(plugin) | plugin.name] as p1_plugins,
     [(p2)-[:USES]->(plugin) | plugin.name] as p2_plugins
WITH p1, p2, shared_plugins,
     toFloat(size(shared_plugins)) / size(p1_plugins + [p IN p2_plugins WHERE NOT p IN p1_plugins]) as jaccard_similarity
WHERE jaccard_similarity >= 0.3
RETURN p1.pattern_id as pattern1,
       p2.pattern_id as pattern2,
       shared_plugins,
       round(jaccard_similarity * 100) / 100 as similarity_score
ORDER BY jaccard_similarity DESC;

// 10.4 Recommend next plugin in workflow sequence
// User has completed: fastapi-scaffolder
// What should come next?
MATCH (plugin:Plugin {name: 'fastapi-scaffolder'})<-[u:USES]-(pat:Pattern)
MATCH (pat)-[next:USES]->(next_plugin:Plugin)
WHERE next.step_number = u.step_number + 1
WITH next_plugin, count(pat) as frequency,
     avg(next_plugin.success_rate) as avg_success
RETURN next_plugin.name as recommended_next_plugin,
       next_plugin.description as description,
       frequency as used_after_fastapi,
       round(avg_success * 100) / 100 as success_rate
ORDER BY frequency DESC, avg_success DESC
LIMIT 5;

// =================================================================
// END OF QUERIES
// =================================================================

// Tips:
// - Replace pattern_id and plugin names with your actual data
// - Adjust similarity thresholds based on your needs
// - Use LIMIT to control result size
// - Visualize graph patterns with RETURN path queries
// - Monitor performance with PROFILE or EXPLAIN prefixes
