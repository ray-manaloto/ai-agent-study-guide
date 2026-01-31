# Implementation Patterns

> Reusable patterns for building AI coding agents, derived from Codex-RS

## Pattern 1: Typed Message Protocol

### Problem
Agent communication needs type safety and clear contracts.

### Solution
Define all messages as Rust enums with exhaustive variants.

```rust
// Operations (input)
pub enum Op {
    UserTurn { items: Vec<UserInput>, cwd: PathBuf },
    ExecApproval { id: String, decision: ReviewDecision },
    Interrupt,
    Undo,
}

// Events (output)
pub enum EventMsg {
    TurnStarted(TurnStartedEvent),
    TurnComplete(TurnCompleteEvent),
    ExecApprovalRequest(ExecApprovalRequestEvent),
    AgentMessage(AgentMessageEvent),
}
```

### Benefits
- Compile-time exhaustiveness checking
- Self-documenting API
- Easy serialization for external clients

---

## Pattern 2: Event-Driven UI Updates

### Problem
UI needs to react to async agent events without blocking.

### Solution
Poll events in main loop, dispatch to handlers.

```rust
loop {
    // Poll terminal events (keyboard, mouse)
    if let Some(key) = poll_terminal() {
        handle_key(key);
    }
    
    // Poll agent events (non-blocking)
    while let Some(event) = codex_thread.try_recv() {
        match event.msg {
            EventMsg::TurnStarted(_) => chat.on_turn_started(),
            EventMsg::AgentMessage(m) => chat.on_message(m),
            EventMsg::ExecApprovalRequest(r) => overlay.queue(r),
            // ...
        }
    }
    
    // Render
    terminal.draw(|f| render(f))?;
}
```

### Benefits
- Responsive UI during long agent operations
- Non-blocking event processing
- Clean separation of concerns

---

## Pattern 3: Approval Queue

### Problem
Multiple approval requests can arrive faster than user can respond.

### Solution
Queue requests, process one at a time.

```rust
struct ApprovalOverlay {
    current: Option<ApprovalRequest>,
    queue: Vec<ApprovalRequest>,
}

impl ApprovalOverlay {
    fn queue(&mut self, request: ApprovalRequest) {
        if self.current.is_none() {
            self.current = Some(request);
        } else {
            self.queue.push(request);
        }
    }
    
    fn complete(&mut self, decision: ReviewDecision) -> Op {
        let request = self.current.take().unwrap();
        self.current = self.queue.pop();
        Op::ExecApproval { id: request.id, decision }
    }
}
```

### Benefits
- Prevents UI overwhelm
- Ensures sequential decisions
- Maintains request order

---

## Pattern 4: Thread Wrapper

### Problem
Agent needs async communication with clean API.

### Solution
Wrap agent in a thread with channel-based interface.

```rust
pub struct CodexThread {
    op_tx: UnboundedSender<Op>,
    event_rx: UnboundedReceiver<Event>,
    handle: JoinHandle<()>,
}

impl CodexThread {
    pub fn submit(&self, op: Op) {
        self.op_tx.send(op).unwrap();
    }
    
    pub async fn recv(&mut self) -> Option<Event> {
        self.event_rx.recv().await
    }
}
```

### Benefits
- Clean async interface
- Isolation of agent execution
- Easy testing with mock channels

---

## Pattern 5: Layer Separation

### Problem
Mixing UI, business logic, and protocol leads to coupling.

### Solution
Strict layer separation with clear dependencies.

```
┌─────────────────────────────┐
│  TUI Layer (presentation)   │ ← Only knows about App, widgets
├─────────────────────────────┤
│  Core Layer (business)      │ ← Only knows about agents, threads
├─────────────────────────────┤
│  Protocol Layer (contract)  │ ← Shared types, no logic
└─────────────────────────────┘
```

### Dependency Rules
- TUI depends on Core and Protocol
- Core depends on Protocol
- Protocol depends on nothing

### Benefits
- Testable layers
- Replaceable UI (TUI → GUI → Web)
- Clear contracts

---

## Pattern 6: External Client Adapter

### Problem
External clients (IDE extensions) need different protocol than TUI.

### Solution
Separate adapter layer for external clients.

```rust
// MessageProcessor handles JSON-RPC
impl MessageProcessor {
    async fn handle(&self, request: JsonRpcRequest) -> JsonRpcResponse {
        match request.method {
            "thread/start" => self.handle_thread_start(request.params),
            "turn/start" => self.handle_turn_start(request.params),
            // ...
        }
    }
}

// Converts to internal types and forwards to ThreadManager
impl CodexMessageProcessor {
    fn handle_turn_start(&self, params: TurnStartParams) -> Result<()> {
        let op = Op::UserTurn { 
            items: params.items.into(),
            cwd: params.cwd,
        };
        self.thread.submit(op);
        Ok(())
    }
}
```

### Benefits
- TUI stays simple (direct channel access)
- External clients get appropriate protocol
- Single agent implementation serves all clients

---

## Anti-Patterns to Avoid

### 1. Mixing Layers
Don't import UI types in Core layer. Keep Protocol layer type-only.

### 2. Blocking on Approval
Don't block agent thread waiting for approval. Emit request, continue polling.

### 3. Shared Mutable State
Don't share mutable state between UI and agent. Use channels.

### 4. Implicit Protocols
Don't use untyped JSON/strings for internal communication. Use enums.
