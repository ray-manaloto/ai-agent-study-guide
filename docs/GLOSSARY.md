# Glossary

> Comprehensive definitions of key terms used in AI agent architecture

---

## Core Terms

### Agent
An AI system that can perceive its environment, make decisions, and take actions autonomously. In Codex-RS, the `Codex` struct is the agent.

**Characteristics**:
- Autonomous decision-making
- Environment perception via tools
- Goal-oriented behavior
- Iterative refinement

### Codex
The core agent implementation in Codex-RS. Manages LLM API calls, tool execution, and session state.

**Responsibilities**:
- LLM API orchestration
- Tool invocation
- State management
- Error recovery

### CodexThread
A wrapper around the Codex agent that provides channel-based communication. Exposes `submit(Op)` and `recv()` methods.

**Key Methods**:
| Method | Purpose |
|--------|---------|
| `submit(Op)` | Send operation to agent |
| `recv()` | Receive next event |
| `is_alive()` | Check thread health |

### Event
A message emitted by the agent to communicate state changes. Wrapped in `Event { id, msg }` struct.

**Structure**:
```rust
struct Event {
    id: EventId,
    msg: EventMsg,
}
```

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

### Focus
The currently active UI component that receives keyboard input.

### Viewport
The visible portion of scrollable content in a terminal interface.

### Widget
A reusable UI component in the TUI framework (Ratatui).

---

## Communication Terms

### Channel
An async communication primitive for message passing between components. Codex-RS uses unbounded channels.

**Types**:
| Type | Characteristics |
|------|----------------|
| Bounded | Has capacity limit, backpressure |
| Unbounded | No limit, may grow unbounded |

### JSON-RPC
A remote procedure call protocol using JSON. Used by MessageProcessor for external clients.

**Structure**:
```json
{
  "jsonrpc": "2.0",
  "method": "method_name",
  "params": {},
  "id": 1
}
```

### MessageProcessor
The JSON-RPC handler for external clients like VS Code. NOT used by the TUI.

### Submit
The method to send an Op to the agent: `codex_thread.submit(op)`.

### Recv
The method to receive the next Event from the agent: `codex_thread.recv()`.

### Notification
A one-way message that doesn't expect a response.

### Request
A message that expects a response.

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

### Context Window
The maximum number of tokens the LLM can process in a single request.

### History
The accumulated conversation messages in a session.

### System Prompt
Initial instructions provided to the LLM that define its behavior and constraints.

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

### Approval Queue
A FIFO queue of pending approval requests awaiting user decision.

### Auto-Approve
A policy setting that automatically approves certain operations without user interaction.

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

### Presentation Layer
The UI/display layer that renders state to the user.

### Business Layer
The core logic layer that processes operations and manages state.

---

## LLM Terms

### Large Language Model (LLM)
A neural network trained on text data capable of generating human-like text responses.

### Token
The basic unit of text processing for LLMs. Words are split into one or more tokens.

### Prompt
The input text provided to an LLM to generate a response.

### Completion
The text generated by an LLM in response to a prompt.

### Temperature
A parameter controlling randomness in LLM output (0 = deterministic, 1 = creative).

### Top-P (Nucleus Sampling)
A sampling method that considers only the most probable tokens whose cumulative probability exceeds p.

### Streaming
Receiving LLM output incrementally as it's generated rather than waiting for completion.

### Fine-Tuning
Additional training of an LLM on domain-specific data.

---

## Tool Terms

### Tool
A function that the agent can invoke to interact with external systems.

### Tool Call
An agent's request to execute a specific tool with given arguments.

### Tool Result
The output returned from a tool execution.

### Function Calling
LLM capability to generate structured tool invocations.

### Sandbox
An isolated execution environment for running untrusted code.

### Shell
A command-line interpreter for executing system commands.

---

## State Terms

### State Machine
A computational model with a finite number of states and transitions between them.

### Idle State
Agent is ready to receive new operations.

### Processing State
Agent is actively working on a turn.

### WaitingApproval State
Agent is blocked waiting for user approval.

### Error State
Agent encountered an error and requires recovery.

### Transition
A change from one state to another triggered by an event.

---

## Error Terms

### Recoverable Error
An error the system can handle and continue operation.

### Fatal Error
An error requiring system restart or intervention.

### Retry
Attempting an operation again after failure.

### Backoff
Increasing delay between retry attempts.

### Circuit Breaker
Pattern that stops requests after repeated failures.

