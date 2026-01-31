# AI Agent Study Guide

Learn to build AI coding agents by studying OpenAI Codex-RS architecture.

> **For AI Agents**: See [AGENTS.md](AGENTS.md)

## What This Is

A documentation repository analyzing the [OpenAI Codex](https://github.com/openai/codex) Rust TUI implementation. No code—just architecture documentation.

## Quick Start

```bash
# View interactive architecture diagrams
open docs/codex-architecture.html

# Or in terminal
glow docs/architecture-diagram.md
```

## What You'll Learn

- TUI ↔ Agent communication patterns
- Event-driven architecture for LLM agents  
- Approval workflows for tool execution
- Thread management patterns

## Documentation

| File | Description |
|------|-------------|
| [Architecture Diagram](docs/architecture-diagram.md) | Mermaid sequence diagrams |
| [Core Concepts](docs/CONCEPTS.md) | Communication patterns, safety, threading |
| [Glossary](docs/GLOSSARY.md) | Term definitions |
| [Patterns](docs/PATTERNS.md) | Reusable implementation patterns |
| [Workflows](docs/WORKFLOWS.md) | Step-by-step task guides |

## Architecture Overview

```
User Input → App → ThreadManager → CodexThread → Codex → LLM
                ←  Events (async channel)  ←
```

**Key insight**: TUI communicates directly with `ThreadManager`, not through `MessageProcessor`.

## LLM-Optimize Your Own Project

See [docs/templates/LLM-OPTIMIZATION-TEMPLATE.md](docs/templates/LLM-OPTIMIZATION-TEMPLATE.md) for a reusable template.

## Source Reference

All documentation references: https://github.com/openai/codex

## License

MIT
