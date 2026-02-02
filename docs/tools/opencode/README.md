# OpenCode: Model-Agnostic AI Coding Agent

> Open source alternative to Claude Code with multi-provider support

---

## Overview

| Attribute | Value |
|-----------|-------|
| Type | CLI/TUI/Desktop Agent |
| Source | [github.com/anomalyco/opencode](https://github.com/anomalyco/opencode) |
| Stars | 60,000+ |
| License | MIT |
| Language | TypeScript (Bun runtime) |
| Providers | 20+ (Claude, OpenAI, Google, Local, etc.) |

OpenCode is an **open-source AI coding agent** built for the terminal, created by Anomaly. It's positioned as a **model-agnostic alternative** to Claude Code with multi-provider support.

---

## Architecture

### System Design

```
┌─────────────────────────────────────────────────────────────────┐
│                     OpenCode Architecture                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                 Multi-Provider Layer                     │    │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌───────┐ │    │
│  │  │Anthropic│ │ OpenAI │ │ Google │ │ Azure  │ │ Local │ │    │
│  │  └────────┘ └────────┘ └────────┘ └────────┘ └───────┘ │    │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌───────┐ │    │
│  │  │ Groq   │ │Mistral │ │ xAI    │ │Bedrock │ │ +10   │ │    │
│  │  └────────┘ └────────┘ └────────┘ └────────┘ └───────┘ │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                   Core Engine                            │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐              │    │
│  │  │  Session │  │ Message  │  │   LLM    │              │    │
│  │  │ Manager  │  │Processor │  │ Streamer │              │    │
│  │  └──────────┘  └──────────┘  └──────────┘              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                      │
│  ┌─────────────────────────┼─────────────────────────────┐      │
│  │                 Agent Layer                            │      │
│  │  ┌───────┐  ┌───────┐  ┌───────┐  ┌─────────┐        │      │
│  │  │ build │  │ plan  │  │general│  │ explore │        │      │
│  │  └───────┘  └───────┘  └───────┘  └─────────┘        │      │
│  └────────────────────────────────────────────────────────┘      │
│                            │                                      │
│  ┌─────────────────────────┼─────────────────────────────┐      │
│  │                 Tool Layer                             │      │
│  │  bash  edit  read  write  glob  grep  websearch  ...  │      │
│  └────────────────────────────────────────────────────────┘      │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Core Components

| Component | Purpose |
|-----------|---------|
| **Session Manager** | Persistent sessions with forking/sharing |
| **Message Processor** | Stream processing with retry logic |
| **LLM Streamer** | Vercel AI SDK integration |
| **Agent System** | Multiple specialized agents |
| **Tool System** | Extensible tool execution |
| **Bus System** | Event-driven communication |

---

## Agent Loop

### Stream Processing Loop

```mermaid
sequenceDiagram
    participant User
    participant Processor as Message Processor
    participant LLM as LLM Streamer
    participant Tools as Tool System
    participant Files as File System
    
    User->>Processor: User message
    
    loop Stream Processing
        Processor->>LLM: streamText()
        
        LLM-->>Processor: text-delta
        LLM-->>Processor: tool-call
        LLM-->>Processor: reasoning-delta
        
        alt Tool Call
            Processor->>Tools: Execute tool
            Tools->>Files: File operation
            Files-->>Tools: Result
            Tools-->>Processor: tool-result
            Processor->>Processor: Create snapshot
        end
    end
    
    Processor-->>User: Complete response
```

### Async Event Loop (TUI Polling)

```typescript
// This is the TUI event loop for async I/O - distinct from the Agent Loop
export namespace EventLoop {
  export async function wait() {
    return new Promise<void>((resolve) => {
      const check = () => {
        const handles = process._getActiveHandles()
        const requests = process._getActiveRequests()
        if (handles.length === 0 && requests.length === 0) {
          resolve()
        } else {
          setImmediate(check)
        }
      }
      check()
    })
  }
}
```

### Stream Event Types

| Event Type | Description |
|------------|-------------|
| `text-delta` | Incremental text output |
| `tool-call` | Tool invocation request |
| `tool-result` | Tool execution result |
| `reasoning-delta` | Extended thinking output |
| `error` | Error event |

---

## Agent System

### Built-in Agents

| Agent | Mode | Purpose | Tool Access |
|-------|------|---------|-------------|
| `build` | primary | Default coding agent | Full |
| `plan` | primary | Read-only analysis | Deny edit tools |
| `general` | subagent | Parallel task execution | Deny todos |
| `explore` | subagent | Fast codebase exploration | Read-only |
| `compaction` | hidden | Context compression | Internal |
| `title` | hidden | Session title generation | Internal |
| `summary` | hidden | Session summarization | Internal |

### Agent Configuration

```typescript
Agent.Info = z.object({
  name: z.string(),
  description: z.string().optional(),
  mode: z.enum(["subagent", "primary", "all"]),
  native: z.boolean().optional(),
  hidden: z.boolean().optional(),
  topP: z.number().optional(),
  temperature: z.number().optional(),
  permission: PermissionNext.Ruleset,
  model: z.object({
    modelID: z.string(),
    providerID: z.string(),
  }).optional(),
  steps: z.number().int().positive().optional(),
})
```

---

## Provider Support

### 20+ Providers

| Provider | SDK Package | Notes |
|----------|-------------|-------|
| **Anthropic** | `@ai-sdk/anthropic` | Extended thinking beta |
| **OpenAI** | `@ai-sdk/openai` | GPT-4, GPT-5 |
| **Google** | `@ai-sdk/google` | Gemini models |
| **Google Vertex** | `@ai-sdk/google-vertex` | Vertex AI |
| **Azure** | `@ai-sdk/azure` | Azure OpenAI |
| **Amazon Bedrock** | `@ai-sdk/amazon-bedrock` | AWS Bedrock |
| **xAI** | `@ai-sdk/xai` | Grok models |
| **Mistral** | `@ai-sdk/mistral` | Mistral models |
| **Groq** | `@ai-sdk/groq` | Fast inference |
| **DeepInfra** | `@ai-sdk/deepinfra` | Various models |
| **Cerebras** | `@ai-sdk/cerebras` | Fast inference |
| **Cohere** | `@ai-sdk/cohere` | Command models |
| **Together AI** | `@ai-sdk/togetherai` | Open source models |
| **Perplexity** | `@ai-sdk/perplexity` | Perplexity models |
| **OpenRouter** | `@openrouter/ai-sdk-provider` | Multi-provider gateway |
| **GitHub Copilot** | Custom SDK | GPT-4/5 via Copilot |
| **GitLab** | `@gitlab/gitlab-ai-provider` | GitLab Duo |
| **Vercel** | `@ai-sdk/vercel` | Vercel AI |
| **OpenAI Compatible** | `@ai-sdk/openai-compatible` | Local (Ollama, LM Studio) |

---

## Session Management

### Session Features

```mermaid
flowchart LR
    subgraph Sessions
        S1[Session 1]
        S2[Session 2]
        S3[Forked Session]
    end
    
    S1 -->|Fork| S3
    S2 -->|Share| URL[Public URL]
    
    subgraph Persistence
        JSON[.opencode/]
        Snap[Snapshots]
    end
    
    S1 --> JSON
    S2 --> JSON
    S3 --> JSON
```

### Session Properties

| Property | Description |
|----------|-------------|
| **Forking** | Fork from any message point |
| **Parent-child** | Nested session support |
| **Sharing** | Built-in URL sharing |
| **Snapshots** | Git-like file snapshots |
| **Persistence** | File-based JSON storage |

### Session Schema

```typescript
Session.Info = z.object({
  id: Identifier.schema("session"),
  slug: z.string(),
  projectID: z.string(),
  directory: z.string(),
  parentID: Identifier.schema("session").optional(),
  summary: z.object({
    additions: z.number(),
    deletions: z.number(),
    files: z.number(),
    diffs: Snapshot.FileDiff.array().optional(),
  }).optional(),
  share: z.object({ url: z.string() }).optional(),
  title: z.string(),
  version: z.string(),
})
```

---

## Tool System

### Available Tools

| Tool | Purpose |
|------|---------|
| `bash` | Execute shell commands |
| `edit` | Edit files with diffs |
| `read` | Read file contents |
| `write` | Write files |
| `glob` | Find files by pattern |
| `grep` | Search file contents |
| `list` | List directory contents |
| `codesearch` | Search GitHub code |
| `websearch` | Web search |
| `webfetch` | Fetch web content |
| `todoread/write` | Task management |
| `apply_patch` | Apply git patches |
| `batch` | Batch operations |

### Permission System

| Level | Description |
|-------|-------------|
| `allow` | Auto-execute |
| `deny` | Block execution |
| `ask` | Request approval |

### Doom Loop Detection

OpenCode detects when the same tool is called 3+ times with identical input, preventing infinite loops.

---

## Desktop Application

### Cross-Platform Support

| Platform | Formats |
|----------|---------|
| macOS | Apple Silicon, Intel |
| Windows | Installer |
| Linux | .deb, .rpm, AppImage |

### Desktop Features

| Feature | Description |
|---------|-------------|
| Native UI | Solid.js-based interface |
| Multi-session | Tab-based session management |
| File browser | Integrated file navigation |
| Settings | GUI configuration |

---

## Customization Points

Based on comprehensive analysis, OpenCode provides **12 major customization categories**:

### 1. Plugin System (26 Hooks)

**Plugin structure**:
```typescript
import type { Plugin } from "@opencode-ai/plugin"

export const MyPlugin: Plugin = async ({ client, project, $, directory, worktree }) => {
  return {
    event: async ({ event }) => { /* handle events */ },
    tool: { /* custom tools */ },
    "tool.execute.before": async (input, output) => { /* intercept */ }
  }
}
```

**Hook categories**:
| Category | Hooks |
|----------|-------|
| Chat | `chat.message`, `chat.params`, `chat.headers`, `messages.transform`, `system.transform` |
| Tool | `tool.execute.before`, `tool.execute.after` |
| Command | `command.execute.before` |
| Permission | `permission.ask` |
| Session | `session.compacting` |

### 2. Custom Tools

**Location**: `.opencode/tools/` (project) or `~/.config/opencode/tools/` (global)

```typescript
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Tool description",
  args: {
    query: tool.schema.string().describe("Search query"),
    limit: tool.schema.number().optional()
  },
  async execute(args, context) {
    return "Tool result"
  }
})
```

### 3. Custom Agents

**Location**: `.opencode/agents/*.md` or config

```yaml
# .opencode/agents/reviewer.md
---
description: Code review agent
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
permission:
  bash:
    "*": deny
---

You are a code reviewer. Focus on security and performance.
```

**Agent modes**: `primary` (user-facing), `subagent` (invokable), `all`

### 4. Provider Configuration

**18+ bundled providers** via AI SDK:

```json
// opencode.json
{
  "provider": {
    "anthropic": {
      "options": {
        "apiKey": "{env:ANTHROPIC_API_KEY}"
      }
    },
    "custom": {
      "options": {
        "baseURL": "https://my-api.com",
        "apiKey": "{env:MY_API_KEY}"
      }
    }
  }
}
```

### 5. MCP + ACP Integration

**MCP Server types**:
```json
{
  "mcp": {
    "local-server": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-everything"],
      "environment": { "MY_VAR": "value" }
    },
    "remote-server": {
      "type": "remote",
      "url": "https://mcp.example.com/mcp",
      "oauth": {
        "clientId": "{env:CLIENT_ID}",
        "scope": "tools:read tools:execute"
      }
    }
  }
}
```

**ACP (Agent Client Protocol)** for agent-to-agent communication.

### 6. Permission Policies

**Glob pattern support**:
```json
{
  "permission": {
    "edit": "ask",
    "bash": {
      "*": "ask",
      "git status": "allow",
      "rm -rf *": "deny"
    },
    "read": {
      "*.env": "ask",
      "*": "allow"
    }
  }
}
```

**Actions**: `allow`, `deny`, `ask`

### 7. Skills System

**Location**: `.opencode/skill/*/SKILL.md`

```markdown
---
name: my-skill
description: What this skill does
---