### Graceful Degradation
Maintaining partial functionality when components fail.

---

## Concurrency Terms

### Async
Asynchronous execution that doesn't block the calling thread.

### Await
Suspending execution until an async operation completes.

### Future
A value that will be available at some point.

### Task
A unit of async work scheduled for execution.

### Spawn
Creating a new concurrent task.

### Join
Waiting for a task to complete.

### Mutex
A synchronization primitive ensuring exclusive access.

### Lock
Acquiring exclusive access to a shared resource.

---

## Pattern Terms

### Request-Response
Communication pattern where each request expects exactly one response.

### Publish-Subscribe
Pattern where publishers emit events to multiple subscribers.

### Observer
Pattern where objects are notified of state changes.

### Command
Pattern encapsulating a request as an object.

### Strategy
Pattern defining a family of interchangeable algorithms.

### Factory
Pattern for creating objects without specifying exact classes.

---

## Security Terms

### Sandboxing
Isolating code execution to prevent system damage.

### Permission
Authorization to perform a specific action.

### Capability
A token granting access to a resource or operation.

### Principle of Least Privilege
Granting only minimum permissions needed.

### Input Validation
Checking user input for correctness and safety.

### Output Sanitization
Cleaning output to prevent injection attacks.

---

## Protocol Terms

### Wire Format
The serialization format used for network transmission.

### Framing
Delimiting message boundaries in a stream.

### Handshake
Initial exchange establishing connection parameters.

### Heartbeat
Periodic messages confirming connection liveness.

### Timeout
Maximum time to wait for a response.

### Retry Policy
Rules governing retry attempts after failures.

---

## Testing Terms

### Unit Test
Test for a single component in isolation.

### Integration Test
Test for multiple components working together.

### End-to-End Test
Test for the complete system from user perspective.

### Mock
A fake implementation for testing.

### Stub
A minimal implementation returning predefined values.

### Fixture
Predefined test data or state.

---

## Metrics Terms

### Latency
Time between request and response.

### Throughput
Number of operations per unit time.

### Error Rate
Percentage of failed operations.

### Availability
Percentage of time the system is operational.

### P50/P95/P99
Percentile latency measurements.

### SLA (Service Level Agreement)
Guaranteed performance commitments.

---

## File System Terms

### Working Directory
The current directory context for operations.

### Absolute Path
A complete path from the root directory.

### Relative Path
A path relative to the current directory.

### File Watcher
A mechanism to detect file system changes.

### Patch
A set of changes to apply to files.

### Diff
The difference between two versions of content.

---

## Git Terms

### Repository
A Git version control database.

### Commit
A snapshot of changes in the repository.

### Branch
A named pointer to a commit.

### Merge
Combining changes from different branches.

### Rebase
Moving commits to a new base commit.

### Stash
Temporarily saving uncommitted changes.

---

## API Terms

### Endpoint
A specific URL path for an API operation.

### Rate Limit
Maximum requests allowed in a time period.

### API Key
A secret token for API authentication.

### Webhook
An HTTP callback for event notifications.

### Pagination
Splitting large results into pages.

### Cursor
A marker for position in paginated results.

---

## Deployment Terms

### Container
A lightweight isolated runtime environment.

### Orchestration
Managing multiple containers or services.

### Load Balancer
Distributing requests across servers.

### Health Check
Verifying service availability.

### Rolling Update
Gradual deployment replacing instances.

### Rollback
Reverting to a previous version.

---

## Abbreviations

| Abbreviation | Full Form |
|--------------|-----------|
| AI | Artificial Intelligence |
| API | Application Programming Interface |
| CLI | Command Line Interface |
| CRUD | Create, Read, Update, Delete |
| HTTP | HyperText Transfer Protocol |
| IDE | Integrated Development Environment |
| JSON | JavaScript Object Notation |
| LLM | Large Language Model |
| MCP | Model Context Protocol |
| REST | Representational State Transfer |
| RPC | Remote Procedure Call |
| SDK | Software Development Kit |
| TUI | Terminal User Interface |
| UI | User Interface |
| URL | Uniform Resource Locator |
| UUID | Universally Unique Identifier |

---

## Related Files

| File | Content |
|------|---------|
| `CONCEPTS.md` | Detailed concept explanations |
| `PATTERNS.md` | Implementation patterns |
| `WORKFLOWS.md` | Task execution guides |
| `architecture-diagram.md` | Visual architecture diagrams |
