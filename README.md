# AI Agent Study Guide

Learn to build AI coding agents by studying OpenAI Codex-RS architecture.

## What This Is

A documentation repository that analyzes the [OpenAI Codex](https://github.com/openai/codex) Rust implementation to teach developers how production AI coding assistants work.

## Quick Start

```bash
# View interactive architecture diagrams
open docs/codex-architecture.html

# Or view in terminal (requires glow)
glow docs/architecture-diagram.md
```

## What You'll Learn

| Topic | Description |
|-------|-------------|
| TUI ↔ Agent Communication | How the terminal UI talks to the AI agent |
| Event-Driven Architecture | Async channels for request/response flow |
| Approval Workflows | Safety patterns for tool execution |
| Thread Management | Managing concurrent agent sessions |

## Architecture at a Glance

```
User Input → App → ThreadManager → CodexThread → Codex → LLM
                ←  Events (async channel)  ←
```

**Key insight**: The TUI communicates directly with `ThreadManager`, not through `MessageProcessor`. The JSON-RPC layer is only for external clients like VS Code.

## Documentation

| File | Description |
|------|-------------|
| [Architecture Diagram](docs/architecture-diagram.md) | Mermaid sequence diagrams with validated flows |
| [Interactive HTML](docs/codex-architecture.html) | Clickable diagrams with GitHub source links |
| [Core Concepts](docs/CONCEPTS.md) | Communication patterns, safety, threading |
| [Glossary](docs/GLOSSARY.md) | Key term definitions |
| [Implementation Patterns](docs/PATTERNS.md) | Reusable patterns for AI agents |
| [AI Agent Workflows](docs/WORKFLOWS.md) | Step-by-step task workflows |
| [llms.txt](llms.txt) | LLM-optimized documentation index |
| [llms-full.txt](llms-full.txt) | Complete context for AI assistants |

## For AI Assistants

This repository follows LLM documentation best practices:

| Standard | File | Spec |
|----------|------|------|
| Agent Instructions | `AGENTS.md` | [agents.md](https://agents.md) |
| LLM Index | `llms.txt` | [llmstxt.org](https://llmstxt.org) |
| Full Context | `llms-full.txt` | Expanded llms.txt |

### AI Tool Configurations

| Tool | Config |
|------|--------|
| Claude Code | `CLAUDE.md`, `.claude/` |
| Cursor | `.cursorrules`, `.cursor/rules/` |
| Windsurf | `.windsurfrules` |
| Aider | `.aider.conf.yml` |
| Continue.dev | `.continue/config.json` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| MCP Servers | `.mcp.json` |
| Gitingest | `.gitingest` |

## Key Components

### Codex-RS Layers

| Layer | Location | Purpose |
|-------|----------|---------|
| TUI | `codex-rs/tui/` | Terminal interface |
| Core | `codex-rs/core/` | Agent execution |
| Protocol | `codex-rs/protocol/` | Message types |
| App Server | `codex-rs/app-server/` | External clients |

### Key Types

- **Op** - Operations sent to agent (UserTurn, ExecApproval, Interrupt)
- **EventMsg** - Events from agent (TurnStarted, TurnComplete, AgentMessage)
- **Event** - Wrapper with ID and EventMsg

## Source Reference

All diagrams and documentation reference the actual Codex-RS implementation:

- [TUI Source](https://github.com/openai/codex/tree/main/codex-rs/tui)
- [Core Source](https://github.com/openai/codex/tree/main/codex-rs/core)
- [Protocol Source](https://github.com/openai/codex/tree/main/codex-rs/protocol)

## License

Documentation is MIT licensed. OpenAI Codex is subject to its own license.
