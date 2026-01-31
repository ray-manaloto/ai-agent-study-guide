# LLM Project Optimization Template

> Minimal guide to make any project AI/LLM agent-friendly. Copy and adapt.

## Required Files (4)

```
project/
├── AGENTS.md      # AI agent instructions
├── llms.txt       # Documentation index  
├── llms-full.txt  # Complete context
└── README.md      # Overview
```

---

## 1. AGENTS.md

```markdown
# AGENTS.md

> [One-line project description]

## Quick Context
- **What**: [Project type]
- **Stack**: [Languages/frameworks]
- **Type**: [app/library/docs/api]

## Setup
\`\`\`bash
[clone command]
[install command]
[run command]
\`\`\`

## Structure
\`\`\`
[directory tree]
\`\`\`

## Tasks

| Task | Command | Files |
|------|---------|-------|
| Build | `npm run build` | src/ |
| Test | `npm test` | tests/ |
| Lint | `npm run lint` | *.ts |

## Code Style
- [Rule 1]
- [Rule 2]

## Do Not
- [Forbidden action 1]
- [Forbidden action 2]
```

---

## 2. llms.txt

```markdown
# [Project Name]

> [One-line description with key tech]

## Docs
- [File1](path): Description
- [File2](path): Description

## API
- [Endpoint/Function]: Purpose

## Key Facts
- [Critical insight 1]
- [Critical insight 2]
```

---

## 3. llms-full.txt

Expand llms.txt with:
- Full API signatures
- Configuration options
- Architecture details
- Common patterns

---

## 4. Tool Configs (Optional)

| Tool | File | Template |
|------|------|----------|
| Claude | `CLAUDE.md` | Same as AGENTS.md subset |
| Cursor | `.cursorrules` | Rules in plain text |
| Windsurf | `.windsurfrules` | Rules in plain text |
| Aider | `.aider.conf.yml` | YAML config |
| Continue | `.continue/config.json` | JSON config |
| Copilot | `.github/copilot-instructions.md` | Markdown |
| MCP | `.mcp.json` | JSON servers |
| Gitingest | `.gitingest` | Include/exclude patterns |

---

## Checklist

### Minimum Viable
- [ ] AGENTS.md with setup + structure + tasks
- [ ] llms.txt with docs index
- [ ] README.md for humans

### Recommended
- [ ] llms-full.txt with complete context
- [ ] .cursorrules or equivalent
- [ ] Task workflows documented

### Full Optimization
- [ ] All 8 tool configs
- [ ] docs/WORKFLOWS.md with step-by-step
- [ ] docs/GLOSSARY.md for terms
- [ ] .gitingest for repo-to-text

---

## Anti-Patterns

| Bad | Good |
|-----|------|
| Verbose prose | Tables + bullets |
| Implicit knowledge | Explicit facts |
| Scattered docs | Centralized index |
| No task list | Clear allowed/forbidden |
| Missing commands | Copy-paste setup |

---

## Token Optimization

1. **Front-load context**: Put critical info in first 500 tokens
2. **Use tables**: More info per token than prose
3. **Link, don't repeat**: Reference files instead of duplicating
4. **Hierarchical**: llms.txt (index) → llms-full.txt (details)
5. **Explicit > implicit**: State facts, don't hint

---

## File Templates

### Minimal .cursorrules
```
Project: [name]
Type: [type]
Stack: [stack]

Rules:
- [rule 1]
- [rule 2]

Key files: [file1], [file2]
```

### Minimal CLAUDE.md
```markdown
# Claude Code Config

## Context
[One paragraph project description]

## Key Files
- file1: purpose
- file2: purpose

## Commands
\`\`\`bash
[setup]
[build]
[test]
\`\`\`

## Do Not
- [forbidden 1]
- [forbidden 2]
```

### Minimal .gitingest
```yaml
include:
  - "*.md"
  - "*.txt"
  - "src/**"
exclude:
  - "node_modules/**"
  - ".git/**"
```

---

## Quick Start

```bash
# 1. Create AGENTS.md
cat > AGENTS.md << 'EOF'
# AGENTS.md
> [description]
## Setup
\`\`\`bash
git clone [url]
cd [dir]
[install]
\`\`\`
## Structure
[tree]
## Tasks
| Task | Command |
|------|---------|
| Build | `[cmd]` |
| Test | `[cmd]` |
EOF

# 2. Create llms.txt
cat > llms.txt << 'EOF'
# [Project]
> [description]
## Docs
- [README.md](README.md): Overview
- [AGENTS.md](AGENTS.md): AI instructions
EOF

# 3. Create .cursorrules
cat > .cursorrules << 'EOF'
Project: [name]
Type: [type]
Key files: AGENTS.md, llms.txt
EOF
```

---

## Reference Implementation

See this repository for complete example:
- 23 files demonstrating full optimization
- 8 AI tool configurations
- Comprehensive workflow documentation
