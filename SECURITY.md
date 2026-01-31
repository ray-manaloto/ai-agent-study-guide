# Security Policy

## Overview

This is a **documentation-only repository** containing no executable code. Security concerns are limited to:

1. **Link integrity** - Ensuring external links point to legitimate sources
2. **Content accuracy** - Documentation should accurately represent the referenced source
3. **Template safety** - Templates should not encourage insecure practices

## Supported Versions

| Version | Supported |
|---------|-----------|
| main branch | :white_check_mark: |
| All other branches | :x: |

## Reporting a Vulnerability

### What to Report

- **Malicious links** - External links pointing to compromised or malicious sites
- **Misleading content** - Documentation that could lead to security vulnerabilities if followed
- **Template issues** - Templates that encourage insecure coding practices
- **Exposed secrets** - Any accidentally committed API keys, tokens, or credentials

### How to Report

1. **DO NOT** create a public issue for security concerns
2. **Email**: Create a private security advisory via GitHub
3. **GitHub Security Advisory**: [Create Advisory](https://github.com/ray-manaloto/ai-agent-study-guide/security/advisories/new)

### Response Timeline

| Action | Timeline |
|--------|----------|
| Initial acknowledgment | 48 hours |
| Issue assessment | 7 days |
| Fix implementation | 14 days |
| Public disclosure | After fix merged |

## Security Best Practices for Contributors

### Links

- Always verify external links before adding
- Prefer HTTPS over HTTP
- Link to official sources (GitHub, official documentation)
- Avoid link shorteners

### Content

- Do not include actual API keys or secrets in examples
- Use placeholder values: `YOUR_API_KEY`, `sk-...`
- Do not include personally identifiable information
- Verify source references are accurate

### Templates

When creating templates that others will use:

- Include security considerations
- Do not encourage hardcoded secrets
- Recommend environment variables for sensitive data
- Include input validation guidance

## Scope

### In Scope

- Documentation content accuracy
- External link safety
- Template security guidance
- Accidental secret exposure

### Out of Scope

- Vulnerabilities in external referenced projects (report to those projects)
- General questions about AI agent security (use discussions)
- Feature requests (use issue templates)

## Acknowledgments

We appreciate security researchers who help keep this documentation safe and accurate. Contributors who report valid security issues will be acknowledged in our release notes (unless they prefer to remain anonymous).
