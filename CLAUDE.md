# Claude Code Configuration

> AI Agent Study Guide - Learn to build coding agents by studying OpenAI Codex-RS

---

## Project Context

This is a **documentation-only** repository analyzing the OpenAI Codex-RS TUI architecture.

| Attribute | Value |
|-----------|-------|
| Type | Documentation repository |
| Purpose | Study AI coding agent architecture |
| Source | https://github.com/openai/codex |
| Implementation Code | **NONE** (forbidden) |

### What This Repository Contains

- Mermaid sequence diagrams of Codex-RS communication flows
- Documentation of architectural patterns
- Core concepts extracted from source code analysis
- Templates for LLM-optimizing other projects

### What This Repository Does NOT Contain

- Implementation code
- Runnable applications
- Package dependencies
- Build systems

---

## Entry Points

Read files in this priority order:

| Priority | File | Purpose | When to Read |
|----------|------|---------|--------------|
| 1 | `AGENTS.md` | AI agent instructions | Always first |
| 2 | `llms.txt` | Documentation index | Quick reference |
| 3 | `llms-full.txt` | Complete context | Deep understanding |
| 4 | `docs/WORKFLOWS.md` | Task workflows | Before making changes |
| 5 | `docs/architecture-diagram.md` | Technical diagrams | Understanding architecture |

### Subdirectory Context

When working in `docs/`:
- Also read `docs/AGENTS.md` for local context
- This provides directory-specific instructions

---

## Complete File Map

### Root Directory

| File | Purpose | Line Count |
|------|---------|------------|
| `AGENTS.md` | AI agent coordination | 300+ |
| `CLAUDE.md` | Claude Code config (this file) | 300+ |
| `.cursorrules` | Cursor AI rules | 300+ |
| `llms.txt` | Documentation index | 300+ |
| `llms-full.txt` | Complete context dump | Variable |
| `README.md` | Project overview | ~50 |

### docs/ Directory

| File | Purpose | Content |
|------|---------|---------|
| `architecture-diagram.md` | Mermaid diagrams | Primary technical reference |
| `codex-architecture.html` | Rendered HTML | Generated (DO NOT EDIT) |
| `CONCEPTS.md` | Core concepts | Communication patterns, safety |
| `GLOSSARY.md` | Term definitions | Quick reference |
| `PATTERNS.md` | Implementation patterns | Reusable code patterns |
| `WORKFLOWS.md` | Task workflows | Step-by-step guides |
| `TOOLS-RESEARCH.md` | AI tools research | Vercel Labs tools |
| `AGENTS.md` | Subdirectory context | Local agent instructions |

### docs/templates/ Directory

| File | Purpose |
|------|---------|
| `LLM-OPTIMIZATION-TEMPLATE.md` | Manual template for LLM-optimizing projects |
| `llm-project-optimization/SKILL.md` | Installable agent skill |

### scripts/ Directory

| File | Purpose |
|------|---------|
| `render-diagrams.sh` | Validate Mermaid diagrams |

---

## Critical Constraints

### Forbidden Actions

| Action | Why Forbidden |
|--------|---------------|
| Create implementation code | Documentation-only repository |
| Modify HTML files directly | Must regenerate from Mermaid source |
| Add package dependencies | No package manager |
| Create test files | No testing framework |
| Add build configuration | No build system |

### Required Actions

| When | Action |
|------|--------|
| After any doc change | Update `llms.txt` |
| After significant changes | Update `llms-full.txt` |
| After Mermaid changes | Run `./scripts/render-diagrams.sh` |
| Before completing work | Verify with quality checklist |

---

## Common Tasks

### Task 1: Add New Architecture Diagram

```bash
# 1. Edit the diagram file
# Add new section to docs/architecture-diagram.md

# 2. Validate Mermaid syntax
./scripts/render-diagrams.sh

# 3. Preview in terminal
glow docs/architecture-diagram.md

# 4. Update indexes
# Add entry to llms.txt
# Add details to llms-full.txt

# 5. View rendered output
open docs/codex-architecture.html
```

### Task 2: Update Existing Documentation

```bash
# 1. Read current content
cat docs/[file].md

# 2. Check for cross-references
grep -l "[topic]" *.txt docs/*.md

# 3. Make changes maintaining style

# 4. Update indexes
# - llms.txt
# - llms-full.txt

# 5. Verify
glow docs/[file].md
```

### Task 3: Add New Concept/Pattern

1. Choose correct file:
   - `docs/CONCEPTS.md` - Communication patterns, safety patterns
   - `docs/PATTERNS.md` - Reusable implementation patterns
   - `docs/GLOSSARY.md` - Term definitions

2. Follow existing format in target file

3. Include source file reference:
   ```markdown
   **Source**: `codex-rs/path/to/file.rs`
   ```

4. Update indexes

### Task 4: Verify Repository Integrity

```bash
# Validate Mermaid diagrams
./scripts/render-diagrams.sh

# Check file structure
ls -la docs/

# Preview documentation
glow docs/architecture-diagram.md

# View rendered diagrams
open docs/codex-architecture.html
```

---

## Verification Commands

| Command | Purpose |
|---------|---------|
| `./scripts/render-diagrams.sh` | Validate Mermaid syntax |
| `glow docs/[file].md` | Terminal markdown preview |
| `open docs/codex-architecture.html` | View rendered diagrams |
| `cat llms.txt` | Check documentation index |
| `wc -l docs/*.md` | Check documentation coverage |

---

## Codex-RS Architecture Summary

### Component Overview

