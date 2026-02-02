# Core Concepts

> Comprehensive reference guide for AI agent architecture patterns derived from OpenAI Codex-RS

---

## Table of Contents

1. [Agent Communication Patterns](#agent-communication-patterns)
2. [Safety Patterns](#safety-patterns)
3. [Thread Management](#thread-management)
4. [Event-Driven Architecture](#event-driven-architecture)
5. [External Client Support](#external-client-support)
6. [State Management](#state-management)
7. [Error Handling](#error-handling)
8. [Performance Patterns](#performance-patterns)
9. [Security Patterns](#security-patterns)
10. [Testing Patterns](#testing-patterns)

---

## Agent Communication Patterns

### 1. Direct Channel Communication

The TUI communicates with the agent via direct async channels, not through an intermediary service layer.

```
App (TUI) ──submit(Op)──> CodexThread ──> Codex (Agent)
    <──────recv()─────── Event stream <──
```

**Why this matters**: Reduces latency, simplifies debugging, maintains type safety.

**Implementation Details**:
- Channels are unbounded to prevent backpressure blocking
- Events are immutable once emitted
- Operations are processed sequentially per thread

### 2. Operation/Event Model

All communication follows a request/response pattern with typed enums:

| Direction | Type | Examples |
|-----------|------|----------|
| User → Agent | `Op` enum | UserTurn, ExecApproval, Interrupt |
| Agent → User | `EventMsg` enum | TurnStarted, TurnComplete, ExecApprovalRequest |

**Benefits**:
- Type safety at compile time
- Exhaustive pattern matching
- Clear API contract
- Easy serialization

### 3. Queue-Based Approval

Approval requests are queued and processed one at a time:

```rust
struct ApprovalOverlay {
    current_request: Option<ApprovalRequest>,
    queue: Vec<ApprovalRequest>,
}
```

**Why this matters**: Prevents UI overwhelm, ensures sequential user decisions.

**Queue Behavior**:
1. New requests added to queue tail
2. Current request displayed to user
3. User decision processed
4. Next request dequeued
5. Repeat until queue empty

### 4. Message Framing

Messages are delimited for reliable transmission:

| Method | Use Case |
|--------|----------|
| Length-prefix | Binary protocols |
| Newline-delimited | Text protocols (JSON-RPC) |
| WebSocket frames | Web clients |

### 5. Backpressure Handling

When consumers are slow:

| Strategy | Implementation |
|----------|----------------|
| Unbounded queue | May grow indefinitely |
| Bounded queue | Blocks sender when full |
| Drop oldest | Loses stale messages |
| Rate limiting | Throttles sender |

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

**Approval Types**:
| Type | Trigger |
|------|---------|
| ExecApprovalRequest | Shell command execution |
| ApplyPatchApprovalRequest | File modifications |
| NetworkApprovalRequest | External API calls |

### 2. Policy Amendments

Users can update approval policies during the session:

- "Always approve" for specific command patterns
- "Always deny" for dangerous operations
- Policies persist for session duration

**Policy Structure**:
```rust
enum PolicyRule {
    AlwaysApprove(Pattern),
    AlwaysDeny(Pattern),
    AlwaysAsk,
}
```

### 3. Undo Capability

The `Op::Undo` operation allows reverting the last action, providing a safety net.

**Undo Stack**:
- Each reversible action pushed to stack
- Undo pops and reverses top action
- Limited stack depth prevents memory issues
- Some actions marked as non-undoable

### 4. Sandboxing

Agent code execution is isolated:

| Level | Isolation |
|-------|-----------|
| Process | Separate process space |
| Container | Filesystem isolation |
| VM | Full virtualization |
| None | Direct execution (risky) |

### 5. Input Validation

All user input is validated before processing:

```rust
fn validate_op(op: &Op) -> Result<(), ValidationError> {
    match op {
        Op::UserTurn { message } => validate_message(message),
        Op::ExecApproval { decision } => validate_decision(decision),
        // ...
    }
}
```

### 6. Rate Limiting

Prevent abuse through rate limiting:

| Resource | Limit |
|----------|-------|
| LLM API calls | Per minute |
| Tool executions | Per turn |
| File operations | Per session |

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

### Thread States

| State | Description | Allowed Operations |
|-------|-------------|-------------------|
| Created | Thread initialized | Start |
| Ready | Waiting for input | UserTurn, Configure |
| Processing | Working on turn | Interrupt |
| WaitingApproval | Blocked on approval | ExecApproval |
| Error | Recoverable error | Retry, Abort |
| Terminated | Thread finished | None |

### Multi-Thread Support

ThreadManager can manage multiple concurrent agent threads:
- Each thread has independent state
- Threads can be switched via UI
- Resources are isolated per thread

**Thread Isolation**:
```rust
struct ThreadManager {
    threads: HashMap<ThreadId, CodexThread>,
    active_thread: Option<ThreadId>,
}
```

### Thread Configuration

| Option | Purpose |
|--------|---------|
| `model` | LLM model to use |
| `system_prompt` | Initial instructions |
| `tools` | Available tool set |
| `timeout` | Maximum turn duration |
| `max_tokens` | Output token limit |

### Thread Cleanup

When a thread terminates:
1. Pending operations cancelled
2. Resources released
3. Event listeners removed
4. History optionally persisted

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
| Progress | ProgressUpdate, TokenCount |

### Event Flow

1. Agent emits `Event { id, msg }` to channel
2. TUI polls channel in event loop
3. TUI dispatches to appropriate handler
4. Handler updates UI state
5. UI re-renders

**Event Loop Pattern**:
```rust
loop {
    select! {
        event = codex_thread.recv() => handle_event(event),
        input = terminal.read() => handle_input(input),
        _ = tick.tick() => handle_tick(),
    }
}
```

### Event Ordering

Events are guaranteed to be:
- Ordered per source (thread)
- Uniquely identified
- Idempotent when replayed

### Event Persistence

For recovery and debugging:

| Storage | Use Case |
|---------|----------|
| Memory | Current session |
| Disk | Session recovery |
| Database | Long-term analytics |

### Event Replay

Events can be replayed for:
- Debugging issues
- Restoring state
- Testing scenarios
- Auditing actions

---

## External Client Support

### JSON-RPC Layer

For external clients (VS Code, IDEs):

```
External Client → JSON-RPC → MessageProcessor → ThreadManager
              ← Notifications ← Event stream ←
```

**Key distinction**: TUI bypasses this layer entirely.

### Protocol Methods

| Method | Direction | Purpose |
|--------|-----------|---------|
| `initialize` | Request | Setup session |
| `submit_op` | Request | Send operation |
| `event` | Notification | Receive events |
| `shutdown` | Request | Clean termination |

### Client Authentication

| Method | Security Level |
|--------|----------------|
| API Key | Basic |
| OAuth | Standard |
| mTLS | High |
| None (local) | Development only |

### WebSocket Support

For real-time web clients:

```javascript
const ws = new WebSocket('ws://localhost:8080');
ws.onmessage = (e) => handleEvent(JSON.parse(e.data));
ws.send(JSON.stringify({ method: 'submit_op', params: op }));
```

---

## State Management

### State Types

| Type | Scope | Persistence |
|------|-------|-------------|
| UI State | Component | Memory |
| Session State | Thread | Memory/Disk |
| Application State | Global | Config file |
| User State | User | Database |

### State Transitions

```
Idle → UserTurn → Processing → TurnComplete → Idle
                          ↓
                  WaitingApproval → Approved/Denied
                          ↓
                      Processing
```

### State Synchronization

For multi-client scenarios:

| Pattern | Use Case |
|---------|----------|
| Single source of truth | Simple apps |
| Event sourcing | Audit requirements |
| CRDT | Distributed systems |
| Optimistic updates | Low latency |

### State Recovery

After crash or disconnect:

1. Load last checkpoint
2. Replay events since checkpoint
3. Reconcile any conflicts
4. Resume operation

---

## Error Handling

### Error Categories

| Category | Examples | Recovery |
|----------|----------|----------|
| Transient | Network timeout | Retry |
| Permanent | Invalid input | User feedback |
| Fatal | Out of memory | Restart |
| Logical | Invalid state | Bug fix |

### Retry Strategies

| Strategy | Pattern |
|----------|---------|
| Immediate | Retry once |
| Fixed delay | Wait N seconds |
| Exponential backoff | Double delay each time |
| Jitter | Add randomness |

```rust
fn retry_with_backoff<T, E>(
    operation: impl Fn() -> Result<T, E>,
    max_attempts: u32,
) -> Result<T, E> {
    let mut delay = Duration::from_millis(100);
    for attempt in 0..max_attempts {
        match operation() {
            Ok(v) => return Ok(v),
            Err(e) if attempt < max_attempts - 1 => {
                sleep(delay);
                delay *= 2;
            }
            Err(e) => return Err(e),
        }
    }
}
```

### Circuit Breaker

Prevent cascade failures:

| State | Behavior |
|-------|----------|
| Closed | Requests pass through |
| Open | Requests fail immediately |
| Half-Open | Test with limited requests |

### Error Reporting

| Level | Destination |
|-------|-------------|
| Debug | Log file |
| Info | Structured logs |
| Warning | User notification |
| Error | User + metrics |
| Fatal | User + alert |

---

## Performance Patterns

### Caching

| Level | What | Duration |
|-------|------|----------|
| Memory | Embeddings | Session |
| Disk | Model responses | Hours |
| CDN | Static assets | Days |

### Batching

Combine multiple operations:

```rust
// Instead of N individual calls
for item in items {
    process(item).await;
}

// Batch into single call
process_batch(items).await;
```

### Streaming

Process data incrementally:

| Pattern | Use Case |
|---------|----------|
| Token streaming | LLM responses |
| Chunked transfer | Large files |
| Server-sent events | Real-time updates |

### Connection Pooling

Reuse expensive connections:

| Resource | Pool Size | Timeout |
|----------|-----------|---------|
| HTTP | 10 | 30s |
| Database | 20 | 60s |
| WebSocket | 5 | 300s |

### Lazy Loading

Defer work until needed:

```rust
lazy_static! {
    static ref EXPENSIVE_RESOURCE: Resource = load_resource();
}
```

---

## Security Patterns

### Principle of Least Privilege

Grant minimum necessary permissions:

| Component | Permissions |
|-----------|-------------|
| UI | Read config, write state |
| Agent | Execute tools |
| Tools | Specific resources only |

### Defense in Depth

Multiple security layers:

1. Input validation
2. Authentication
3. Authorization
4. Sandboxing
5. Monitoring
6. Audit logging

### Secrets Management

| Method | Security |
|--------|----------|
| Environment variables | Basic |
| Secret manager | Recommended |
| Hardware security module | High security |

### Audit Logging

Record security-relevant events:

```rust
struct AuditLog {
    timestamp: DateTime<Utc>,
    actor: String,
    action: String,
    resource: String,
    outcome: Outcome,
}
```

---

## Testing Patterns

### Test Levels

| Level | Scope | Speed |
|-------|-------|-------|
| Unit | Single function | Fast |
| Integration | Multiple components | Medium |
| End-to-end | Full system | Slow |

### Mocking Strategies

| Target | Mock Type |
|--------|-----------|
| LLM API | Recorded responses |
| File system | In-memory |
| Time | Controlled clock |
| Network | Local server |

### Property-Based Testing

Test with generated inputs:

```rust
#[quickcheck]
fn op_roundtrip(op: Op) -> bool {
    let serialized = serde_json::to_string(&op).unwrap();
    let deserialized: Op = serde_json::from_str(&serialized).unwrap();
    op == deserialized
}
```

### Snapshot Testing

Compare against known-good output:

```rust
#[test]
fn test_render() {
    let output = render_widget(&widget);
    insta::assert_snapshot!(output);
}
```

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

---

## Summary

These patterns form the foundation of production AI agent systems:

1. **Communication**: Direct channels, typed messages, queue-based approval
2. **Safety**: Explicit gates, policy amendments, undo capability
3. **Threads**: Lifecycle management, isolation, configuration
4. **Events**: Typed events, ordered delivery, replay support
5. **External**: JSON-RPC, WebSocket, authentication
6. **State**: Typed state, transitions, recovery
7. **Errors**: Categories, retry strategies, circuit breakers
8. **Performance**: Caching, batching, streaming
9. **Security**: Least privilege, defense in depth, audit logging
10. **Testing**: Multiple levels, mocking, property testing

---

## Related Documentation

| File | Content |
|------|---------|
| `GLOSSARY.md` | Term definitions |
| `PATTERNS.md` | Code patterns |
| `WORKFLOWS.md` | Task workflows |
| `architecture-diagram.md` | Visual diagrams |
