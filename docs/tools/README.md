# AI Coding Agent Tools & Frameworks

> Comprehensive guide to modern AI coding agents, CLI tools, and multi-agent orchestration frameworks

---

## Overview

This directory contains detailed documentation for leading AI coding agent tools and frameworks. Each tool is analyzed for its architecture, agent loop, multi-agent capabilities, and integration patterns.

| Tool | Type | Provider Support | Multi-Agent | Key Feature |
|------|------|------------------|-------------|-------------|
| [Codex](#codex) | CLI/TUI | OpenAI | Single | Rust TUI, Direct Channels |
| [Claude Code](#claude-code) | CLI | Anthropic | Single + Delegation | MCP Integration |
| [OpenCode](#opencode) | CLI/TUI | Multi-Provider | Built-in Agents | 100% Open Source |
| [Oh-My-OpenCode](#oh-my-opencode) | Framework | Multi-Provider | Swarm/Hive | Skills + Hooks |
| [Kimi K2](#kimi-k2) | Model + API | Moonshot AI | Agent Swarm (100) | PARL Training |
| [Get-Shit-Done](#get-shit-done) | Framework | Multi-Provider | Multi-Agent | Productivity Focus |
| [Kata](#kata) | Orchestrator | Anthropic | Multi-Agent | Spec-Driven Phases |

---

## Tool Categories

### 1. Native CLI Agents

Tools that provide direct terminal-based AI coding assistance:

| Tool | Language | Architecture | Source |
|------|----------|--------------|--------|
| Codex | Rust | TUI + Channels | [openai/codex](https://github.com/openai/codex) |
| Claude Code | TypeScript | CLI + MCP | Anthropic (Closed) |
| OpenCode | TypeScript | TUI + Client/Server | [anomalyco/opencode](https://github.com/anomalyco/opencode) |

### 2. Orchestration Frameworks

Frameworks that coordinate multiple agents for complex workflows:

| Tool | Approach | Key Pattern |
|------|----------|-------------|
| Kata | Spec-driven phases | Thin orchestrators + Specialized agents |
| Oh-My-OpenCode | Swarm orchestration | Hive-mind + Skills system |
| Get-Shit-Done | Task decomposition | Productivity-focused workflows |

### 3. Model-Native Agents

Models with built-in agentic capabilities:

| Model | Provider | Agent Type |
|-------|----------|------------|
| Kimi K2.5 | Moonshot AI | Self-directed swarm (up to 100 agents) |

---

## Detailed Tool Profiles

### Codex

**Type**: Native CLI/TUI Agent  
**Source**: [github.com/openai/codex](https://github.com/openai/codex)  
**Language**: Rust

The original AI coding agent from OpenAI. Features a sophisticated TUI built with Ratatui and a channel-based communication model.

**Key Architecture**:
- Direct async channels (TUI ↔ Core)
- Operation/Event message passing
- Queue-based approval system
- Thread-isolated sessions

**Documentation**: [codex/](codex/)

---

### Claude Code

**Type**: Official Anthropic CLI  
**Source**: Closed (Anthropic)  
**Language**: TypeScript/Node.js

Anthropic's official CLI for Claude. Features deep MCP (Model Context Protocol) integration and sophisticated tool orchestration.

**Key Architecture**:
- MCP-based tool integration
- Permission-based approvals
- Session persistence
- Sub-agent delegation (Task tool)

**Documentation**: [claude-code/](claude-code/)

---

### OpenCode

**Type**: Open Source CLI/TUI  
**Source**: [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode)  
**Stars**: 94.8k+  
**Language**: TypeScript

The open source alternative to Claude Code. 100% open source with multi-provider support and a focus on TUI excellence.

**Key Architecture**:
- Client/Server architecture
- Multi-provider support (Claude, OpenAI, Google, Local)
- Built-in LSP support
- Plan/Build agent modes

**Documentation**: [opencode/](opencode/)

---

### Oh-My-OpenCode

**Type**: OpenCode Extension Framework  
**Source**: Community  
**Language**: TypeScript

An extension framework for OpenCode that adds swarm orchestration, skills system, and advanced hooks.

**Key Architecture**:
- Skill injection system
- Category-based delegation
- Hive-mind swarm coordination
- Claude-Flow integration

**Documentation**: [oh-my-opencode/](oh-my-opencode/)

---

### Kimi K2

**Type**: Model + API with Native Agent Capabilities  
**Source**: [kimi.com](https://kimi.com)  
**Provider**: Moonshot AI

The most powerful open-source model with native agent swarm capabilities. Can self-direct up to 100 sub-agents executing parallel workflows.

**Key Architecture**:
- Parallel-Agent Reinforcement Learning (PARL)
- Trainable orchestrator + Frozen subagents
- Up to 1,500 coordinated tool calls
- Critical Steps latency optimization

**Documentation**: [kimi-k2/](kimi-k2/)

---

### Get-Shit-Done

**Type**: Productivity Framework  
**Source**: [github.com/glittercowboy/get-shit-done](https://github.com/glittercowboy/get-shit-done)

A productivity-focused AI agent framework designed for getting things done efficiently.

**Key Architecture**:
- Task decomposition patterns
- Multi-agent coordination
- Productivity workflows

**Documentation**: [get-shit-done/](get-shit-done/)

---

### Kata

**Type**: Multi-Agent Orchestrator  
**Source**: [github.com/gannonh/kata](https://github.com/gannonh/kata)  
**Website**: [kata.sh](https://kata.sh)

Spec-driven development orchestrator for Claude Code. Features phase-based workflows with thin orchestrators spawning specialized agents.

**Key Architecture**:
- 8-phase development workflow
- Thin orchestrators + Specialized agents
- Fresh 200k context windows per plan
- Atomic git commits per task
- XML prompt formatting

**Documentation**: [kata/](kata/)

---

## Comparison Matrix

### Agent Loop Architecture

| Tool | Agent Loop Type | Message Format | Async Model |
|------|-----------------|----------------|-------------|
| Codex | Channel-based | Op/EventMsg enums | Tokio async |
| Claude Code | MCP-based | JSON-RPC | Node async |
| OpenCode | Client/Server | JSON | Bun async |
| Kata | Phase-based | XML plans | Sequential waves |
| Kimi K2 | Swarm | API calls | Parallel agents |

### Multi-Agent Capabilities

| Tool | Max Agents | Coordination | Communication |
|------|------------|--------------|---------------|
| Codex | 1 | N/A | Direct channel |
| Claude Code | 1 + subagents | Task delegation | Context passing |
| OpenCode | 2 (plan/build) | Tab switching | Shared context |
| Oh-My-OpenCode | 15+ | Hive-mind | Memory + hooks |
| Kata | ~10 | Phase orchestrator | XML plans |
| Kimi K2 | 100 | PARL orchestrator | API coordination |

### Provider Support

| Tool | Anthropic | OpenAI | Google | Local | Other |
|------|-----------|--------|--------|-------|-------|
| Codex | - | Yes | - | - | - |
| Claude Code | Yes | - | - | - | - |
| OpenCode | Yes | Yes | Yes | Yes | Many |
| Oh-My-OpenCode | Yes | Yes | Yes | Yes | Many |
| Kata | Yes | - | - | - | - |
| Kimi K2 | - | - | - | - | Moonshot |

---

## Universal Patterns

### Common Agent Loop Pattern

All tools follow a similar core agent loop pattern:

```
User Input → Parse → Route → Execute → Stream → Display
              ↓
         Tool Calls → Approval → Execute → Result
              ↓
         Memory/State → Persist
```

### Common Message Types

| Category | Inbound | Outbound |
|----------|---------|----------|
| User | UserMessage, Command | - |
| Agent | - | Response, ToolCall |
| Tool | ToolResult | ToolRequest |
| System | Config, Interrupt | Event, Status |

### Common Approval Patterns

1. **Explicit Approval** - User must approve each action
2. **Policy-Based** - Rules determine auto-approval
3. **Trust Levels** - Tiered permissions by risk
4. **Session Memory** - Learn from past approvals

---

## Interactive Diagrams

For an interactive exploration experience with clickable nodes:

- **[Interactive Tools Overview](interactive-tools-overview.html)** - Clickable architecture diagrams, tool comparison, and navigation

Features:
- Click diagram nodes to navigate to detailed documentation
- Expandable tool cards with customization details
- Side-by-side architecture comparison
- Feature matrix with direct links

---

## See Also

- [CONCEPTS.md](../CONCEPTS.md) - Core concepts and patterns
- [PATTERNS.md](../PATTERNS.md) - Implementation patterns
- [BEST-PRACTICES.md](BEST-PRACTICES.md) - Combined best practices
- [UNIFIED-HARNESS.md](UNIFIED-HARNESS.md) - Multi-provider harness design

---

## Navigation

| Tool | Documentation | Diagrams | Examples |
|------|---------------|----------|----------|
| Codex | [README](codex/README.md) | [Diagrams](codex/diagrams.md) | [Examples](codex/examples.md) |
| Claude Code | [README](claude-code/README.md) | [Diagrams](claude-code/diagrams.md) | [Examples](claude-code/examples.md) |
| OpenCode | [README](opencode/README.md) | [Diagrams](opencode/diagrams.md) | [Examples](opencode/examples.md) |
| Oh-My-OpenCode | [README](oh-my-opencode/README.md) | [Diagrams](oh-my-opencode/diagrams.md) | [Examples](oh-my-opencode/examples.md) |
| Kimi K2 | [README](kimi-k2/README.md) | [Diagrams](kimi-k2/diagrams.md) | [Examples](kimi-k2/examples.md) |
| Get-Shit-Done | [README](get-shit-done/README.md) | [Diagrams](get-shit-done/diagrams.md) | [Examples](get-shit-done/examples.md) |
| Kata | [README](kata/README.md) | [Diagrams](kata/diagrams.md) | [Examples](kata/examples.md) |