```
┌─────────────────────────────────────────────────┐
│                 TUI Layer                        │
│  (codex-rs/tui/)                                │
│  App, ChatWidget, ApprovalOverlay               │
├─────────────────────────────────────────────────┤
│                 Core Layer                       │
│  (codex-rs/core/)                               │
│  ThreadManager, CodexThread, Codex              │
├─────────────────────────────────────────────────┤
│               Protocol Layer                     │
│  (codex-rs/protocol/)                           │
│  Op enum, EventMsg enum, Event struct           │
├─────────────────────────────────────────────────┤
│              App Server Layer                    │
│  (codex-rs/app-server/)                         │
│  MessageProcessor (JSON-RPC for external clients)│
└─────────────────────────────────────────────────┘
```

### Critical Architecture Fact

**TUI communicates directly with ThreadManager:**
```
TUI App → ThreadManager → CodexThread → Codex
```

**NOT through MessageProcessor:**
```
WRONG: TUI App → MessageProcessor → ThreadManager
```

MessageProcessor is **ONLY** for external JSON-RPC clients (VS Code extension, etc.).

### Component Responsibilities

| Component | Location | Responsibility |
|-----------|----------|----------------|
| App | `tui/app.rs` | Main event loop, UI coordination |
| ChatWidget | `tui/chatwidget.rs` | Message display |
| ApprovalOverlay | `tui/bottom_pane/approval_overlay.rs` | Approval UI queue |
| ThreadManager | `core/thread_manager.rs` | Thread lifecycle management |
| CodexThread | `core/codex_thread.rs` | Agent wrapper with channels |
| Codex | `core/codex.rs` | Agent implementation |
| MessageProcessor | `app-server/message_processor.rs` | JSON-RPC for external clients |

---

## Key Types Reference

### Op Enum (Input to Agent)

Operations submitted by user/client to the agent:

| Variant | Purpose |
|---------|---------|
| `UserTurn` | Submit user message |
| `ExecApproval` | Approve/deny command execution |
| `ApplyPatchApproval` | Approve/deny file patch |
| `Interrupt` | Abort current task |
| `Undo` | Undo last action |
| `RunUserShellCommand` | Execute shell command (! prefix) |

**Location**: `codex-rs/protocol/src/protocol.rs`

### EventMsg Enum (Output from Agent)

Events emitted by the agent:

| Variant | Purpose |
|---------|---------|
| `SessionConfigured` | Session ready |
| `TurnStarted` | Agent began processing |
| `TurnComplete` | Agent finished processing |
| `AgentMessage` | Text response |
| `ExecCommandBegin` | Command execution started |
| `ExecCommandEnd` | Command execution finished |
| `ExecApprovalRequest` | Needs approval for command |
| `ApplyPatchApprovalRequest` | Needs approval for patch |
| `Error` | Error occurred |
| `Warning` | Non-fatal warning |

**Location**: `codex-rs/protocol/src/protocol.rs`

### Event Struct

Wrapper for all events:

```rust
pub struct Event {
    pub id: String,    // Unique event ID
    pub msg: EventMsg, // The actual event
}
```

---

## Communication Patterns

### 1. Direct Channel Communication

TUI uses async channels directly with agent:
- `submit(Op)` - Send operations
- `recv()` - Receive events

### 2. Approval Queue

Approval requests are queued and processed one at a time:
```rust
struct ApprovalOverlay {
    current: Option<ApprovalRequest>,
    queue: Vec<ApprovalRequest>,
}
```

### 3. Event-Driven UI

Main loop polls both terminal and agent events:
```rust
loop {
    // Poll terminal events
    // Poll agent events (non-blocking)
    // Dispatch to handlers
    // Render
}
```

---

## Safety Patterns

### 1. Explicit Approval Gates

Commands requiring system access must be approved:
- `ExecApprovalRequest` emitted
- User approves/denies
- `ExecApproval` sent back

### 2. Policy Amendments

Users can update approval policies:
- "Always approve" for patterns
- "Always deny" for dangerous ops
- Persists for session

### 3. Undo Capability

`Op::Undo` allows reverting last action.

---

## Templates

### For LLM-Optimizing Other Projects

| Template | Location | Purpose |
|----------|----------|---------|
| Manual Template | `docs/templates/LLM-OPTIMIZATION-TEMPLATE.md` | Step-by-step guide |
| Agent Skill | `docs/templates/llm-project-optimization/SKILL.md` | Installable skill |

---

## Quality Standards

### Documentation Style

- Concise, no filler words
- Use tables for structured data
- Include source file references
- Link to GitHub for full source

### Diagram Requirements

- Include file paths in participant labels
- Validate with `render-diagrams.sh`
- Use consistent styling

### Cross-Reference Requirements

- Update `llms.txt` after any change
- Update `llms-full.txt` for significant changes
- Verify all links are valid

---

## Quality Checklist

Before completing any task:

- [ ] No implementation code created
- [ ] Mermaid diagrams validate
- [ ] Source file paths included
- [ ] GitHub links are valid
- [ ] `llms.txt` updated
- [ ] `llms-full.txt` updated (if needed)
- [ ] Consistent with existing style
- [ ] Tables used for mappings

---

## Resources

| Resource | URL |
|----------|-----|
| Codex-RS Source | https://github.com/openai/codex |
| Protocol Types | https://github.com/openai/codex/blob/main/codex-rs/protocol/src/protocol.rs |
| TUI Implementation | https://github.com/openai/codex/tree/main/codex-rs/tui |
| Core Implementation | https://github.com/openai/codex/tree/main/codex-rs/core |
| Mermaid Documentation | https://mermaid.js.org/ |
| llms.txt Standard | https://llmstxt.org/ |
