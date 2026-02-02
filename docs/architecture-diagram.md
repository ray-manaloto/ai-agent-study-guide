# Codex-RS Architecture Sequence Diagram

> **Validated against**: [openai/codex](https://github.com/openai/codex) codex-rs implementation

## Overview

This document describes the communication flow between the core components of the Codex TUI application.

| Component | Location | Key Structs | Responsibility |
|-----------|----------|-------------|----------------|
| **TUI Layer** | `codex-rs/tui/` | `App`, `ChatWidget`, `ChatComposer`, `ApprovalOverlay` | User interface, event handling, rendering |
| **Core Agent** | `codex-rs/core/` | `ThreadManager`, `CodexThread`, `Codex` | Agent execution, thread lifecycle, LLM interaction |
| **Protocol** | `codex-rs/protocol/` | `Op`, `EventMsg`, `Event` | Message types, operations, events |
| **App Server** | `codex-rs/app-server/` | `MessageProcessor`, `CodexMessageProcessor` | JSON-RPC for external clients (VS Code, etc.) |

---

## Architecture Diagram

```mermaid
flowchart TB
    subgraph TUI["TUI Layer (codex-rs/tui)"]
        App["App struct"]
        ChatWidget["ChatWidget"]
        ChatComposer["ChatComposer"]
        ApprovalOverlay["ApprovalOverlay"]
        BottomPane["BottomPane"]
        AppEventTx["AppEventSender"]
    end

    subgraph Core["Core Layer (codex-rs/core)"]
        ThreadManager["ThreadManager"]
        CodexThread["CodexThread"]
        Codex["Codex"]
        Session["Session"]
    end

    subgraph Protocol["Protocol Layer (codex-rs/protocol)"]
        Op["Op enum"]
        EventMsg["EventMsg enum"]
        Event["Event { id, msg }"]
    end

    subgraph External["External Clients"]
        VSCode["VS Code Extension"]
        AppServer["MessageProcessor<br/>(JSON-RPC)"]
    end

    ChatComposer -->|user input| BottomPane
    BottomPane --> App
    App -->|"submit(Op)"| ThreadManager
    ThreadManager --> CodexThread
    CodexThread --> Codex
    Codex --> Session
    Session -->|emit| Event
    Event --> CodexThread
    CodexThread -->|"recv()"| App
    App -->|AppEvent| AppEventTx
    AppEventTx --> ChatWidget
    ChatWidget --> ApprovalOverlay

    VSCode -->|JSON-RPC| AppServer
    AppServer --> ThreadManager

    click App "#tui-components-from-codex-rstui" "View App struct details"
    click ChatWidget "#chatwidget" "View ChatWidget handlers"
    click ChatComposer "#file-locations" "View ChatComposer location"
    click ApprovalOverlay "#approvaloverlay" "View ApprovalOverlay struct"
    click ThreadManager "https://github.com/openai/codex/blob/main/codex-rs/core/src/thread_manager.rs" "View source"
    click CodexThread "https://github.com/openai/codex/blob/main/codex-rs/core/src/codex_thread.rs" "View source"
    click Codex "https://github.com/openai/codex/blob/main/codex-rs/core/src/codex.rs" "View source"
    click Op "#op-enum-operations-submitted-to-agent" "View Op enum variants"
    click EventMsg "#eventmsg-enum-events-emitted-by-agent" "View EventMsg variants"
    click Event "#event-wrapper" "View Event struct"
    click AppServer "#external-client-flow-app-server" "View App Server flow"
```

---

## TUI ↔ Core Communication Flow

```mermaid
sequenceDiagram
    participant User
    participant App as App<br/>(tui/app.rs)
    participant TM as ThreadManager<br/>(core/thread_manager.rs)
    participant CT as CodexThread<br/>(core/codex_thread.rs)
    participant Codex as Codex<br/>(core/codex.rs)

    %% ============ INITIALIZATION ============
    rect rgb(240, 248, 255)
        Note over User,Codex: Thread Initialization
        User->>App: Launch TUI
        App->>TM: start_thread(config)
        activate TM
        TM->>CT: create CodexThread
        activate CT
        CT->>Codex: spawn Codex agent
        activate Codex
        Codex-->>CT: ready
        CT-->>TM: NewThread
        deactivate Codex
        deactivate CT
        TM-->>App: Arc of CodexThread
        deactivate TM
        App->>App: Store server reference
    end

    %% ============ EVENT LOOP ============
    loop Main Event Loop (App::run)
        Note over App: Poll crossterm events + codex events

        %% --- User Input ---
        rect rgb(255, 250, 240)
            Note over User,Codex: User Input Flow
            User->>App: Type in ChatComposer
            App->>App: handle_key_event()
            User->>App: Press Enter
            App->>CT: submit(Op::UserTurn { items, ... })
            activate CT
            CT->>Codex: process user turn
            activate Codex
        end

        %% --- Agent Processing ---
        rect rgb(240, 255, 240)
            Note over User,Codex: Agent Processing
            Codex->>Codex: Call LLM API
            Codex->>CT: emit Event { id, msg: TurnStarted }
            CT-->>App: recv() -> Event
            App->>App: Update ChatWidget
            Codex->>Codex: Execute tools
            Codex->>CT: emit Event { id, msg: ExecCommandBegin }
            CT-->>App: recv() -> Event
        end

        %% --- Approval Flow ---
        rect rgb(255, 245, 238)
            Note over User,Codex: Approval Required
            Codex->>CT: emit Event { id, msg: ExecApprovalRequest }
            CT-->>App: recv() -> Event
            App->>App: Show ApprovalOverlay
            User->>App: Approve/Deny
            App->>CT: submit(Op::ExecApproval { decision })
            CT->>Codex: continue/abort
        end

        %% --- Turn Complete ---
        rect rgb(245, 245, 255)
            Note over User,Codex: Turn Complete
            Codex->>CT: emit Event { id, msg: TurnComplete }
            deactivate Codex
            CT-->>App: recv() -> Event
            deactivate CT
            App->>App: Update ChatWidget with final response
        end
    end
```

---

## Key Types (from codex-rs/protocol)

### Op Enum (Operations submitted to agent)

```rust
// codex-rs/protocol/src/protocol.rs
pub enum Op {
    /// Abort current task
    Interrupt,
    
    /// User submits a message/turn
    UserTurn {
        items: Vec<UserInput>,
        cwd: PathBuf,
        model: Option<String>,
        // ...
    },
    
    /// Response to exec approval request
    ExecApproval {
        id: String,
        decision: ReviewDecision,
    },
    
    /// Response to patch approval request  
    ApplyPatchApproval {
        id: String,
        decision: ReviewDecision,
    },
    
    /// Undo last action
    Undo,
    
    /// Run user shell command (! prefix)
    RunUserShellCommand { command: String },
    
    // ... more variants
}
```

### EventMsg Enum (Events emitted by agent)

```rust
// codex-rs/protocol/src/protocol.rs
pub enum EventMsg {
    /// Error during execution
    Error(ErrorEvent),
    
    /// Warning (non-fatal)
    Warning(WarningEvent),
    
    /// Session configured (first event)
    SessionConfigured(SessionConfiguredEvent),
    
    /// Turn started
    TurnStarted(TurnStartedEvent),
    
    /// Turn completed
    TurnComplete(TurnCompleteEvent),
    
    /// Agent message (text response)
    AgentMessage(AgentMessageEvent),
    
    /// Command execution started
    ExecCommandBegin(ExecCommandBeginEvent),
    
    /// Command execution ended
    ExecCommandEnd(ExecCommandEndEvent),
    
    /// Approval request for command
    ExecApprovalRequest(ExecApprovalRequestEvent),
    
    /// Approval request for file patch
    ApplyPatchApprovalRequest(ApplyPatchApprovalRequestEvent),
    
    /// Request user input
    RequestUserInput(RequestUserInputEvent),
    
    // ... more variants
}
```

### Event Wrapper

```rust
// codex-rs/protocol/src/protocol.rs
pub struct Event {
    pub id: String,
    pub msg: EventMsg,
}
```

---

## TUI Components (from codex-rs/tui)

### App Struct

```rust
// codex-rs/tui/src/app.rs
pub(crate) struct App {
    pub(crate) server: Arc<ThreadManager>,
    pub(crate) otel_manager: OtelManager,
    pub(crate) app_event_tx: AppEventSender,
    // ...
}
```

### AppEvent Enum

```rust
// codex-rs/tui/src/app_event.rs
pub(crate) enum AppEvent {
    /// Event from CodexThread
    CodexEvent(Event),
    
    /// Open agent picker
    OpenAgentPicker,
    
    /// Switch to different thread
    SelectAgentThread(ThreadId),
    
    /// File search results
    FileSearchResults(Vec<FileMatch>),
    
    // ... more variants
}
```

### ChatWidget

```rust
// codex-rs/tui/src/chatwidget.rs
// Handles:
// - on_exec_approval_request()
// - on_apply_patch_approval_request()
// - on_turn_started()
// - on_turn_complete()
// - on_agent_message()
```

### ApprovalOverlay

```rust
// codex-rs/tui/src/bottom_pane/approval_overlay.rs
pub(crate) struct ApprovalOverlay {
    current_request: Option<ApprovalRequest>,
    current_variant: Option<ApprovalVariant>,
    queue: Vec<ApprovalRequest>,
    app_event_tx: AppEventSender,
    list: ListSelectionView,
}
```

---

## Approval Flow Detail

```mermaid
sequenceDiagram
    participant Codex as Codex Agent
    participant CT as CodexThread
    participant App as TUI App
    participant Overlay as ApprovalOverlay
    participant User

    Codex->>CT: emit ExecApprovalRequest<br/>{call_id, turn_id, command, cwd}
    CT-->>App: recv() -> Event
    App->>App: chatwidget.on_exec_approval_request()
    App->>Overlay: queue ApprovalRequest
    Overlay->>Overlay: Render command for review
    Overlay->>User: Display command + options

    alt Approved
        User->>Overlay: Press 'y' or select Approve
        Overlay->>App: AppEvent with approval
        App->>CT: submit(Op::ExecApproval { decision: Approved })
        CT->>Codex: Execute command
        Codex->>CT: emit ExecCommandBegin
        Codex->>CT: emit ExecCommandEnd { exit_code, output }
    else Denied
        User->>Overlay: Press 'n' or select Deny
        Overlay->>App: AppEvent with denial
        App->>CT: submit(Op::ExecApproval { decision: Denied })
        CT->>Codex: Skip command
    else Always Approve (update policy)
        User->>Overlay: Select "Always approve"
        Overlay->>App: AppEvent with policy amendment
        App->>CT: submit(Op::ExecApproval { decision: Approved, amendment })
        CT->>Codex: Execute + update policy
    end
```

---

## State Machine

```mermaid
stateDiagram-v2
    [*] --> Idle: App created

    Idle --> Initializing: start_thread
    Initializing --> Ready: SessionConfigured event

    Ready --> ProcessingTurn: UserTurn submitted
    ProcessingTurn --> WaitingApproval: ExecApprovalRequest
    ProcessingTurn --> Ready: TurnComplete

    WaitingApproval --> ProcessingTurn: ExecApproval sent
    
    Ready --> Resuming: resume_thread
    Resuming --> Ready: SessionConfigured

    Ready --> [*]: Exit
```

---

## External Client Flow (App Server)

The App Server (`codex-rs/app-server`) provides JSON-RPC for external clients like VS Code:

```mermaid
sequenceDiagram
    participant VSCode as VS Code Extension
    participant MP as MessageProcessor
    participant CMP as CodexMessageProcessor
    participant TM as ThreadManager
    participant CT as CodexThread

    VSCode->>MP: JSON-RPC: thread/start
    MP->>CMP: handle_thread_start()
    CMP->>TM: start_thread(config)
    TM->>CT: create thread
    CT-->>TM: NewThread
    TM-->>CMP: CodexThread reference
    CMP-->>MP: spawn event forwarder
    MP-->>VSCode: ThreadStartResponse

    loop Event Streaming
        CT-->>CMP: Event
        CMP->>CMP: Convert to notification
        CMP-->>MP: ServerNotification
        MP-->>VSCode: JSON-RPC notification
    end

    VSCode->>MP: JSON-RPC: turn/start
    MP->>CMP: handle_turn_start()
    CMP->>CT: submit(Op::UserTurn)
    
    Note over VSCode,CT: Same approval flow as TUI
```

---

## File Locations

| Component | File Path |
|-----------|-----------|
| App struct | `codex-rs/tui/src/app.rs` |
| ChatWidget | `codex-rs/tui/src/chatwidget.rs` |
| ChatComposer | `codex-rs/tui/src/bottom_pane/chat_composer.rs` |
| ApprovalOverlay | `codex-rs/tui/src/bottom_pane/approval_overlay.rs` |
| AppEvent | `codex-rs/tui/src/app_event.rs` |
| ThreadManager | `codex-rs/core/src/thread_manager.rs` |
| CodexThread | `codex-rs/core/src/codex_thread.rs` |
| Codex | `codex-rs/core/src/codex.rs` |
| Op enum | `codex-rs/protocol/src/protocol.rs` |
| EventMsg enum | `codex-rs/protocol/src/protocol.rs` |
| MessageProcessor | `codex-rs/app-server/src/message_processor.rs` |
| CodexMessageProcessor | `codex-rs/app-server/src/codex_message_processor.rs` |

---

## Key Insights

1. **TUI uses ThreadManager directly** - The TUI doesn't go through MessageProcessor. It holds `Arc<ThreadManager>` and communicates via `submit(Op)` and `recv()` on CodexThread.

2. **MessageProcessor is for external clients** - JSON-RPC interface for VS Code extension and other clients, not the TUI.

3. **Event-driven architecture** - All communication is async via channels:
   - `UnboundedSender<Op>` for submitting operations
   - `Event` stream for receiving agent events

4. **Approval is queue-based** - ApprovalOverlay maintains a queue of pending approval requests, processing them one at a time.

5. **CodexThread wraps Codex** - The actual agent logic lives in `Codex`, which manages sessions, LLM calls, and tool execution.
