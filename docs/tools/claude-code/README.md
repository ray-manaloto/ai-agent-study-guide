# Claude Code: Agentic Coding Assistant

> Anthropic's official CLI for Claude with tool orchestration and MCP integration

---

## Overview

| Attribute | Value |
|-----------|-------|
| Provider | Anthropic |
| Type | CLI Agent |
| Language | TypeScript/Node.js |
| Source | Proprietary (Anthropic) |
| Multi-Agent | Subagent Delegation |
| Extension System | MCP, Skills, Hooks |

Claude Code is an **agentic coding assistant** that runs as a CLI tool in the terminal. It acts as an **agentic harness** around Claude AI models, providing tools, context management, and execution environment.

---

## Architecture

### System Design

```
┌─────────────────────────────────────────────────────────────────┐
│                     Claude Code Architecture                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                  Claude AI Models                        │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐                  │    │
│  │  │  Haiku  │  │ Sonnet  │  │  Opus   │                  │    │
│  │  │ (Fast)  │  │(Balanced│  │(Complex)│                  │    │
│  │  └─────────┘  └─────────┘  └─────────┘                  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   Agentic Harness                        │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐ │    │
│  │  │   Tool   │  │ Context  │  │ Session  │  │Permission│ │    │
│  │  │ Registry │  │ Manager  │  │  State   │  │ System  │ │    │
│  │  └──────────┘  └──────────┘  └──────────┘  └─────────┘ │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                      │
│  ┌─────────────────────────┼─────────────────────────────┐      │
│  │           Extension Layer                              │      │
│  │  ┌───────┐  ┌───────┐  ┌───────┐  ┌──────────┐       │      │
│  │  │Skills │  │  MCP  │  │ Hooks │  │Subagents │       │      │
│  │  └───────┘  └───────┘  └───────┘  └──────────┘       │      │
│  └────────────────────────────────────────────────────────┘      │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Core Components

| Component | Purpose |
|-----------|---------|
| **Claude AI Models** | Reasoning engine (Haiku/Sonnet/Opus) |
| **Tool Registry** | Built-in tools (file ops, search, exec, web) |
| **Context Manager** | Automatic compaction, prioritization |
| **Session State** | Checkpoints, conversation history |
| **Permission System** | Approval flows, trust levels |

### Built-in Tools (4 Categories)

| Category | Tools | Purpose |
|----------|-------|---------|
| **File Operations** | Read, Edit, Create, Rename | File manipulation |
| **Search** | Glob, Grep, LSP | Codebase exploration |
| **Execution** | Bash, Git, Test runners | Command execution |
| **Web** | Search, Fetch, Docs | External resources |

---

## Event Loop

### The Agentic Loop (Three-Phase)

```mermaid
flowchart TB
    subgraph Phase1["1. GATHER CONTEXT"]
        Search[Search Files]
        Read[Read Code]
        Git[Check Git State]
    end
    
    subgraph Phase2["2. TAKE ACTION"]
        Edit[Edit Files]
        Run[Run Commands]
        Tool[Execute Tools]
    end
    
    subgraph Phase3["3. VERIFY RESULTS"]
        Test[Run Tests]
        Check[Check Output]
        Validate[Validate Changes]
    end
    
    User[User Prompt] --> Phase1
    Phase1 --> Phase2
    Phase2 --> Phase3
    Phase3 --> Success{Success?}
    Success -->|Yes| Done[Complete]
    Success -->|No| Phase1

    click Search "#built-in-tools-4-categories" "View Search tools"
    click Read "#built-in-tools-4-categories" "View File Operations"
    click Edit "#built-in-tools-4-categories" "View File Operations"
    click Run "#built-in-tools-4-categories" "View Execution tools"
    click Tool "#tool-execution-flow" "View Tool Execution Flow"
    click Test "#common-workflows" "View Test workflows"
    click User "#message-flow" "View Message Flow"
