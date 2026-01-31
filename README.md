# AI Agent Study Guide

[![Documentation](https://img.shields.io/badge/docs-comprehensive-blue)](docs/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![AI Optimized](https://img.shields.io/badge/AI-Optimized-purple)](AGENTS.md)
[![llms.txt](https://img.shields.io/badge/llms.txt-available-orange)](llms.txt)

Learn to build AI coding agents by studying OpenAI Codex-RS architecture.

> **For AI Agents**: See [AGENTS.md](AGENTS.md) | [llms.txt](llms.txt) | [.opencode/agent/](.opencode/agent/)

---

## Overview

A documentation repository analyzing the [OpenAI Codex](https://github.com/openai/codex) Rust TUI implementation. No code—just architecture documentation, patterns, and insights for building your own AI coding agents.

### Why This Exists

| Goal | Description |
|------|-------------|
| **Learn** | Understand how production AI coding agents work |
| **Document** | Create clear architecture diagrams with source references |
| **Extract** | Identify reusable patterns for agent development |
| **Template** | Provide tools for LLM-optimizing other projects |

### Repository Type

| Attribute | Value |
|-----------|-------|
| Content Type | Documentation only |
| Implementation Code | **NONE** (forbidden) |
| Source Being Studied | https://github.com/openai/codex |
| Primary Focus | TUI ↔ Agent communication patterns |

---

## Quick Start

### For Humans

```bash
# Clone repository
git clone https://github.com/ray-manaloto/ai-agent-study-guide.git
cd ai-agent-study-guide

# View interactive architecture diagrams
open docs/codex-architecture.html

# Or in terminal with glow
glow docs/architecture-diagram.md

# Read the documentation index
cat llms.txt
```

### For AI Agents

```bash
# Start with the agent coordination file
cat AGENTS.md

# Or the quick index
cat llms.txt

# For specialized tasks, check agent guides
ls .opencode/agent/
```

---

## What You'll Learn

### Core Concepts

| Concept | Description | Documentation |
|---------|-------------|---------------|
| TUI ↔ Agent Communication | How UI talks to the AI agent | [CONCEPTS.md](docs/CONCEPTS.md) |
| Event-Driven Architecture | Async message passing patterns | [architecture-diagram.md](docs/architecture-diagram.md) |
| Approval Workflows | Human-in-the-loop for tool execution | [PATTERNS.md](docs/PATTERNS.md) |
| Thread Management | Managing conversation state | [CONCEPTS.md](docs/CONCEPTS.md) |

### Key Insight

**TUI communicates directly with `ThreadManager`, NOT through `MessageProcessor`.**

```
CORRECT:  TUI App → ThreadManager → CodexThread → Codex → LLM
WRONG:    TUI App → MessageProcessor → ThreadManager
```

MessageProcessor is only for external JSON-RPC clients (VS Code, etc.).

### Architecture Flow

```
User Input → App → ThreadManager → CodexThread → Codex → LLM
                ←  Events (async channel)  ←
```

---

## Documentation Structure

### Core Documentation

| File | Purpose | Lines |
|------|---------|-------|
| [AGENTS.md](AGENTS.md) | AI agent coordination guide | 450+ |
| [CLAUDE.md](CLAUDE.md) | Claude Code configuration | 400+ |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Technical architecture | 600+ |
| [IMPLEMENTATION.md](IMPLEMENTATION.md) | Implementation patterns | 500+ |
| [TOOLING.md](TOOLING.md) | Tools and automation | 480+ |

### Reference Documentation

| File | Description |
|------|-------------|
| [docs/architecture-diagram.md](docs/architecture-diagram.md) | Mermaid sequence diagrams |
| [docs/CONCEPTS.md](docs/CONCEPTS.md) | Communication patterns, safety, threading |
| [docs/GLOSSARY.md](docs/GLOSSARY.md) | Term definitions |
| [docs/PATTERNS.md](docs/PATTERNS.md) | Reusable implementation patterns |
| [docs/WORKFLOWS.md](docs/WORKFLOWS.md) | Step-by-step task guides |

### AI Agent Configuration

| File | Purpose |
|------|---------|
| [.cursorrules](.cursorrules) | Cursor AI rules (450+ lines) |
| [llms.txt](llms.txt) | Documentation index for LLMs |
| [.opencode/agent/](.opencode/agent/) | 15 specialized agent guides |

---

## Agent Guides

This repository includes 15 specialized agent guides in `.opencode/agent/`:

| Agent | Purpose |
|-------|---------|
| [index.md](.opencode/agent/index.md) | Agent coordination and routing |
| [architecture-analyst.md](.opencode/agent/architecture-analyst.md) | Analyze software architecture |
| [commit-reviewer.md](.opencode/agent/commit-reviewer.md) | Review commits and PRs |
| [diagram.md](.opencode/agent/diagram.md) | Create Mermaid diagrams |
| [documentation.md](.opencode/agent/documentation.md) | Write documentation |
| [glossary-curator.md](.opencode/agent/glossary-curator.md) | Maintain terminology |
| [index-maintainer.md](.opencode/agent/index-maintainer.md) | Keep indexes current |
| [mermaid-specialist.md](.opencode/agent/mermaid-specialist.md) | Advanced diagram creation |
| [pattern-extractor.md](.opencode/agent/pattern-extractor.md) | Identify patterns |
| [quality-reviewer.md](.opencode/agent/quality-reviewer.md) | Ensure quality |
| [research.md](.opencode/agent/research.md) | Research topics |
| [review.md](.opencode/agent/review.md) | Review changes |
| [source-researcher.md](.opencode/agent/source-researcher.md) | Research codebases |
| [template-generator.md](.opencode/agent/template-generator.md) | Create templates |
| [workflow-designer.md](.opencode/agent/workflow-designer.md) | Design workflows |

---

## LLM-Optimize Your Own Project

### Manual Approach

Follow the step-by-step template: [LLM-OPTIMIZATION-TEMPLATE.md](docs/templates/LLM-OPTIMIZATION-TEMPLATE.md)

### Automated Approach

Use the [npx skills](https://github.com/vercel-labs/skills) CLI:

```bash
# Install skills CLI and add LLM optimization skill
npx skills add ray-manaloto/ai-agent-study-guide/docs/templates/llm-project-optimization

# Or create your own skill
npx skills init
```

### What Gets Created

| File | Purpose |
|------|---------|
| `.cursorrules` | AI coding assistant rules |
| `CLAUDE.md` | Claude Code configuration |
| `AGENTS.md` | Agent coordination |
| `llms.txt` | LLM documentation index |
| `.opencode/agent/` | Specialized agent guides |

See also: [Agent Skills Spec](https://agentskills.io) | [SKILL.md example](docs/templates/llm-project-optimization/SKILL.md)

---

## Contributing

We welcome contributions! Please see:

- [Pull Request Template](.github/pull_request_template.md)
- [Issue Templates](.github/ISSUE_TEMPLATE/)
- [Security Policy](SECURITY.md)

### Contribution Guidelines

1. **Documentation only** - No implementation code
2. **Source references required** - Cite Codex-RS source files
3. **Mermaid diagrams** - Include file paths in labels
4. **Update indexes** - Keep llms.txt current

---

## Project Status

### AI-Readiness Score

| Category | Score | Details |
|----------|-------|---------|
| Documentation | 9.0 | 4000+ lines comprehensive docs |
| AI/LLM Optimization | 9.0 | All core files + 15 agent guides |
| GitHub Best Practices | 9.0 | Templates, CODEOWNERS, SECURITY, CI |
| CI/CD | 8.0 | Docs validation workflow |
| **Overall** | **9.0** | Production-ready AI optimization |

### Repository Stats

- **Total Documentation**: 6000+ lines
- **Agent Guides**: 15 specialized guides (2200+ lines)
- **Core AI Files**: 8 files (3900+ lines)
- **GitHub Infrastructure**: Complete (templates, CI, security)

---

## Source Reference

All documentation references the OpenAI Codex repository:

- **Repository**: https://github.com/openai/codex
- **Focus Area**: `codex-rs/` (Rust TUI implementation)
- **Key Directories**: `tui/`, `core/`, `protocol/`

---

## License

MIT - See [LICENSE](LICENSE) for details.

---

## Acknowledgments

- [OpenAI Codex](https://github.com/openai/codex) - The source being studied
- [Mermaid](https://mermaid.js.org/) - Diagram syntax
- [llms.txt](https://llmstxt.org/) - Index format standard
- [Agent Skills](https://agentskills.io) - Skills specification
