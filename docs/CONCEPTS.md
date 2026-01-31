# Core Concepts

> Reference guide for AI agent architecture patterns derived from OpenAI Codex-RS

## Agent Communication Patterns

### 1. Direct Channel Communication

The TUI communicates with the agent via direct async channels, not through an intermediary service layer.

```
App (TUI) ──submit(Op)──> CodexThread ──> Codex (Agent)
    <──────recv()─────── Event stream <──
```

**Why this matters**: Reduces latency, simplifies debugging, maintains type safety.

### 2. Operation/Event Model

All communication follows a request/response pattern with typed enums:

| Direction | Type | Examples |
|-----------|------|----------|
| User → Agent | `Op` enum | UserTurn, ExecApproval, Interrupt |
| Agent → User | `EventMsg` enum | TurnStarted, TurnComplete, ExecApprovalRequest |

### 3. Queue-Based Approval

Approval requests are queued and processed one at a time:

```rust
struct ApprovalOverlay {
    current_request: Option<ApprovalRequest>,
    queue: Vec<ApprovalRequest>,
}
```

**Why this matters**: Prevents UI overwhelm, ensures sequential user decisions.

---

## Safety Patterns

### 1. Explicit Approval Gates

Commands requiring system access must be explicitly approved:

```
Agent wants to run: rm -rf ./temp
  → ExecApprovalRequest emitted
  → UI shows approval overlay
  → User approves/denies
  → ExecApproval sent back
  → Agent proceeds or aborts
```

### 2. Policy Amendments

Users can update approval policies during the session:

- "Always approve" for specific command patterns
- "Always deny" for dangerous operations
- Policies persist for session duration

### 3. Undo Capability

The `Op::Undo` operation allows reverting the last action, providing a safety net.

---

## Thread Management

### Thread Lifecycle

```
start_thread(config) → NewThread event → Ready state
                    ↓
              Session active
                    ↓
              ProcessingTurn ←→ WaitingApproval
                    ↓
                  Exit
```

### Multi-Thread Support

ThreadManager can manage multiple concurrent agent threads:
- Each thread has independent state
- Threads can be switched via UI
- Resources are isolated per thread

---

## Event-Driven Architecture

### Event Types

| Category | Events |
|----------|--------|
| Lifecycle | SessionConfigured, TurnStarted, TurnComplete |
| Execution | ExecCommandBegin, ExecCommandEnd |
| Approval | ExecApprovalRequest, ApplyPatchApprovalRequest |
| Communication | AgentMessage, Error, Warning |
| Input | RequestUserInput |

### Event Flow

1. Agent emits `Event { id, msg }` to channel
2. TUI polls channel in event loop
3. TUI dispatches to appropriate handler
4. Handler updates UI state
5. UI re-renders

---

## External Client Support

### JSON-RPC Layer

For external clients (VS Code, IDEs):

```
External Client → JSON-RPC → MessageProcessor → ThreadManager
              ← Notifications ← Event stream ←
```

**Key distinction**: TUI bypasses this layer entirely.

---

## Key Implementation Files

| Concept | File |
|---------|------|
| Op enum | `codex-rs/protocol/src/protocol.rs` |
| EventMsg enum | `codex-rs/protocol/src/protocol.rs` |
| Event handling | `codex-rs/tui/src/app.rs` |
| Thread management | `codex-rs/core/src/thread_manager.rs` |
| Approval UI | `codex-rs/tui/src/bottom_pane/approval_overlay.rs` |
| Agent logic | `codex-rs/core/src/codex.rs` |