```

### Loop Characteristics

| Characteristic | Description |
|----------------|-------------|
| **Adaptive** | Phases blend; Claude decides each step |
| **Interruptible** | User can interrupt at any point |
| **Autonomous** | Chains dozens of actions, self-correcting |
| **Tool-driven** | Every phase uses tools |

### Message Flow

```mermaid
sequenceDiagram
    participant User
    participant Claude as Claude Model
    participant Tools as Tool System
    participant Files as File System
    
    User->>Claude: Natural language request
    
    rect rgb(240, 248, 255)
        Note over Claude: Planning Phase
        Claude->>Claude: Analyze request
        Claude->>Claude: Plan approach
    end
    
    loop Tool Execution
        Claude->>Tools: Tool call request
        Tools->>Tools: Permission check
        
        alt Needs Approval
            Tools-->>User: Request approval
            User-->>Tools: Approve/Deny
        end
        
        Tools->>Files: Execute operation
        Files-->>Tools: Result
        Tools-->>Claude: Tool result
    end
    
    Claude-->>User: Response + summary
```

---

## Tool Execution Flow

### Permission System

```mermaid
flowchart TD
    Call[Claude Tool Call] --> Check{Permission Check}
    Check -->|Auto-accept| Execute
    Check -->|Needs Approval| Approve{User Approval}
    Approve -->|Yes| Execute[Execute Tool]
    Approve -->|No| Cancel[Cancel]
    Execute --> Checkpoint[Create Checkpoint]
    Checkpoint --> Result[Return Results]

    click Check "#permission-modes" "View Permission Modes"
    click Checkpoint "#checkpoint-system" "View Checkpoint System"
    click Call "#the-agentic-loop-three-phase" "View Agentic Loop"
```

### Permission Modes

| Mode | File Edits | Shell Commands | Use Case |
|------|-----------|----------------|----------|
| **Default** | Ask | Ask | Standard safety |
| **Auto-accept edits** | Auto | Ask | Trusted file ops |
| **Plan mode** | Deny | Deny | Read-only analysis |

### Checkpoint System

| Feature | Description |
|---------|-------------|
| **Before Edit** | Snapshot current file contents |
| **Local to Session** | Separate from git |
| **Rewind** | Press `Esc` twice to undo |
| **Limitation** | Can't checkpoint DB/API changes |

---

## Multi-Agent Capabilities

### Subagent Delegation

```mermaid
flowchart TB
    Main[Main Agent] --> Task1[Spawn Subagent 1]
    Main --> Task2[Spawn Subagent 2]
    Main --> Task3[Spawn Subagent N]
    
    Task1 --> Context1[Isolated 200k Context]
    Task2 --> Context2[Isolated 200k Context]
    Task3 --> ContextN[Isolated 200k Context]
    
    Context1 --> Result1[Summary Return]
    Context2 --> Result2[Summary Return]
    ContextN --> ResultN[Summary Return]
    
    Result1 --> Synthesize[Main Agent Synthesizes]
    Result2 --> Synthesize
    ResultN --> Synthesize

    click Main "#context-window-management" "View Context Management"
    click Task1 "#5-custom-subagents" "View Custom Subagents"
    click Context1 "#delegation-benefits" "View Delegation Benefits"
    click Result1 "#delegation-benefits" "View Summary Return pattern"
    click Synthesize "../BEST-PRACTICES.md#1-thin-orchestrator-pattern" "View Thin Orchestrator Pattern"
