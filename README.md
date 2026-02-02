# AI Agent Study Guide

[![Documentation](https://img.shields.io/badge/docs-comprehensive-blue)](docs/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![AI Optimized](https://img.shields.io/badge/AI-Optimized-purple)](AGENTS.md)
[![llms.txt](https://img.shields.io/badge/llms.txt-available-orange)](llms.txt)

Learn to build AI coding agents by studying 7 production implementations.

> **For AI Agents**: See [AGENTS.md](AGENTS.md) | [llms.txt](llms.txt) | [.opencode/agent/](.opencode/agent/)

---

## Overview

A documentation repository analyzing architecture patterns from 7 leading AI coding agent implementations. No code—just architecture documentation, patterns, and insights for building your own AI coding agents.

### Tools Studied

| Tool | Type | Key Architecture | Documentation |
|------|------|------------------|---------------|
| [Codex](docs/tools/codex/) | CLI/TUI | Rust channels, typed protocols | [README](docs/tools/codex/README.md) |
| [Claude Code](docs/tools/claude-code/) | CLI | MCP integration, subagent delegation | [README](docs/tools/claude-code/README.md) |
| [OpenCode](docs/tools/opencode/) | CLI/TUI | Multi-provider, session forking | [README](docs/tools/opencode/README.md) |
| [Kata](docs/tools/kata/) | Orchestrator | 8-phase spec-driven workflow | [README](docs/tools/kata/README.md) |
| [Get-Shit-Done](docs/tools/get-shit-done/) | Framework | Context engineering, wave execution | [README](docs/tools/get-shit-done/README.md) |
| [Oh-My-OpenCode](docs/tools/oh-my-opencode/) | Framework | Category-based delegation, skills | [README](docs/tools/oh-my-opencode/README.md) |
| [Kimi K2](docs/tools/kimi-k2/) | Model+API | PARL training, 100-agent swarms | [README](docs/tools/kimi-k2/README.md) |

### Why This Exists

| Goal | Description |
|------|-------------|
| **Learn** | Understand how production AI coding agents work |
| **Document** | Create clear architecture diagrams with source references |
| **Extract** | Identify reusable patterns for agent development |
| **Synthesize** | Combine best practices into unified guidance |

### Repository Type

| Attribute | Value |
|-----------|-------|
| Content Type | Documentation only |
| Implementation Code | **NONE** (reference architecture only) |
| Primary Focus | Multi-agent orchestration patterns |

---

## Quick Start

### For Humans

```bash
# Clone repository
git clone https://github.com/ray-manaloto/ai-agent-study-guide.git
cd ai-agent-study-guide

# Start with the tools overview
open docs/tools/README.md

# Read best practices
open docs/tools/BEST-PRACTICES.md

# Explore unified harness design
open docs/tools/UNIFIED-HARNESS.md
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

### Core Patterns (from all 7 tools)

| Pattern | Description | Key Sources |
|---------|-------------|-------------|
| Thin Orchestrators | Keep main context at 30-40%, spawn fresh subagents | Kata, GSD, Oh-My-OpenCode |
| Category-Based Delegation | Route by semantic category, not model names | Oh-My-OpenCode |
| Wave Execution | Parallel execution of independent tasks | Kata, GSD, Kimi K2 |
| Approval Queues | Sequential approval processing | Codex, Claude Code |
| Wisdom Accumulation | Learn from successes, persist patterns | Oh-My-OpenCode |
| PARL Training | Trainable orchestrator + frozen subagents | Kimi K2 |

### Key Architectural Insights

**From Codex**: TUI communicates directly with `ThreadManager`, NOT through `MessageProcessor`.

```
CORRECT:  TUI App → ThreadManager → CodexThread → Codex → LLM
WRONG:    TUI App → MessageProcessor → ThreadManager
```

**From Kata**: Specification-driven 8-phase workflow:
```
Clarify → Specify → Architect → Plan → Implement → Verify → Document → Review
```

**From Kimi K2**: Parallel-Agent Reinforcement Learning:
```
Trainable Orchestrator → [Frozen Agent A, B, C, ...] → Critical Steps Optimization
```

---

## Documentation Structure

### Tools Documentation

| Path | Description |
|------|-------------|
| [docs/tools/README.md](docs/tools/README.md) | Landing page with comparison matrix |
| [docs/tools/BEST-PRACTICES.md](docs/tools/BEST-PRACTICES.md) | **Combined best practices from all 7 tools** |
| [docs/tools/UNIFIED-HARNESS.md](docs/tools/UNIFIED-HARNESS.md) | **Multi-provider harness architecture** |

### Individual Tool Documentation

| Tool | README | Key Focus |
|------|--------|-----------|
| Codex | [docs/tools/codex/](docs/tools/codex/) | Channel-based TUI architecture |
| Claude Code | [docs/tools/claude-code/](docs/tools/claude-code/) | MCP and subagent delegation |
| OpenCode | [docs/tools/opencode/](docs/tools/opencode/) | Multi-provider abstraction |
| Kata | [docs/tools/kata/](docs/tools/kata/) | Spec-driven phases |
| Get-Shit-Done | [docs/tools/get-shit-done/](docs/tools/get-shit-done/) | Context engineering |
| Oh-My-OpenCode | [docs/tools/oh-my-opencode/](docs/tools/oh-my-opencode/) | Swarm orchestration |
| Kimi K2 | [docs/tools/kimi-k2/](docs/tools/kimi-k2/) | PARL and massive parallelism |

### Core Documentation

| File | Purpose |
|------|---------|
| [AGENTS.md](AGENTS.md) | AI agent coordination guide |
| [CLAUDE.md](CLAUDE.md) | Claude Code configuration |
| [docs/CONCEPTS.md](docs/CONCEPTS.md) | Communication patterns, safety patterns |
| [docs/PATTERNS.md](docs/PATTERNS.md) | Reusable implementation patterns |
| [docs/WORKFLOWS.md](docs/WORKFLOWS.md) | Step-by-step task guides |

### AI Agent Configuration

| File | Purpose |
|------|---------|
| [.cursorrules](.cursorrules) | Cursor AI rules (450+ lines) |
| [llms.txt](llms.txt) | Documentation index for LLMs |
| [.opencode/agent/](.opencode/agent/) | 15 specialized agent guides |

---

## Comparison Highlights

### Multi-Agent Capabilities

| Tool | Max Agents | Coordination | Communication |
|------|------------|--------------|---------------|
| Codex | 1 | N/A | Direct channel |
| Claude Code | 1 + subagents | Task delegation | Context passing |
| OpenCode | 2 (plan/build) | Tab switching | Shared context |
| Oh-My-OpenCode | 15+ | Hive-mind | Memory + hooks |
| Kata | ~10 | Phase orchestrator | XML plans |
| Kimi K2 | **100** | PARL orchestrator | API coordination |

### Provider Support

| Tool | Anthropic | OpenAI | Google | Local | Other |
|------|-----------|--------|--------|-------|-------|
| Codex | - | ✅ | - | - | - |
| Claude Code | ✅ | - | - | - | - |
| OpenCode | ✅ | ✅ | ✅ | ✅ | Many |
| Oh-My-OpenCode | ✅ | ✅ | ✅ | ✅ | Many |
| Kata | ✅ | - | - | - | - |
| Kimi K2 | - | - | - | - | Moonshot |

---

## Agent Guides

This repository includes 15 specialized agent guides in `.opencode/agent/`:

| Agent | Purpose |
|-------|---------|
| [index.md](.opencode/agent/index.md) | Agent coordination and routing |
| [architecture-analyst.md](.opencode/agent/architecture-analyst.md) | Analyze software architecture |
| [diagram.md](.opencode/agent/diagram.md) | Create Mermaid diagrams |
| [documentation.md](.opencode/agent/documentation.md) | Write documentation |
| [pattern-extractor.md](.opencode/agent/pattern-extractor.md) | Identify patterns |
| [research.md](.opencode/agent/research.md) | Research topics |

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

---

## Contributing

We welcome contributions! Please see:

- [Pull Request Template](.github/pull_request_template.md)
- [Issue Templates](.github/ISSUE_TEMPLATE/)
- [Security Policy](SECURITY.md)

### Contribution Guidelines

1. **Documentation only** - No implementation code
2. **Source references required** - Cite source files/repos
3. **Mermaid diagrams** - Include file paths in labels
4. **Update indexes** - Keep llms.txt current

---

## Project Status

### Repository Stats

- **Tools Documented**: 7 production AI coding agents
- **Total Documentation**: 10,000+ lines
- **Best Practices**: 10 major categories synthesized
- **Agent Guides**: 15 specialized guides

### AI-Readiness Score

| Category | Score | Details |
|----------|-------|---------|
| Documentation | 9.5 | Comprehensive multi-tool coverage |
| AI/LLM Optimization | 9.0 | All core files + agent guides |
| Patterns & Practices | 9.0 | Synthesized from 7 production tools |
| **Overall** | **9.0** | Production-ready reference |

---

## Source References

| Tool | Repository |
|------|------------|
| Codex | [github.com/openai/codex](https://github.com/openai/codex) |
| Claude Code | Anthropic (Closed Source) |
| OpenCode | [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode) |
| Kata | [github.com/gannonh/kata](https://github.com/gannonh/kata) |
| Get-Shit-Done | [github.com/glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done) |
| Oh-My-OpenCode | [github.com/sizzldev/oh-my-opencode](https://github.com/sizzldev/oh-my-opencode) |
| Kimi K2 | [kimi.com](https://kimi.com) |

---

## License

MIT - See [LICENSE](LICENSE) for details.

---

## Acknowledgments

- All 7 tools studied for their innovative architectures
- [Mermaid](https://mermaid.js.org/) - Diagram syntax
- [llms.txt](https://llmstxt.org/) - Index format standard
- [Agent Skills](https://agentskills.io) - Skills specification
