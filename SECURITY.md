# Security Policy

## Supported Versions

We currently provide security updates for the following versions of AgentOps:

| Version | Supported          |
| ------- | ------------------ |
| 0.9.x   | :white_check_mark: |
| < 0.9   | :x:                |

**Note:** As AgentOps is currently in Alpha (pre-1.0), we recommend always using the latest release for security updates and improvements.

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities via one of the following methods:

### Email
Send an email to: **[Maintainer to add security email address]**

### What to Include

Please include the following information in your report:
- **Description:** A clear description of the vulnerability
- **Impact:** What kind of issue it is (e.g., code execution, information disclosure, privilege escalation)
- **Location:** Where in the codebase the vulnerability exists (file path, line numbers if possible)
- **Reproduction:** Step-by-step instructions to reproduce the issue
- **Proof of Concept:** Code or screenshots demonstrating the vulnerability (if possible)
- **Suggested Fix:** If you have a suggested remediation (optional but appreciated)
- **Your Details:** How we can contact you for follow-up questions

### Response Timeline

You can expect the following response timeline:

- **Initial Response:** Within 48 hours acknowledging receipt of your report
- **Status Update:** Within 5 business days with an initial assessment
- **Resolution:** Timeline will depend on severity and complexity
  - Critical: Hotfix released within 7 days
  - High: Patch released within 30 days
  - Medium: Fix included in next regular release
  - Low: Fix included in future release

### Disclosure Policy

- We request that you give us reasonable time to address the issue before any public disclosure
- We will credit you in the security advisory (unless you prefer to remain anonymous)
- We aim to disclose vulnerabilities and their fixes publicly after patching
- Critical vulnerabilities will be disclosed 30 days after patch release

## Security Best Practices for AgentOps Users

### Installation Security

1. **Verify Source:** Always install from official sources
   ```bash
   # Clone from official repository only
   git clone https://github.com/boshu2/agentops.git
   ```

2. **Check Integrity:** Verify commit signatures and checksums
   ```bash
   git verify-commit HEAD
   ```

3. **Review Scripts:** Review installation scripts before execution
   ```bash
   cat scripts/install.sh  # Review before running
   ./scripts/install.sh
   ```

### Runtime Security

1. **Profile Validation:** Always validate profiles before use
   ```bash
   make validate-profile PROFILE=your-profile
   ```

2. **Git Hooks:** Enable security git hooks
   ```bash
   # Hooks check for sensitive data, enforce standards
   make install-hooks
   ```

3. **Sensitive Data:** Never commit sensitive data
   - Use `.env` files for secrets (already in .gitignore)
   - Leverage environment variables
   - Use secret management tools for production

4. **Context Bundles:** Be aware of data in context bundles
   - Review before sharing
   - May contain code snippets, file paths
   - Sanitize before public sharing

### Profile Security

1. **Custom Profiles:** Audit third-party profiles
   ```bash
   # Review profile contents before installation
   cat profiles/third-party-profile/profile.yaml
   ```

2. **Command Execution:** Understand what commands can do
   - Review agent definitions
   - Check skill scripts (bash, Python)
   - Verify hook implementations

3. **Permissions:** Run with least privilege necessary
   - Don't run as root unless required
   - Review file permissions in profiles/
   - Audit bash scripts for dangerous operations

### Network Security

1. **LLM API Keys:** Protect API keys
   - Never commit to git
   - Use environment variables
   - Rotate keys regularly

2. **External Services:** Audit external integrations
   - Review what data is sent to LLM providers
   - Check network calls in profiles
   - Use HTTPS for all external requests

## Known Limitations (Alpha Status)

As AgentOps is in Alpha, please be aware of the following:

### Not Recommended for Production Use

- **Stability:** APIs may change between releases
- **Testing:** Limited real-world security testing
- **Auditing:** No third-party security audit completed
- **Secrets Management:** Basic, not enterprise-grade

### Current Security Posture

**What we do:**
- ✅ Git-based validation and version control
- ✅ Profile validation (YAML schema, structure)
- ✅ Git hooks for pre-commit security checks
- ✅ Open source transparency

**What we don't yet have:**
- ❌ Enterprise secrets management
- ❌ Role-based access control (RBAC)
- ❌ Audit logging
- ❌ Third-party security audit
- ❌ Vulnerability scanning CI
- ❌ SBOM (Software Bill of Materials)

## Security Roadmap

Planned security enhancements:

### v1.0 (Pre-Production)
- [ ] Third-party security audit
- [ ] Vulnerability scanning in CI
- [ ] SBOM generation
- [ ] Enhanced secrets management
- [ ] Security-focused documentation

### v1.5 (Production-Ready)
- [ ] RBAC for multi-user environments
- [ ] Audit logging framework
- [ ] Compliance documentation (SOC 2 prep)
- [ ] Incident response procedures

### v2.0 (Enterprise)
- [ ] Enterprise secrets integration (Vault, etc.)
- [ ] Advanced threat detection
- [ ] Compliance certifications
- [ ] Security SLA

## Scope

This security policy applies to:
- ✅ Core AgentOps orchestration framework
- ✅ Official community profiles (profiles/devops, profiles/product-dev)
- ✅ Installation scripts
- ✅ Validation framework

This policy does NOT apply to:
- ❌ Third-party profiles (user responsibility)
- ❌ LLM provider APIs (separate vendor security)
- ❌ User-generated content (commands, agents, workflows)
- ❌ Forked repositories

## Security Resources

### Recommended Reading
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Tools We Use
- Git for version control and signing
- ShellCheck for bash script analysis
- YAML validators for configuration
- Pre-commit hooks for automation

### External Resources
- GitHub Security Advisories: [github.com/boshu2/agentops/security/advisories](https://github.com/boshu2/agentops/security/advisories)
- Dependabot: Enabled for dependency updates
- Security Insights: [github.com/boshu2/agentops/security](https://github.com/boshu2/agentops/security)

## Acknowledgments

We would like to thank the following individuals for responsibly disclosing security issues:

*(No vulnerabilities reported yet)*

Your name could be here! Responsible disclosure is appreciated and will be credited.

---

## Contact

For security questions or concerns:
- Email: **[Maintainer to add security email]**
- GPG Key: **[Maintainer to add GPG key fingerprint]** (if applicable)

For general questions, please use [GitHub Discussions](https://github.com/boshu2/agentops/discussions) or file a regular issue.

---

**Thank you for helping keep AgentOps and our community safe!**

