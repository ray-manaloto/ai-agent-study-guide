---
name: llm-project-optimization
description: Optimize any project for AI/LLM agent consumption. Creates AGENTS.md, llms.txt, tool configs, and documentation structure. Use when setting up a new project for AI coding assistants or when asked to make a repository AI-friendly.
license: MIT
metadata:
  author: ray-manaloto
  version: "1.0"
  repository: https://github.com/ray-manaloto/ai-agent-study-guide
---

# LLM Project Optimization Skill

Optimize any project for AI/LLM agent consumption by creating proper entry points and documentation structure.

## When to Use

- Setting up a new project for AI coding assistants
- Making an existing repository AI-friendly
- User mentions "LLM optimization", "AI-friendly", "agent-ready"
- User wants to add AGENTS.md, llms.txt, or similar files

## Core Principles

1. **AGENTS.md ≠ README.md** - Separate content for AI vs humans
2. **Nested AGENTS.md** - Each subdirectory can have its own
3. **Entry points are minimal** - Link to details, don't duplicate
4. **Tool configs agree** - All tools reference same entry points

## Required Files

Create these files in order:

### 1. AGENTS.md (AI Entry Point)

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
[directory tree - max 15 lines]
\`\`\`

## Tasks

| Task | Command | Files |
|------|---------|-------|
| Build | `[cmd]` | src/ |
| Test | `[cmd]` | tests/ |
| Lint | `[cmd]` | *.ts |

## Code Style
- [Rule 1]
- [Rule 2]

## Do Not
- [Forbidden action 1]
- [Forbidden action 2]
```

### 2. llms.txt (Documentation Index)

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

### 3. Update README.md

Add this section near the top:

```markdown
## For AI Agents

See [AGENTS.md](AGENTS.md) for AI-optimized instructions.
```

## Tool Configs (Optional)

Create these based on which tools the project uses:

| Tool | File | Priority |
|------|------|----------|
| Claude | `CLAUDE.md` | High |
| Cursor | `.cursorrules` | High |
| Windsurf | `.windsurfrules` | Medium |
| Aider | `.aider.conf.yml` | Medium |
| Continue | `.continue/config.json` | Low |
| Copilot | `.github/copilot-instructions.md` | Low |

### .cursorrules Template

```
## Entry Points
- AGENTS.md - AI instructions
- llms.txt - Doc index
- docs/AGENTS.md - Subdirectory context

## Project Type
[type]. [key constraint].

## Do Not
- [forbidden 1]
- [forbidden 2]
```

## Subdirectory Context

For directories with special rules, create `docs/AGENTS.md`:

```markdown
# docs/AGENTS.md

> [Subdirectory description]

## Files

| File | Purpose |
|------|---------|
| `file1.md` | Description |
| `file2.md` | Description |

## Editing Rules
1. [Rule 1]
2. [Rule 2]
```

## Token Optimization Tips

1. **Front-load context**: Put critical info in first 500 tokens
2. **Use tables**: More info per token than prose
3. **Link, don't repeat**: Reference files instead of duplicating
4. **Hierarchical**: llms.txt (index) → llms-full.txt (details)

## Verification Checklist

After creating files, verify:

- [ ] AGENTS.md has setup, structure, and tasks sections
- [ ] README.md references AGENTS.md for AI
- [ ] llms.txt indexes all documentation
- [ ] Tool configs (if any) reference same entry points
- [ ] No duplicate content between files

## Anti-Patterns to Avoid

| Bad | Good |
|-----|------|
| README duplicates AGENTS.md | README points to AGENTS.md |
| Verbose root AGENTS.md | Minimal entry point, link to details |
| Tool configs disagree | All configs reference same entry points |
| No subdirectory context | docs/AGENTS.md for local rules |
