# AGENTS.md

> AI Agent Study Guide - Learn to build coding agents by studying OpenAI Codex-RS

## Context

Documentation repository analyzing OpenAI Codex-RS TUI architecture. **No implementation code.**

## Entry Points

| File | Purpose |
|------|---------|
| `llms.txt` | Documentation index (start here) |
| `llms-full.txt` | Complete context dump |
| `docs/WORKFLOWS.md` | Task workflows |

## Setup

```bash
git clone https://github.com/ray-manaloto/ai-agent-study-guide.git
cd ai-agent-study-guide
```

## Tasks

| Allowed | Command/Location |
|---------|------------------|
| View diagrams | `open docs/codex-architecture.html` |
| Edit docs | `docs/*.md` |
| Update index | `llms.txt`, `llms-full.txt` |

| Forbidden |
|-----------|
| Create implementation code |
| Add dependencies |
| Modify HTML directly |

## Verification

```bash
./scripts/render-diagrams.sh
```

## Subdirectory Agents

| Path | AGENTS.md |
|------|-----------|
| `docs/` | [docs/AGENTS.md](docs/AGENTS.md) |

## Template

To LLM-optimize another project: [docs/templates/LLM-OPTIMIZATION-TEMPLATE.md](docs/templates/LLM-OPTIMIZATION-TEMPLATE.md)
