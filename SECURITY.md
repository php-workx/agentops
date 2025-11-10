# Security Policy

## Supported Versions

We currently support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

We take the security of the AgentOps marketplace seriously. If you discover a security vulnerability, please follow these steps:

### How to Report

**Email:** [your-email]@example.com (replace with your actual contact email)

**Please include:**
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Suggested fix (if you have one)

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Fix Timeline:** Depends on severity
  - Critical: 7-14 days
  - High: 14-30 days
  - Medium: 30-60 days
  - Low: 60-90 days

### Disclosure Policy

- Please give us reasonable time to fix the issue before public disclosure
- We will credit security researchers who report vulnerabilities responsibly
- We will coordinate disclosure timing with the reporter

## Security Best Practices

### For Marketplace Users

**Installation:**
- Only install plugins from trusted sources
- Review plugin code before installation
- Keep plugins updated to latest versions
- Report suspicious plugin behavior

**Usage:**
- Follow agent tool permissions carefully
- Review what tools agents can access
- Don't share sensitive credentials in agent context
- Use `.gitignore` to exclude sensitive files

### For Plugin Contributors

**Code Security:**
- Never hardcode credentials, API keys, or secrets
- Use environment variables for sensitive configuration
- Validate all user input in agents and commands
- Sanitize file paths to prevent directory traversal
- Follow principle of least privilege for tool permissions

**Agent Design:**
- Declare only necessary tools in agent frontmatter
- Document security considerations in agent README
- Test agents with malicious inputs
- Use read-only operations when possible

**Dependencies:**
- Keep dependencies up to date
- Audit dependency security regularly
- Document all external dependencies
- Use specific versions, not `latest`

## Security Measures in Place

### Repository Security

- ✅ No credentials stored in repository
- ✅ Comprehensive `.gitignore` configuration
- ✅ Apache 2.0 license for legal clarity
- ✅ Public code review process
- ⏳ Dependabot alerts (to be enabled)
- ⏳ CodeQL analysis (to be enabled)
- ⏳ Secret scanning (to be enabled)

### Plugin Validation

- ✅ Manual marketplace validation
- ✅ Plugin manifest schema validation
- ⏳ Automated CI/CD validation (in progress)
- ⏳ Security scanning in pipelines (planned)

### Community Oversight

- ✅ Public repository for transparency
- ✅ Clear contribution guidelines
- ✅ Security policy (this document)
- ⏳ Community review process (to be established)

## Known Security Considerations

### Plugin Execution Model

**Important:** Plugins execute with full access to Claude Code's tool permissions. This means:

- Agents can read/write files based on their tool declarations
- Commands can execute bash commands if granted
- MCP servers can access external APIs
- Skills inherit parent agent permissions

**User Responsibility:**
- Review plugin code before installation
- Understand tool permissions in agent frontmatter
- Trust the plugin author
- Monitor agent behavior during execution

### Marketplace Federation

This marketplace references external marketplaces:
- [wshobson/agents](https://github.com/wshobson/agents)
- [aitmpl.com/agents](https://www.aitmpl.com/agents)

**Security Note:** We do not control external marketplace content. Review plugins from external sources independently.

## Security Roadmap

### Phase 1: Current (v1.0.0)
- ✅ Security policy published
- ✅ Vulnerability reporting process
- ✅ Basic security best practices documented

### Phase 2: Short-term (v1.1.0)
- [ ] Enable Dependabot alerts
- [ ] Enable CodeQL analysis
- [ ] Enable secret scanning
- [ ] Automated validation pipeline

### Phase 3: Medium-term (v1.2.0)
- [ ] Plugin security scoring system
- [ ] Automated security testing
- [ ] Security audit guidelines
- [ ] Community security reviews

### Phase 4: Long-term (v2.0.0)
- [ ] Sandboxed plugin execution (if supported)
- [ ] Plugin signing and verification
- [ ] Security certification program
- [ ] Bug bounty program

## Security Champions

We recognize contributors who help improve security:

- Report vulnerabilities responsibly
- Contribute security improvements
- Review plugin security
- Educate the community

Security champions will be acknowledged in:
- CHANGELOG.md release notes
- GitHub security advisories
- README.md acknowledgments

## Questions?

For security questions that don't constitute vulnerabilities:
- Open a GitHub Discussion
- Tag with `security` label
- Email: [your-email]@example.com

---

**Last Updated:** 2025-11-10
**Version:** 1.0.0