```

### Delegation Benefits

| Benefit | Description |
|---------|-------------|
| **Isolated Context** | Each subagent gets fresh 200k window |
| **No Bloat** | Subagent work doesn't consume main context |
| **Summary Return** | Only final results returned to main |
| **Parallel Potential** | Multiple subagents can run concurrently |

---

## Extension System

### Four Extension Layers

```
┌──────────────────────────────────────┐
│       Core Tools (built-in)          │
├──────────────────────────────────────┤
│    Skills (on-demand workflows)      │
├──────────────────────────────────────┤
│    MCP (external services)           │
├──────────────────────────────────────┤
│    Hooks (automation)                │
├──────────────────────────────────────┤
│    Subagents (delegation)            │
└──────────────────────────────────────┘
```

### Skills System

| Aspect | Description |
|--------|-------------|
| **Loading** | Lazy (descriptions visible, content on-demand) |
| **Invocation** | Slash commands (`/skill-name`) |
| **Location** | `~/.claude/commands/` |
| **Purpose** | Complex multi-step workflows |

### MCP Integration

| Feature | Description |
|---------|-------------|
| **Protocol** | Model Context Protocol (JSON-RPC) |
| **Servers** | External services connected via MCP |
| **Tools** | Each MCP server provides tools |
| **Config** | `~/.claude/settings.json` |

### Hook System

| Hook Type | Trigger | Use Case |
|-----------|---------|----------|
| `pre-edit` | Before file modification | Validation |
| `post-edit` | After file modification | Formatting |
| `pre-command` | Before shell execution | Safety check |
| `post-command` | After shell execution | Logging |
| `pre-task` | Before task start | Setup |
| `post-task` | After task completion | Cleanup |

---

## Customization Points

Based on comprehensive research, Claude Code provides **7 major customization categories**:

### 1. MCP Servers (Model Context Protocol)

**Primary extension mechanism** for external tools and data sources.

```bash
# Add HTTP server (recommended)
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Add local stdio server
claude mcp add --transport stdio filesystem -- npx -y @modelcontextprotocol/server-filesystem

# With environment variables
claude mcp add --transport stdio --env API_KEY=xxx my-server -- npx -y my-mcp-server
```

**Configuration scopes**:
- Local: `~/.claude.json` (personal)
- Project: `.mcp.json` (version controlled)
- User: `~/.claude.json` (all projects)
- Plugin: Bundled with plugins
- Managed: Enterprise-wide

### 2. Skills System

Skills are reusable instruction packages following the [Agent Skills](https://agentskills.io) standard.

**SKILL.md format**:
```yaml
---
name: skill-name
description: What this skill does and when to use it
disable-model-invocation: true  # Only user can invoke
allowed-tools: Read, Grep, Glob  # Tool restrictions
context: fork  # Run in isolated subagent
agent: Explore  # Which subagent type
---

Your skill instructions here...
```

**Locations**:
| Location | Scope |
|----------|-------|
| `~/.claude/skills/<skill-name>/SKILL.md` | Personal (all projects) |
| `.claude/skills/<skill-name>/SKILL.md` | Project only |
| `<plugin>/skills/<skill-name>/SKILL.md` | Plugin-provided |

### 3. Hooks System

**11 lifecycle hook events**:

| Event | Purpose |
|-------|---------|
| `SessionStart` | Session begins/resumes |
| `UserPromptSubmit` | Before processing user input |
| `PreToolUse` | Before tool execution (can block) |
| `PermissionRequest` | Permission dialog appears |
| `PostToolUse` | After successful tool execution |
| `PostToolUseFailure` | After tool failure |
| `Notification` | System notification |
| `SubagentStart/Stop` | Subagent lifecycle |
| `Stop` | Response complete |
| `PreCompact` | Before context compaction |
| `SessionEnd` | Session terminates |

**Configuration**:
```json
// ~/.claude/settings.json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": ".claude/hooks/validate.sh",
        "timeout": 30
      }]
    }]
  }
}
```

### 4. Permission System

**Permission modes**:
- `default` - Ask for each tool use
- `plan` - Auto-approve read-only tools
- `acceptEdits` - Auto-approve edits
- `dontAsk` - Auto-approve all

**Per-tool/pattern settings**:
```json
{
  "permissions": {
    "allow": ["Read", "Grep", "Glob"],
    "deny": ["Bash(rm *)"],
    "dontAskAgain": {
      "Bash": ["npm test", "npm run build"]
    }
  }
}
```

### 5. Custom Subagents

**Create custom agents in `.claude/agents/`**:

```yaml
---
name: custom-agent
description: What this agent does
model: claude-sonnet-4-5
allowed-tools: Read, Grep, Bash
skills: [skill1, skill2]
---

