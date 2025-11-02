# Security Policy

## Supported Versions

We actively support security updates for the following versions:

| Version | Supported          |
|---------|--------------------|
| 1.x.x   | ✅ Active          |
| 0.x.x   | ❌ Not Supported   |

## Reporting a Vulnerability

We take security seriously and appreciate your efforts to disclose vulnerabilities responsibly.

### What We Accept
- Cross-site scripting (XSS) attacks
- Cross-site request forgery (CSRF)
- Server-side request forgery (SSRF)
- Authentication and authorization issues
- Mobile platform-specific vulnerabilities (Android/iOS)
- Web application security issues
- Flutter/Dart specific security concerns

### What We Don't Accept
- Denial of Service (DoS) attacks
- Social engineering attacks
- Physical security issues
- Known vulnerabilities with public exploits
- Theoretical vulnerabilities without proof-of-concept

## How to Report

### Public Reporting
For minor security issues, please open a [Security Issue](https://github.com/REChainVC/rechain-vc/issues/new?assignees=&labels=security&template=security.md&title=Security+Issue) using our security template.

### Private Reporting
For sensitive vulnerabilities, please contact our security team privately:

**Email:** security@rechain.vc  
**PGP Key:** [Available upon request]  
**Encrypted Email:** Use [ProtonMail](mailto:security@protonmail.com) for sensitive disclosures

### Vulnerability Disclosure Timeline
- **Acknowledgment:** Within 48 hours
- **Assessment:** Within 5 business days
- **Resolution:** Within 30 days for critical issues
- **Disclosure:** Coordinated disclosure after patch is available

## Security Advisory Process

1. **Report:** Submit vulnerability details privately
2. **Triage:** Security team assesses impact and validity
3. **Fix:** Develop and test patch
4. **Release:** Deploy fix to supported versions
5. **Disclosure:** Publish security advisory with CVE (if applicable)
6. **Credit:** Acknowledge reporter in release notes

## Security Tools Used

- **Code Analysis:** Flutter analyze, Dart linting
- **Dependency Scanning:** pub deps, dependabot
- **Static Analysis:** Trivy, CodeQL
- **Runtime Security:** Flutter secure coding practices

## Responsible Disclosure

We follow responsible disclosure principles:
- No public disclosure before patch availability
- Credit to researchers in release notes
- Coordination with CVE assignment
- No legal action against good-faith researchers

## Bounty Program

We offer a bug bounty program for eligible vulnerabilities:
- **Low:** $100 USD
- **Medium:** $500 USD
- **High:** $1,000 USD  
- **Critical:** $2,500+ USD

See our [Bug Bounty Program](https://rechain.vc/bug-bounty) for details.

## Code of Conduct

Security reports should adhere to our [Code of Conduct](CODE_OF_CONDUCT.md). Malicious or unethical behavior will not be tolerated.

## Questions

For questions about our security policy, contact security@rechain.vc.

---

*Last updated: September 2024*