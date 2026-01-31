# LLM Project Optimization Template

> Minimal guide to make any project AI/LLM agent-friendly. Copy and adapt.

## Core Principles

1. **AGENTS.md ≠ README.md** - Separate content for AI vs humans
2. **Nested AGENTS.md** - Each subdirectory can have its own
3. **Entry points are minimal** - Link to details, don't duplicate
4. **Tool configs agree** - All tools reference same entry points

## Required Files

```
project/
├── AGENTS.md         # AI entry point (minimal, links to details)
├── README.md         # Human entry point (includes "For AI: see AGENTS.md")
├── llms.txt          # Documentation index
├── llms-full.txt     # Complete context
└── docs/
    ├── AGENTS.md     # Subdirectory context
    └── WORKFLOWS.md  # Task execution steps
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
- [ ] README.md with "For AI: see AGENTS.md"
- [ ] llms.txt with docs index

### Recommended
- [ ] llms-full.txt with complete context
- [ ] docs/AGENTS.md for subdirectory context
- [ ] docs/WORKFLOWS.md with task steps
- [ ] Tool config (e.g., .cursorrules)

### Full Optimization
- [ ] All tool configs referencing same entry points
- [ ] Nested AGENTS.md in each major subdirectory
- [ ] docs/GLOSSARY.md for terms
- [ ] .gitingest for repo-to-text

---

## Anti-Patterns

| Bad | Good |
|-----|------|
| README duplicates AGENTS.md | README points to AGENTS.md |
| Template at root | Template in docs/templates/ |
| Tool configs disagree | All configs reference same entry points |
| Verbose root AGENTS.md | Minimal entry point, link to details |
| No subdirectory context | docs/AGENTS.md for local rules |
| Scattered docs | Centralized index (llms.txt) |
| No task workflows | docs/WORKFLOWS.md with steps |

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
## Entry Points
- AGENTS.md - AI instructions
- llms.txt - Doc index
- docs/AGENTS.md - Subdirectory context
- docs/WORKFLOWS.md - Task steps

## Project Type
[type]. [key constraint].

## Do Not
- [forbidden 1]
- [forbidden 2]
```

### Minimal CLAUDE.md
```markdown
# Claude Code Config

## Entry Points
| Priority | File | Purpose |
|----------|------|---------|
| 1 | AGENTS.md | AI instructions |
| 2 | llms.txt | Doc index |
| 3 | docs/WORKFLOWS.md | Task steps |

## Subdirectory Context
When in docs/, also read docs/AGENTS.md.

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

## Alternative: Agent Skills (SKILL.md)

For **installable, reusable** capabilities, consider the [Agent Skills](https://agentskills.io) format:

### What is SKILL.md?

An open standard for packaging agent capabilities:
- **YAML frontmatter** with `name` and `description`
- **Markdown body** with instructions
- **Installable** via `npx skills add`
- **Discoverable** via [skills.sh](https://skills.sh)

### SKILL.md vs AGENTS.md

| Feature | SKILL.md | AGENTS.md |
|---------|----------|-----------|
| Purpose | Installable capability | Project instructions |
| Format | YAML frontmatter + markdown | Pure markdown |
| Install | `npx skills add` | Manual copy |
| Scope | Reusable across projects | Single project |
| Discovery | Indexed on skills.sh | Not indexed |

### When to Use Which

| Use AGENTS.md | Use SKILL.md |
|---------------|--------------|
| Project-specific context | Reusable workflow |
| "How this codebase works" | "How to do X in any project" |
| One repository | Published package |

### Quick SKILL.md Example

```yaml
---
name: my-skill
description: What this skill does and when to use it.
---

# My Skill

Instructions for the agent...
```

### Tools for Agent Skills

```bash
# Install the skills CLI
npx skills

# Add a skill to your project
npx skills add vercel-labs/agent-skills

# Create a new skill
npx skills init

# List installed skills
npx skills list

# Find skills
npx skills find pdf-processing
```

### Resources

- [Agent Skills Spec](https://agentskills.io/specification) - Full format spec
- [skills.sh](https://skills.sh) - Skill discovery directory
- [vercel-labs/skills](https://github.com/vercel-labs/skills) - CLI tool (3.7k stars)
- [anthropics/skills](https://github.com/anthropics/skills) - Example skills

---

## Reference Implementation

See this repository for complete example:
- 25+ files demonstrating full optimization
- 8 AI tool configurations
- Comprehensive workflow documentation
- SKILL.md example at `docs/templates/llm-project-optimization/`
