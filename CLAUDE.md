# Claude Code Configuration

## Project Context

This is a documentation repository for studying AI coding agent architecture. It analyzes OpenAI's Codex-RS TUI implementation to teach developers how to build their own AI coding assistants.

## Key Files

| File | Purpose |
|------|---------|
| `docs/architecture-diagram.md` | Mermaid sequence diagrams - primary reference |
| `docs/codex-architecture.html` | Interactive HTML with clickable diagrams |
| `llms.txt` | LLM-optimized documentation index |
| `llms-full.txt` | Complete context for LLMs |

## Architecture Summary

Codex-RS has 4 layers:
1. **TUI** (`codex-rs/tui/`) - User interface
2. **Core** (`codex-rs/core/`) - Agent execution
3. **Protocol** (`codex-rs/protocol/`) - Message types
4. **App Server** (`codex-rs/app-server/`) - External JSON-RPC

**Critical**: TUI talks directly to ThreadManager, NOT MessageProcessor.

## When Working on This Repo

1. **Adding diagrams**: Use Mermaid syntax, include source file links
2. **Updating docs**: Keep LLM-friendly (concise, structured, explicit)
3. **Code examples**: Use Rust, reference actual Codex-RS files
4. **New sections**: Update `llms.txt` and `llms-full.txt`

## Do Not

- Create implementation code (this is documentation only)
- Modify the architecture diagrams without verifying against Codex-RS source
- Add dependencies or build systems

## Reference Commands

```bash
# View architecture
open docs/codex-architecture.html

# Render mermaid diagrams
mmdc -i docs/architecture-diagram.md -o output.png

# View in terminal
glow docs/architecture-diagram.md
```

## External Source

All documentation references: https://github.com/openai/codex