System prompt for this agent...
```

**Invocation**: Via skills with `context: fork` and `agent: <name>`, or CLI `claude --agent <name>`

### 6. CLAUDE.md Context

Persistent instructions loaded every session:

| Location | Scope |
|----------|-------|
| `~/.claude/CLAUDE.md` | Global (all projects) |
| `.claude/CLAUDE.md` | Project-specific |

**Dynamic context injection**:
- Skills with `` `!command` `` syntax inject shell output
- `SessionStart` hooks can add context via stdout

### 7. Slash Commands

Skills automatically become slash commands:
- Built-in: `/help`, `/compact`, `/init`, `/hooks`, `/permissions`, `/mcp`
- Custom: Create skill → `/skill-name`
- Legacy: `.claude/commands/` (skills recommended)

### Customization Summary

| Point | Configuration | Shareable |
|-------|---------------|-----------|
| **MCP Servers** | `.mcp.json`, `~/.claude.json` | Yes |
| **Skills** | `.claude/skills/*/SKILL.md` | Yes |
| **Hooks** | `.claude/settings.json` | Yes |
| **Permissions** | `.claude/settings.json` | Yes |
| **Subagents** | `.claude/agents/*.md` | Yes |
| **CLAUDE.md** | `.claude/CLAUDE.md` | Yes |

---

## Session Management

### Session Properties

| Property | Description |
|----------|-------------|
| **Ephemeral** | No persistent memory between sessions |
| **Directory-scoped** | Sessions tied to working directory |
| **Resumable** | `claude --continue` or `--resume` |
| **Forkable** | `--fork-session` creates branch |

### CLAUDE.md Configuration

| Purpose | Description |
|---------|-------------|
| **Persistent Instructions** | Loaded every session |
| **Project Context** | Project-specific rules |
| **Custom Commands** | Define slash commands |
| **Location** | Project root or `~/.claude/` |

---

## Context Window Management

### Automatic Strategies

| Strategy | Description |
|----------|-------------|
| **Compaction** | Clears old tool outputs, summarizes |
| **Preservation Priority** | User requests > code > instructions |
| **Lazy Loading** | Skills loaded on-demand |
| **Subagent Isolation** | Heavy work in separate contexts |

### Priority Order

1. User's explicit requests
2. Code snippets and file contents
3. Detailed instructions
4. Tool outputs (summarized)
5. Conversation history (oldest removed first)

---

## Integration Patterns

### CLI Usage

```bash
# Start session
claude

# Continue previous session
claude --continue

# Plan mode (read-only)
claude --plan

# With specific model
claude --model opus

# Fork from session
claude --fork-session <session-id>
```

### Common Workflows

| Workflow | Commands |
|----------|----------|
| **Code Review** | Read files → Analyze → Report |
| **Bug Fix** | Search → Identify → Edit → Test |
| **Feature** | Plan → Implement → Test → Document |
| **Refactor** | Analyze → Edit → Verify |

---

## Comparison Summary

### vs. Other Tools

| Feature | Claude Code | OpenCode | Kata |
|---------|-------------|----------|------|
| Provider Lock | Anthropic only | Multi-provider | Anthropic only |
| Open Source | No | Yes | Yes |
| Multi-Agent | Subagents | 2 modes | Phase-based |
| Extension System | MCP + Skills + Hooks | Plugins | Skills |
| Context Management | Automatic | Manual | Artifacts |

### When to Use Claude Code

| Use Case | Recommendation |
|----------|----------------|
| Anthropic-only workflows | **Recommended** |
| MCP ecosystem integration | **Recommended** |
| Simple single-agent tasks | **Recommended** |
| Multi-provider needs | Use OpenCode |
| Complex orchestration | Use Kata/GSD |

---

## Resources

| Resource | URL |
|----------|-----|
| Documentation | https://docs.anthropic.com/claude-code |
| MCP Specification | https://modelcontextprotocol.io |
| GitHub (plugins) | https://github.com/anthropics/claude-code |

---

## See Also

- [../README.md](../README.md) - Tools overview
- [diagrams.md](diagrams.md) - Detailed architecture diagrams
- [examples.md](examples.md) - Usage examples
- [../BEST-PRACTICES.md](../BEST-PRACTICES.md) - Integration patterns