## Instructions
Skill content loaded on-demand...
```

Skills automatically become slash commands.

### 8. Configuration Hierarchy

**Precedence** (highest to lowest):
1. `OPENCODE_CONFIG_CONTENT` env var
2. Project config (`opencode.json`)
3. Custom path (`OPENCODE_CONFIG` env var)
4. Global config (`~/.config/opencode/opencode.json`)
5. Remote config (`.well-known/opencode`)
6. Managed config (enterprise)

### 9. Commands System

```json
{
  "command": {
    "my-command": {
      "description": "Command description",
      "agent": "specific-agent",
      "model": "provider/model",
      "template": "Prompt with $1, $2, $ARGUMENTS"
    }
  }
}
```

### 10. Event System (40+ Event Types)

| Category | Events |
|----------|--------|
| Session | `session.created`, `session.updated`, `session.error`, `session.idle` |
| Message | `message.updated`, `message.removed`, `message.part.updated` |
| Tool | `tool.execute.before`, `tool.execute.after` |
| Permission | `permission.asked`, `permission.replied` |
| MCP | `mcp.tools.changed`, `mcp.browser.open.failed` |

### 11. Custom Tool Categories

| Category | Tools |
|----------|-------|
| filesystem | read, write, edit, glob, grep, list |
| shell | bash, apply_patch |
| web | websearch, webfetch, codesearch |
| delegation | subagent spawning |
| memory | todoread, todowrite |

### 12. Environment Variables

```json
{
  "provider": {
    "options": {
      "apiKey": "{env:API_KEY}"
    }
  },
  "agent": {
    "prompt": "{file:./prompts/agent.txt}"
  }
}
```

### Customization Summary

| Point | Location | Scope |
|-------|----------|-------|
| **Plugins** | `.opencode/plugins/` | Project |
| **Tools** | `.opencode/tools/` | Project |
| **Agents** | `.opencode/agents/` | Project |
| **Providers** | `opencode.json` | Project/Global |
| **MCP** | `opencode.json` | Project/Global |
| **Permissions** | `opencode.json` | Project |
| **Skills** | `.opencode/skill/` | Project |
| **Commands** | `opencode.json` | Project |

---

## Technology Stack

| Component | Technology |
|-----------|------------|
| Runtime | Bun |
| Language | TypeScript |
| AI SDK | Vercel AI SDK |
| Validation | Zod schemas |
| CLI | Yargs |
| TUI | @clack/prompts |
| Desktop | Solid.js |
| Storage | File-based JSON |
| MCP | @modelcontextprotocol/sdk |
| ACP | @agentclientprotocol/sdk |

---

## Comparison Summary

### vs. Claude Code

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| **License** | MIT (Open Source) | Proprietary |
| **Models** | 20+ providers | Anthropic only |
| **Local models** | Yes | No |
| **Multi-session** | Forking, sharing | Single session |
| **Desktop app** | Yes (Beta) | CLI only |
| **Plugins** | Hook system | MCP + Skills |
| **Self-hosted** | Yes | No |
| **Cost** | Free (OSS) | Paid API |

### When to Use OpenCode

| Use Case | Recommendation |
|----------|----------------|
| Multi-provider needs | **Highly Recommended** |
| Self-hosting requirements | **Highly Recommended** |
| Local model usage | **Highly Recommended** |
| Cost optimization | **Recommended** |
| Anthropic-only with MCP | Use Claude Code |

---

## CLI Usage

```bash
# Install
npm install -g opencode

# Start session
opencode

# With specific provider
opencode --provider openai

# With specific model
opencode --model gpt-4

# Continue session
opencode --continue

# Plan mode
opencode --agent plan
```

---

## Resources

| Resource | URL |
|----------|-----|
| GitHub | https://github.com/anomalyco/opencode |
| Documentation | https://opencode.ai/docs |
| Discord | https://discord.gg/opencode |
| Desktop Download | https://opencode.ai/download |

---

## See Also

- [../README.md](../README.md) - Tools overview
- [diagrams.md](diagrams.md) - Detailed architecture diagrams
- [examples.md](examples.md) - Usage examples
- [../BEST-PRACTICES.md](../BEST-PRACTICES.md) - Integration patterns
