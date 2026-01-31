# Glossary

> Definitions of key terms used in AI agent architecture

## Core Terms

### Agent
An AI system that can perceive its environment, make decisions, and take actions autonomously. In Codex-RS, the `Codex` struct is the agent.

### Codex
The core agent implementation in Codex-RS. Manages LLM API calls, tool execution, and session state.

### CodexThread
A wrapper around the Codex agent that provides channel-based communication. Exposes `submit(Op)` and `recv()` methods.

### Event
A message emitted by the agent to communicate state changes. Wrapped in `Event { id, msg }` struct.

### EventMsg
An enum of all possible events the agent can emit: TurnStarted, TurnComplete, AgentMessage, ExecApprovalRequest, etc.

### Op (Operation)
An enum of all possible operations that can be submitted to the agent: UserTurn, ExecApproval, Interrupt, Undo, etc.

### ThreadManager
Manages the lifecycle of CodexThread instances. Handles thread creation, startup, and shutdown.

---

## UI Terms

### App
The main TUI application struct. Holds references to ThreadManager and manages the event loop.

### ApprovalOverlay
A UI component that displays pending approval requests and captures user decisions.

### ChatWidget
The main chat display component. Shows conversation history, agent messages, and status.

### ChatComposer
The input component where users type messages.

---

## Communication Terms

### Channel
An async communication primitive for message passing between components. Codex-RS uses unbounded channels.

### JSON-RPC
A remote procedure call protocol using JSON. Used by MessageProcessor for external clients.

### MessageProcessor
The JSON-RPC handler for external clients like VS Code. NOT used by the TUI.

### Submit
The method to send an Op to the agent: `codex_thread.submit(op)`.

### Recv
The method to receive the next Event from the agent: `codex_thread.recv()`.

---

## Session Terms

### Session
A conversation context with the agent. Contains history, configuration, and state.

### Turn
A single exchange: user input → agent processing → agent response.

### TurnStarted
Event emitted when the agent begins processing a user turn.

### TurnComplete
Event emitted when the agent finishes processing and is ready for next input.

---

## Approval Terms

### ExecApprovalRequest
Event requesting user approval before executing a command.

### ApplyPatchApprovalRequest
Event requesting user approval before applying file changes.

### ReviewDecision
The user's response: Approved, Denied, or Approved with policy amendment.

### Policy Amendment
A rule update that affects future approval decisions (e.g., "always approve git commands").

---

## Architecture Terms

### TUI (Terminal User Interface)
The terminal-based graphical interface. Built with Ratatui in Codex-RS.

### Core Layer
The agent execution layer containing ThreadManager, CodexThread, and Codex.

### Protocol Layer
The message type definitions layer containing Op, EventMsg, and Event.

### App Server Layer
The JSON-RPC layer for external client communication.
