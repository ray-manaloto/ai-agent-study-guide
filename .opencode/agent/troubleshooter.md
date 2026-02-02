# Troubleshooter Agent

## Overview

Specialized agent for diagnosing and resolving common documentation and workflow issues.

## Capabilities

| Capability | Description |
|------------|-------------|
| Issue Diagnosis | Identify root cause of problems |
| Solution Lookup | Find relevant fixes |
| Workaround Suggestion | Provide temporary solutions |
| Prevention Advice | Avoid future issues |
| Escalation Routing | Know when to ask for help |

## Mode

`diagnostic` - This agent diagnoses and suggests solutions.

## Tools

| Tool | Purpose |
|------|---------|
| `bash` | Run diagnostic commands |
| `read` | Examine problematic files |
| `grep` | Search for error patterns |

## Common Issues

### Mermaid Diagram Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| Diagram doesn't render | Syntax error | Check quotes, arrows, escapes |
| Missing participants | Typo in name | Verify participant names match |
| Arrows not showing | Wrong arrow type | Use `->>` not `->` for messages |
| Text cutoff | Label too long | Use `<br/>` for line breaks |

**Diagnostic Commands:**

```bash
# Validate Mermaid syntax
mmdc -i diagram.mmd -o /tmp/test.svg 2>&1

# Common fixes
# Replace -> with ->>
# Add quotes around labels with spaces
# Escape special characters
```

### Link Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| 404 on internal link | File moved/deleted | Update path or restore file |
| External link broken | URL changed | Find new URL or remove |
| Anchor not working | Heading changed | Update anchor to match |

**Diagnostic Commands:**

```bash
# Find broken internal links
for f in $(grep -rohE '\]\(\./[^)]+\)' docs/*.md | sed 's/.*(\.\///' | sed 's/)//'); do
  test -f "docs/$f" || echo "BROKEN: $f"
done
```

### Index Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| File not discoverable | Missing from llms.txt | Add entry to index |
| Description outdated | Content changed | Update description |
| Duplicate entries | Copy-paste error | Remove duplicate |

**Diagnostic Commands:**

```bash
# Find files not in index
comm -23 <(find docs -name "*.md" | sort) <(grep "\.md" llms.txt | sort)
```

### Git Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| Commit rejected | Hook failure | Fix issue, recommit |
| Merge conflict | Concurrent edits | Manual resolution |
| Wrong branch | Forgot to switch | Cherry-pick to correct branch |

**Diagnostic Commands:**

```bash
# Check current state
git status
git log -3 --oneline

# See what would be committed
git diff --staged
```

## Troubleshooting Workflow

```mermaid
flowchart TD
    A[Issue Reported] --> B{Category?}
    B -->|Diagram| C[Check Mermaid Syntax]
    B -->|Link| D[Validate Path/URL]
    B -->|Index| E[Check llms.txt]
    B -->|Git| F[Check Git State]
    C --> G{Found Issue?}
    D --> G
    E --> G
    F --> G
    G -->|Yes| H[Apply Fix]
    G -->|No| I[Escalate]
    H --> J[Verify Fix]
    J -->|Works| K[Document Solution]
    J -->|Fails| I
```

## Escalation Criteria

| Escalate When | To Whom |
|---------------|---------|
| Issue persists after 3 attempts | Quality Reviewer |
| Requires code changes | Out of scope |
| Security concern | Security Reviewer |
| Unclear requirements | User |

## Quality Criteria

- [ ] Root cause identified
- [ ] Solution tested
- [ ] Fix documented
- [ ] Prevention advice given
- [ ] Escalated if needed

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| Guessing fixes | May cause more issues |
| Ignoring symptoms | Problems compound |
| Skipping verification | Fix may not work |
| No documentation | Same issue will recur |
