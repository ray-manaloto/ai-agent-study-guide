# Claude Code Configuration

## Entry Points

| Priority | File | Purpose |
|----------|------|---------|
| 1 | `AGENTS.md` | AI agent instructions |
| 2 | `llms.txt` | Documentation index |
| 3 | `llms-full.txt` | Complete context |
| 4 | `docs/WORKFLOWS.md` | Task execution steps |

## Subdirectory Context

When working in `docs/`, also read `docs/AGENTS.md` for local context.

## Project Type

Documentation-only. No implementation code.

## Key Files

| File | Purpose |
|------|---------|
| `docs/architecture-diagram.md` | Mermaid diagrams (primary reference) |
| `docs/WORKFLOWS.md` | Step-by-step task workflows |
| `docs/CONCEPTS.md` | Core concepts |
| `docs/GLOSSARY.md` | Term definitions |
| `docs/PATTERNS.md` | Implementation patterns |

## Commands

```bash
open docs/codex-architecture.html   # View diagrams
./scripts/render-diagrams.sh        # Validate Mermaid
glow docs/architecture-diagram.md   # Terminal preview
```

## Do Not

- Create implementation code
- Modify HTML directly (regenerate from Mermaid)
- Add dependencies

## Template

For LLM-optimizing other projects: `docs/templates/LLM-OPTIMIZATION-TEMPLATE.md`
