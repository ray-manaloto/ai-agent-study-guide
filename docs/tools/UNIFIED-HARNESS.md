# Unified Multi-Provider Agent Harness

> A generic architecture for building AI coding agents with multi-provider support and multi-agent orchestration

---

## Overview

This document defines a unified harness architecture synthesized from 7 production AI coding agent implementations. The harness provides:

- **Multi-provider support**: Anthropic, OpenAI, Google, Local models
- **Multi-agent orchestration**: Hierarchical, mesh, and swarm topologies
- **Agent loop**: Provider-agnostic reasoning and tool execution cycle
- **Tool registry**: Extensible tool system
- **Session management**: Persistence and forking

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           UNIFIED AGENT HARNESS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                         PRESENTATION LAYER                           │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐                │    │
│  │  │   CLI   │  │   TUI   │  │   Web   │  │   API   │                │    │
│  │  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘                │    │
│  │       └───────────┬┴───────────┴────────────┘                       │    │
│  │                   ▼                                                  │    │
│  │          ┌───────────────┐                                          │    │
│  │          │ Message Router│                                          │    │
│  │          └───────┬───────┘                                          │    │
│  └──────────────────┼──────────────────────────────────────────────────┘    │
│                     │                                                        │
│  ┌──────────────────┼──────────────────────────────────────────────────┐    │
│  │                  │           ORCHESTRATION LAYER                     │    │
│  │                  ▼                                                   │    │
│  │         ┌────────────────┐                                          │    │
│  │         │  Orchestrator  │◄─────────┐                               │    │
│  │         │    (Thin)      │          │                               │    │
│  │         └───────┬────────┘          │                               │    │
│  │                 │                   │                               │    │
│  │    ┌────────────┼────────────┐      │                               │    │
│  │    ▼            ▼            ▼      │                               │    │
│  │ ┌──────┐   ┌──────┐    ┌──────┐     │                               │    │
│  │ │Agent │   │Agent │    │Agent │     │  Results                      │    │
│  │ │  A   │   │  B   │    │  C   │─────┘                               │    │
│  │ └──┬───┘   └──┬───┘    └──┬───┘                                     │    │
│  │    │          │           │                                          │    │
│  └────┼──────────┼───────────┼──────────────────────────────────────────┘    │
│       │          │           │                                              │
│  ┌────┼──────────┼───────────┼──────────────────────────────────────────┐    │
│  │    │          │           │           PROVIDER LAYER                  │    │
│  │    ▼          ▼           ▼                                          │    │
│  │ ┌─────────────────────────────┐                                      │    │
│  │ │      Provider Adapter       │                                      │    │
│  │ └─────────────┬───────────────┘                                      │    │
│  │               │                                                       │    │
│  │    ┌──────────┼──────────┬──────────┐                                │    │
│  │    ▼          ▼          ▼          ▼                                │    │
│  │ ┌──────┐ ┌──────┐  ┌──────┐  ┌───────┐                              │    │
│  │ │Claude│ │OpenAI│  │Google│  │ Local │                              │    │
│  │ └──────┘ └──────┘  └──────┘  └───────┘                              │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐    │
│  │                         INFRASTRUCTURE LAYER                          │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐   │    │
│  │  │  Tools  │  │ Memory  │  │ Session │  │Approval │  │  Hooks  │   │    │
│  │  │Registry │  │  Store  │  │ Manager │  │  Queue  │  │ System  │   │    │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘   │    │
│  └──────────────────────────────────────────────────────────────────────┘    │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Core Components

### 1. Message Types

The harness uses a unified message protocol compatible with all providers:

```typescript
// Input messages (User → Agent)
type Operation =
  | { type: "user_message"; content: string; attachments?: Attachment[] }
  | { type: "tool_approval"; requestId: string; approved: boolean; reason?: string }
  | { type: "interrupt" }
  | { type: "undo" }
  | { type: "config_update"; settings: Partial<Settings> };

// Output messages (Agent → User)
type Event =
  | { type: "turn_started"; turnId: string }
  | { type: "turn_complete"; turnId: string; summary: string }
  | { type: "text_delta"; content: string }
  | { type: "text_complete"; content: string }
  | { type: "tool_call"; id: string; name: string; args: unknown }
  | { type: "tool_result"; id: string; result: unknown }
  | { type: "approval_request"; id: string; tool: string; args: unknown; risk: Risk }
  | { type: "error"; code: string; message: string; recoverable: boolean }
  | { type: "status"; state: AgentState };

// Attachment types
type Attachment =
  | { type: "file"; path: string; content?: string }
  | { type: "image"; url: string; base64?: string }
  | { type: "url"; url: string };
```

### 2. Provider Interface

```typescript
interface Provider {
  // Identity
  readonly name: string;
  readonly models: Model[];
  
  // Capabilities
  readonly capabilities: {
    streaming: boolean;
    tools: boolean;
    vision: boolean;
    embeddings: boolean;
    maxContextWindow: number;
  };
  
  // Core operations
  chat(request: ChatRequest): AsyncIterator<ChatChunk>;
  embed(text: string | string[]): Promise<Embedding[]>;
  
  // Lifecycle
  initialize(): Promise<void>;
  shutdown(): Promise<void>;
  healthCheck(): Promise<HealthStatus>;
}

interface ChatRequest {
  model: string;
  messages: Message[];
  tools?: Tool[];
  temperature?: number;
  maxTokens?: number;
  stopSequences?: string[];
}

interface ChatChunk {
  type: "text" | "tool_call" | "tool_result" | "done";
  content?: string;
  toolCall?: ToolCall;
  toolResult?: ToolResult;
  usage?: TokenUsage;
}
```

### 3. Tool Registry

```typescript
interface Tool {
  // Metadata
  name: string;
  description: string;
  category: ToolCategory;
  
  // Schema
  parameters: JSONSchema;
  returns: JSONSchema;
  
  // Execution
  execute(args: unknown, context: ToolContext): Promise<ToolResult>;
  
  // Safety
  riskLevel: "low" | "medium" | "high" | "critical";
  requiresApproval: boolean;
  validate?(args: unknown): ValidationResult;
}

interface ToolRegistry {
  // Management
  register(tool: Tool): void;
  unregister(name: string): void;
  
  // Discovery
  get(name: string): Tool | undefined;
  list(category?: ToolCategory): Tool[];
  search(query: string): Tool[];
  
  // Execution
  execute(name: string, args: unknown, context: ToolContext): Promise<ToolResult>;
  
  // Events
  onRegister(callback: (tool: Tool) => void): void;
  onExecute(callback: (execution: ToolExecution) => void): void;
}

// Built-in tool categories
type ToolCategory =
  | "filesystem"      // read, write, edit, glob, grep
  | "shell"          // bash, terminal
  | "web"            // fetch, browser
  | "code_analysis"  // lsp, ast, symbols
  | "git"            // status, diff, commit
  | "mcp"            // MCP server tools
  | "custom";        // User-defined
```

### 4. Orchestrator

```typescript
interface Orchestrator {
  // Configuration
  readonly topology: Topology;
  readonly maxAgents: number;
  
  // Agent management
  spawn(config: AgentConfig): Promise<Agent>;
  terminate(agentId: string): Promise<void>;
  list(): Agent[];
  
  // Task distribution
  delegate(task: Task, options?: DelegationOptions): Promise<TaskResult>;
  broadcast(message: Message): Promise<void>;
  
  // Coordination
  sync(): Promise<void>;
  checkpoint(): Promise<Checkpoint>;
  restore(checkpoint: Checkpoint): Promise<void>;
}

interface DelegationOptions {
  // Routing
  category?: TaskCategory;         // Category-based routing
  agentId?: string;                // Direct routing
  skills?: string[];               // Required skills
  
  // Execution
  timeout?: number;
  retries?: number;
  parallel?: boolean;
  
  // Context
  context?: unknown;               // Task-specific context
  inheritContext?: boolean;        // Inherit orchestrator context
}

type Topology =
  | "single"              // One agent
  | "hierarchical"        // Coordinator + workers
  | "mesh"               // Peer-to-peer
  | "pipeline"           // Sequential stages
  | "swarm"              // Dynamic coordination
  | "hierarchical-mesh"; // Hybrid
```

### 5. Session Manager

```typescript
interface SessionManager {
  // Lifecycle
  create(config?: SessionConfig): Promise<Session>;
  restore(sessionId: string): Promise<Session>;
  fork(sessionId: string, options?: ForkOptions): Promise<Session>;
  
  // Persistence
  save(session: Session): Promise<void>;
  load(sessionId: string): Promise<Session | null>;
  delete(sessionId: string): Promise<void>;
  list(filter?: SessionFilter): Promise<SessionSummary[]>;
  
  // State
  export(sessionId: string): Promise<SessionExport>;
  import(data: SessionExport): Promise<Session>;
}

interface Session {
  // Identity
  id: string;
  parentId?: string;  // For forks
  created: Date;
  updated: Date;
  
  // State
  messages: Message[];
  context: ContextWindow;
  settings: Settings;
  
  // Agent state
  agents: AgentState[];
  tasks: Task[];
  
  // Approvals
  policies: PolicyAmendment[];
  pendingApprovals: ApprovalRequest[];
  
  // Artifacts
  artifacts: Map<string, Artifact>;
}
```

---

## Agent Loop

### Agent Execution Loop

The agent loop is the core execution cycle where the agent perceives input, reasons about it, acts via tools, and observes results. This is distinct from traditional "event loops" (like Node.js's libuv or Python's asyncio) which handle I/O multiplexing.

> **Terminology Note**: Industry-standard terminology from OpenAI, Anthropic, and academic literature uses "Agent Loop" or "Agentic Loop" for this pattern. "Event Loop" refers specifically to async I/O polling in traditional programming.

```typescript
class AgentLoop {
  private providers: Map<string, Provider>;
  private tools: ToolRegistry;
  private orchestrator: Orchestrator;
  private sessions: SessionManager;
  private approvals: ApprovalQueue;
  
  async run(session: Session): Promise<void> {
    while (!session.terminated) {
      // 1. Collect input events
      const inputs = await this.collectInputs(session);
      
      // 2. Process each input
      for (const input of inputs) {
        await this.processInput(session, input);
      }
      
      // 3. Process pending approvals
      await this.processApprovals(session);
      
      // 4. Yield to allow other operations
      await this.yield();
    }
  }
  
  private async processInput(session: Session, input: Operation): Promise<void> {
    switch (input.type) {
      case "user_message":
        await this.handleUserMessage(session, input);
        break;
      case "tool_approval":
        await this.handleToolApproval(session, input);
        break;
      case "interrupt":
        await this.handleInterrupt(session);
        break;
      // ... other cases
    }
  }
  
  private async handleUserMessage(session: Session, input: UserMessage): Promise<void> {
    // 1. Emit turn started
    this.emit({ type: "turn_started", turnId: generateId() });
    
    // 2. Build messages array
    const messages = this.buildMessages(session, input);
    
    // 3. Get active tools
    const tools = this.tools.list().filter(t => this.shouldIncludeTool(t, session));
    
    // 4. Select provider and model
    const { provider, model } = this.selectProvider(session);
    
    // 5. Stream response
    for await (const chunk of provider.chat({ model, messages, tools })) {
      await this.handleChunk(session, chunk);
    }
    
    // 6. Emit turn complete
    this.emit({ type: "turn_complete", turnId, summary: this.summarize(session) });
  }
  
  private async handleChunk(session: Session, chunk: ChatChunk): Promise<void> {
    switch (chunk.type) {
      case "text":
        this.emit({ type: "text_delta", content: chunk.content });
        break;
        
      case "tool_call":
        await this.handleToolCall(session, chunk.toolCall);
        break;
        
      case "done":
        // Update token usage, etc.
        break;
    }
  }
  
  private async handleToolCall(session: Session, call: ToolCall): Promise<void> {
    const tool = this.tools.get(call.name);
    if (!tool) {
      this.emit({ type: "error", code: "UNKNOWN_TOOL", message: `Unknown tool: ${call.name}` });
      return;
    }
    
    // Check if approval required
    if (tool.requiresApproval || this.requiresApproval(session, tool, call.args)) {
      this.approvals.enqueue({
        id: call.id,
        tool: tool.name,
        args: call.args,
        risk: this.assessRisk(tool, call.args)
      });
      this.emit({ type: "approval_request", id: call.id, tool: tool.name, args: call.args });
      return;
    }
    
    // Execute tool
    await this.executeTool(session, tool, call);
  }
  
  private async executeTool(session: Session, tool: Tool, call: ToolCall): Promise<void> {
    this.emit({ type: "tool_call", id: call.id, name: tool.name, args: call.args });
    
    try {
      const result = await tool.execute(call.args, this.createToolContext(session));
      this.emit({ type: "tool_result", id: call.id, result });
      
      // Add result to context for next LLM call
      session.pendingToolResults.push({ id: call.id, result });
    } catch (error) {
      this.emit({ type: "error", code: "TOOL_FAILED", message: error.message, recoverable: true });
    }
  }
}
```

### Agent Loop Sequence Diagram

```mermaid
sequenceDiagram
    participant U as User/UI
    participant L as Agent Loop
    participant P as Provider
    participant T as Tool Registry
    participant A as Approval Queue
    
    U->>L: user_message
    L->>L: turn_started
    L->>P: chat(messages, tools)
    
    loop Stream Response
        P->>L: text_delta
        L->>U: text_delta
        
        alt Tool Call
            P->>L: tool_call
            
            alt Needs Approval
                L->>A: enqueue(request)
                L->>U: approval_request
                U->>L: tool_approval
                A->>L: dequeue
            end
            
            L->>T: execute(tool, args)
            T->>L: result
            L->>U: tool_result
            L->>P: continue with result
        end
    end
    
    P->>L: done
    L->>U: turn_complete
```

---

## Multi-Agent Coordination

### Hierarchical Topology

```
                    ┌──────────────┐
                    │ Orchestrator │
                    │   (Thin)     │
                    └──────┬───────┘
                           │
           ┌───────────────┼───────────────┐
           ▼               ▼               ▼
      ┌─────────┐    ┌─────────┐    ┌─────────┐
      │ Worker  │    │ Worker  │    │ Worker  │
      │    A    │    │    B    │    │    C    │
      └─────────┘    └─────────┘    └─────────┘
```

```typescript
class HierarchicalOrchestrator implements Orchestrator {
  private workers: Map<string, Agent> = new Map();
  
  async delegate(task: Task, options?: DelegationOptions): Promise<TaskResult> {
    // 1. Select worker based on category/skills
    const worker = this.selectWorker(task, options);
    
    // 2. Prepare delegation prompt
    const prompt = this.buildDelegationPrompt(task, options);
    
    // 3. Execute with fresh context
    const result = await worker.execute(prompt, {
      freshContext: true,
      returnFormat: "summary"
    });
    
    // 4. Update orchestrator state with summary
    this.updateState(result.summary);
    
    return result;
  }
  
  private selectWorker(task: Task, options?: DelegationOptions): Agent {
    if (options?.agentId) {
      return this.workers.get(options.agentId)!;
    }
    
    if (options?.category) {
      return this.findByCategory(options.category);
    }
    
    if (options?.skills) {
      return this.findBySkills(options.skills);
    }
    
    return this.findBestAvailable(task);
  }
}
```

### Mesh Topology

```
      ┌─────────┐◄───────────►┌─────────┐
      │ Agent A │             │ Agent B │
      └────┬────┘             └────┬────┘
           │                       │
           │    ┌─────────┐        │
           └───►│ Agent C │◄───────┘
                └────┬────┘
                     │
      ┌─────────────┬┴──────────────┐
      ▼             ▼               ▼
┌─────────┐   ┌─────────┐    ┌─────────┐
│ Agent D │◄─►│ Agent E │◄──►│ Agent F │
└─────────┘   └─────────┘    └─────────┘
```

```typescript
class MeshOrchestrator implements Orchestrator {
  private agents: Map<string, Agent> = new Map();
  private connections: Map<string, Set<string>> = new Map();
  
  async broadcast(message: Message): Promise<void> {
    await Promise.all(
      Array.from(this.agents.values()).map(agent =>
        agent.receive(message)
      )
    );
  }
  
  async delegate(task: Task): Promise<TaskResult> {
    // Collaborative delegation - agents negotiate
    const assignments = await this.negotiate(task);
    
    const results = await Promise.all(
      assignments.map(({ agent, subtask }) =>
        agent.execute(subtask)
      )
    );
    
    return this.synthesize(results);
  }
}
```

### Wave-Based Execution

```typescript
class WaveExecutor {
  async execute(tasks: Task[]): Promise<Map<string, TaskResult>> {
    // Build dependency graph
    const graph = this.buildGraph(tasks);
    
    // Topologically sort into waves
    const waves = this.toWaves(graph);
    
    // Execute wave by wave
    const results = new Map<string, TaskResult>();
    
    for (const wave of waves) {
      // Execute all tasks in wave in parallel
      const waveResults = await Promise.all(
        wave.map(task => this.executeTask(task, results))
      );
      
      // Store results
      wave.forEach((task, i) => results.set(task.id, waveResults[i]));
    }
    
    return results;
  }
  
  private toWaves(graph: DependencyGraph): Task[][] {
    const waves: Task[][] = [];
    const completed = new Set<string>();
    
    while (completed.size < graph.size) {
      // Find all tasks with satisfied dependencies
      const wave = Array.from(graph.entries())
        .filter(([id, deps]) => 
          !completed.has(id) && 
          deps.every(d => completed.has(d))
        )
        .map(([id]) => graph.getTask(id));
      
      if (wave.length === 0) {
        throw new Error("Circular dependency detected");
      }
      
      waves.push(wave);
      wave.forEach(t => completed.add(t.id));
    }
    
    return waves;
  }
}
```

---

## Provider Implementations

### Anthropic Provider

```typescript
class AnthropicProvider implements Provider {
  readonly name = "anthropic";
  readonly models = [
    { id: "claude-sonnet-4-20250514", contextWindow: 200_000 },
    { id: "claude-opus-4-20250514", contextWindow: 200_000 },
    { id: "claude-3-5-haiku-20241022", contextWindow: 200_000 },
  ];
  
  async *chat(request: ChatRequest): AsyncIterator<ChatChunk> {
    const response = await this.client.messages.stream({
      model: request.model,
      messages: this.convertMessages(request.messages),
      tools: this.convertTools(request.tools),
      max_tokens: request.maxTokens ?? 8192,
    });
    
    for await (const event of response) {
      yield this.convertEvent(event);
    }
  }
  
  private convertMessages(messages: Message[]): AnthropicMessage[] {
    return messages.map(m => ({
      role: m.role === "user" ? "user" : "assistant",
      content: this.convertContent(m.content)
    }));
  }
}
```

### OpenAI Provider

```typescript
class OpenAIProvider implements Provider {
  readonly name = "openai";
  readonly models = [
    { id: "gpt-4o", contextWindow: 128_000 },
    { id: "gpt-4o-mini", contextWindow: 128_000 },
    { id: "o1", contextWindow: 200_000 },
  ];
  
  async *chat(request: ChatRequest): AsyncIterator<ChatChunk> {
    const stream = await this.client.chat.completions.create({
      model: request.model,
      messages: this.convertMessages(request.messages),
      tools: this.convertTools(request.tools),
      stream: true,
    });
    
    for await (const chunk of stream) {
      yield this.convertChunk(chunk);
    }
  }
}
```

### Local Provider (Ollama)

```typescript
class OllamaProvider implements Provider {
  readonly name = "ollama";
  
  get models(): Model[] {
    // Dynamically discover available models
    return this.cachedModels;
  }
  
  async *chat(request: ChatRequest): AsyncIterator<ChatChunk> {
    const response = await fetch(`${this.baseUrl}/api/chat`, {
      method: "POST",
      body: JSON.stringify({
        model: request.model,
        messages: this.convertMessages(request.messages),
        stream: true,
      }),
    });
    
    const reader = response.body!.getReader();
    const decoder = new TextDecoder();
    
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      
      const text = decoder.decode(value);
      for (const line of text.split("\n").filter(Boolean)) {
        yield this.parseChunk(JSON.parse(line));
      }
    }
  }
}
```

---

## Built-in Tools

### File System Tools

```typescript
const filesystemTools: Tool[] = [
  {
    name: "read_file",
    description: "Read the contents of a file",
    category: "filesystem",
    riskLevel: "low",
    requiresApproval: false,
    parameters: {
      type: "object",
      properties: {
        path: { type: "string", description: "File path" },
        offset: { type: "number", description: "Start line (0-indexed)" },
        limit: { type: "number", description: "Number of lines" }
      },
      required: ["path"]
    },
    execute: async (args, ctx) => {
      const content = await fs.readFile(args.path, "utf-8");
      // Apply offset/limit
      return { content };
    }
  },
  {
    name: "write_file",
    description: "Write content to a file",
    category: "filesystem",
    riskLevel: "medium",
    requiresApproval: true,
    parameters: {
      type: "object",
      properties: {
        path: { type: "string" },
        content: { type: "string" }
      },
      required: ["path", "content"]
    },
    execute: async (args, ctx) => {
      await fs.writeFile(args.path, args.content);
      return { success: true };
    }
  },
  {
    name: "edit_file",
    description: "Edit a file using search/replace",
    category: "filesystem",
    riskLevel: "medium",
    requiresApproval: true,
    parameters: {
      type: "object",
      properties: {
        path: { type: "string" },
        oldText: { type: "string" },
        newText: { type: "string" }
      },
      required: ["path", "oldText", "newText"]
    },
    execute: async (args, ctx) => {
      const content = await fs.readFile(args.path, "utf-8");
      const updated = content.replace(args.oldText, args.newText);
      await fs.writeFile(args.path, updated);
      return { success: true };
    }
  }
];
```

### Shell Tools

```typescript
const shellTools: Tool[] = [
  {
    name: "bash",
    description: "Execute a bash command",
    category: "shell",
    riskLevel: "high",
    requiresApproval: true,
    parameters: {
      type: "object",
      properties: {
        command: { type: "string" },
        workdir: { type: "string" },
        timeout: { type: "number" }
      },
      required: ["command"]
    },
    validate: (args) => {
      // Block dangerous commands
      const dangerous = ["rm -rf /", ":(){ :|:& };:", "dd if="];
      if (dangerous.some(d => args.command.includes(d))) {
        return { valid: false, reason: "Command blocked for safety" };
      }
      return { valid: true };
    },
    execute: async (args, ctx) => {
      const result = await exec(args.command, {
        cwd: args.workdir ?? ctx.workdir,
        timeout: args.timeout ?? 120_000
      });
      return {
        stdout: result.stdout,
        stderr: result.stderr,
        exitCode: result.exitCode
      };
    }
  }
];
```

### Code Analysis Tools

```typescript
const codeAnalysisTools: Tool[] = [
  {
    name: "lsp_diagnostics",
    description: "Get LSP diagnostics for a file",
    category: "code_analysis",
    riskLevel: "low",
    requiresApproval: false,
    parameters: {
      type: "object",
      properties: {
        path: { type: "string" },
        severity: { type: "string", enum: ["error", "warning", "all"] }
      },
      required: ["path"]
    },
    execute: async (args, ctx) => {
      const diagnostics = await ctx.lsp.getDiagnostics(args.path);
      return { diagnostics };
    }
  },
  {
    name: "lsp_goto_definition",
    description: "Find definition of a symbol",
    category: "code_analysis",
    riskLevel: "low",
    requiresApproval: false,
    parameters: {
      type: "object",
      properties: {
        path: { type: "string" },
        line: { type: "number" },
        character: { type: "number" }
      },
      required: ["path", "line", "character"]
    },
    execute: async (args, ctx) => {
      const location = await ctx.lsp.gotoDefinition(args);
      return { location };
    }
  }
];
```

---

## Configuration

### Harness Configuration

```typescript
interface HarnessConfig {
  // Provider configuration
  providers: {
    [name: string]: ProviderConfig;
  };
  
  // Default provider/model
  defaultProvider: string;
  defaultModel: string;
  
  // Orchestration
  orchestration: {
    topology: Topology;
    maxAgents: number;
    strategy: "specialized" | "generalist" | "adaptive";
  };
  
  // Session
  session: {
    persistence: "memory" | "file" | "database";
    storagePath?: string;
    autoSave: boolean;
    autoSaveInterval: number;
  };
  
  // Approval
  approval: {
    mode: "ask" | "allow" | "deny";
    defaultPolicies: PolicyAmendment[];
  };
  
  // Tools
  tools: {
    enabled: string[];
    disabled: string[];
    mcpServers: MCPServerConfig[];
  };
  
  // Limits
  limits: {
    maxContextTokens: number;
    maxOutputTokens: number;
    maxToolCalls: number;
    timeout: number;
  };
}
```

### Example Configuration

```yaml
# harness.config.yaml
providers:
  anthropic:
    apiKey: ${ANTHROPIC_API_KEY}
  openai:
    apiKey: ${OPENAI_API_KEY}
  ollama:
    baseUrl: http://localhost:11434

defaultProvider: anthropic
defaultModel: claude-sonnet-4-20250514

orchestration:
  topology: hierarchical
  maxAgents: 8
  strategy: specialized

session:
  persistence: file
  storagePath: .sessions
  autoSave: true
  autoSaveInterval: 60000

approval:
  mode: ask
  defaultPolicies:
    - pattern: "read_file *"
      action: allow
    - pattern: "rm -rf *"
      action: deny

tools:
  enabled:
    - filesystem
    - shell
    - code_analysis
    - git
  mcpServers:
    - name: custom-tools
      command: npx
      args: ["-y", "my-mcp-server"]

limits:
  maxContextTokens: 150000
  maxOutputTokens: 8192
  maxToolCalls: 100
  timeout: 300000
```

---

## Extension Points (Comprehensive)

This section documents **12 customization categories** synthesized from 7 production implementations.

### Customization Matrix (Detailed)

| Category | Codex | Claude Code | OpenCode | Oh-My-OpenCode | Kata | GSD | Kimi K2 |
|----------|-------|-------------|----------|----------------|------|-----|---------|
| **Hooks** | Events + Notify | 11 lifecycle | 26 hooks | 31 hooks | Statusline | Statusline | - |
| **Tools** | 15+ built-in | 20+ MCP | 25+ MCP+ACP | 30+ Custom | Skill-embedded | Skill-embedded | API register |
| **Skills** | Skills dirs | Skills+Commands | Skills dirs | Skills+Triggers | 27 skills | Commands | - |
| **Slash Commands** | - | /skill-name | - | 37+ commands | /kata:* | /gsd:* | - |
| **Plugins** | - | MCP servers | Full plugins | Full plugins | - | - | - |
| **MCP/ACP** | MCP support | MCP + OAuth | MCP+ACP+OAuth | MCP | - | - | - |
| **Providers** | OpenAI+Custom | Anthropic | 18+ AI SDK | 20+ | Claude | Multi-runtime | Moonshot |
| **Agents** | Single | Subagents | Primary+Sub | 10+ specialized | 19+ | 11 | 100 swarm |
| **Config** | TOML+Profiles | settings.json | JSON/JSONC | JSON+YAML | config.json | config.json | API params |
| **Approvals** | Starlark rules | Permissions | Glob policies | Rules | Auto | Auto | - |
| **Workflows** | - | - | - | Ralph/Ultra | 8 phases | 6 steps | PARL |
| **Memory** | Session | Ephemeral | Persist | Notepads | Artifacts | STATE.md | Context |

### Customization Detail Summary

| Framework | Primary Extension Method | Key Customization Files |
|-----------|--------------------------|-------------------------|
| **Codex** | Skills + Rules + Profiles | `~/.codex/config.toml`, `~/.codex/skills/*/SKILL.md`, `~/.codex/rules/*.rules` |
| **Claude Code** | MCP + Skills + Hooks | `~/.claude/settings.json`, `.mcp.json`, `.claude/skills/*/SKILL.md` |
| **OpenCode** | Plugins + Hooks (26 types) | `opencode.json`, `.opencode/plugins/`, `.opencode/tools/` |
| **Oh-My-OpenCode** | Hooks (31) + Skills + Categories | `.omc/skills/`, `.claude/settings.json`, agent definitions |
| **Kata** | XML Templates + Phases + Skills | `.planning/config.json`, agents/*.md, CONTEXT.md |
| **GSD** | Context Files + Model Profiles | `.planning/`, STATE.md, config.json |
| **Kimi K2** | API Parameters + PARL Config | API: temp, top_p, max_tokens, swarm config |

---

### 1. Hooks System

**Sources**: Codex (events), Claude Code (settings.json), Oh-My-OpenCode (32+ hooks)

#### Hook Categories

| Category | Hooks | Purpose |
|----------|-------|---------|
| **Lifecycle** | session-start, session-end | Setup/teardown |
| **Message** | chat.message, messages.transform | Input/output transformation |
| **Tool** | tool.execute.before, tool.execute.after | Intercept tool calls |
| **Edit** | pre-edit, post-edit | File modification control |
| **Command** | pre-command, post-command | Shell execution control |
| **Task** | pre-task, post-task | Task lifecycle |
| **Learning** | on-success, on-failure | Pattern extraction |
| **Context** | context-inject, compaction | Context management |

#### Hook Interface

```typescript
interface HookSystem {
  // Registration
  register(hook: Hook): void;
  unregister(hookId: string): void;
  
  // Execution
  trigger(event: string, context: HookContext): Promise<HookResult>;
  
  // Discovery
  list(category?: string): Hook[];
}

interface Hook {
  id: string;
  event: string;           // e.g., "pre-edit", "tool.execute.before"
  priority: number;        // Execution order (lower = first)
  handler: HookHandler;
  enabled: boolean;
}

type HookHandler = (context: HookContext) => Promise<HookResult>;

interface HookContext {
  event: string;
  data: unknown;           // Event-specific data
  session: Session;
  cancel?: () => void;     // Cancel the operation
  modify?: (data: unknown) => void;  // Modify the data
}

interface HookResult {
  continue: boolean;       // Whether to continue execution
  data?: unknown;          // Modified data
  error?: Error;
}
```

#### Hook Configuration (Oh-My-OpenCode Style)

```json
// .opencode/hooks.json or ~/.claude/settings.json
{
  "hooks": {
    "pre-edit": [
      {
        "id": "format-check",
        "command": "prettier --check",
        "enabled": true
      }
    ],
    "post-edit": [
      {
        "id": "auto-format",
        "command": "prettier --write",
        "enabled": true
      }
    ],
    "chat.message": [
      {
        "id": "keyword-detector",
        "type": "builtin",
        "config": {
          "keywords": ["ultrawork", "analyze", "search"]
        }
      }
    ]
  }
}
```

#### Built-in Hook Examples

| Hook | Tool | Purpose |
|------|------|---------|
| `directory-agents-injector` | Oh-My-OpenCode | Auto-injects AGENTS.md |
| `rules-injector` | Oh-My-OpenCode | Injects .claude/rules/ |
| `keyword-detector` | Oh-My-OpenCode | Detects trigger words |
| `todo-continuation-enforcer` | Oh-My-OpenCode | Forces task completion |
| `edit-error-recovery` | Oh-My-OpenCode | Recovers from edit failures |
| `think-mode` | Oh-My-OpenCode | Auto-detects extended thinking |

---

### 2. Tools System

**Sources**: All tools

#### Tool Interface

```typescript
interface Tool {
  // Identity
  name: string;
  description: string;
  category: ToolCategory;
  
  // Schema (JSON Schema)
  parameters: JSONSchema;
  returns: JSONSchema;
  
  // Execution
  execute(args: unknown, context: ToolContext): Promise<ToolResult>;
  
  // Safety
  riskLevel: "low" | "medium" | "high" | "critical";
  requiresApproval: boolean;
  validate?(args: unknown): ValidationResult;
}

type ToolCategory =
  | "filesystem"      // read, write, edit, glob, grep
  | "shell"           // bash, terminal
  | "web"             // fetch, browser, search
  | "code_analysis"   // lsp, ast, symbols
  | "git"             // status, diff, commit
  | "mcp"             // MCP server tools
  | "delegation"      // Task, subagent spawning
  | "memory"          // Store, retrieve, search
  | "custom";         // User-defined
```

#### Tool Registration

```typescript
// Built-in registration
harness.tools.register({
  name: "custom_search",
  description: "Search using custom index",
  category: "custom",
  riskLevel: "low",
  requiresApproval: false,
  parameters: {
    type: "object",
    properties: {
      query: { type: "string" },
      limit: { type: "number", default: 10 }
    },
    required: ["query"]
  },
  execute: async (args, ctx) => {
    const results = await customIndex.search(args.query, args.limit);
    return { results };
  }
});

// MCP-based registration (Claude Code, OpenCode)
// Tools automatically discovered from MCP servers
```

#### Tool Categories by Framework

| Framework | Built-in Tools | Extension Method |
|-----------|---------------|------------------|
| Codex | 15+ | Protocol extension |
| Claude Code | 20+ | MCP servers |
| OpenCode | 25+ | MCP + ACP |
| Oh-My-OpenCode | 30+ | Custom + MCP |
| Kata | 10+ | Skill-embedded |
| GSD | 10+ | Skill-embedded |
| Kimi K2 | API-based | Tool registration API |

---

### 3. Skills System

**Sources**: Claude Code, Oh-My-OpenCode, Kata, GSD

#### Skill Definition

```yaml
# ~/.opencode/skills/frontend-ui-ux/SKILL.md
# Or: ~/.claude/commands/frontend-ui-ux.md
---
name: frontend-ui-ux
description: Designer-turned-developer who crafts stunning UI/UX
triggers:
  - "UI component"
  - "responsive design"
  - "animation"
  - "styling"
mcp:
  playwright:
    command: npx
    args: ["-y", "@anthropic-ai/mcp-playwright"]
---

# Frontend UI/UX Skill

You are a designer-turned-developer who creates beautiful, accessible interfaces.

## Core Principles
1. Mobile-first responsive design
2. WCAG 2.1 AA accessibility
3. Performance budgets (LCP < 2.5s)
4. Design system adherence

## When creating components:
- Use semantic HTML
- Implement keyboard navigation
- Add ARIA labels where needed
- Test with screen readers
```

#### Skill Loading Locations

| Location | Scope | Tool |
|----------|-------|------|
| `.opencode/skills/*/SKILL.md` | Project | OpenCode, Oh-My-OpenCode |
| `~/.config/opencode/skills/*/SKILL.md` | User | OpenCode, Oh-My-OpenCode |
| `.claude/commands/*.md` | Project | Claude Code |
| `~/.claude/commands/*.md` | User | Claude Code |
| `.kata/skills/*.md` | Project | Kata |

#### Skill Interface

```typescript
interface Skill {
  // Metadata (from YAML frontmatter)
  name: string;
  description: string;
  triggers?: string[];       // Keywords that activate skill
  
  // Dependencies
  mcp?: Record<string, MCPServerConfig>;  // Embedded MCP servers
  tools?: string[];          // Required tools
  
  // Content
  instructions: string;      // Markdown body (loaded on-demand)
  
  // Loading
  loaded: boolean;           // Lazy loading flag
}

interface SkillRegistry {
  // Discovery
  discover(): Skill[];       // Find all skills in paths
  
  // Loading
  load(name: string): Promise<Skill>;  // Lazy load skill
  
  // Matching
  match(prompt: string): Skill[];      // Find relevant skills
  
  // Injection
  inject(skill: Skill, context: Context): Context;
}
```

---

### 4. Slash Commands

**Sources**: Claude Code, Oh-My-OpenCode, Kata, GSD

#### Command Types

| Type | Example | Description |
|------|---------|-------------|
| **Built-in** | `/help`, `/clear` | Core functionality |
| **Skill** | `/frontend-ui-ux` | Loads a skill |
| **Workflow** | `/kata:plan-phase 3` | Executes workflow step |
| **Custom** | `/my-command` | User-defined |

#### Command Interface

```typescript
interface SlashCommand {
  name: string;              // e.g., "kata:plan-phase"
  description: string;
  usage: string;             // e.g., "/kata:plan-phase <phase-number>"
  
  // Execution
  execute(args: string[], context: CommandContext): Promise<CommandResult>;
  
  // Validation
  validate?(args: string[]): ValidationResult;
  
  // Autocomplete
  complete?(partial: string): string[];
}

interface CommandRegistry {
  register(command: SlashCommand): void;
  execute(input: string): Promise<CommandResult>;
  list(): SlashCommand[];
  search(query: string): SlashCommand[];
}
```

#### Framework-Specific Commands

| Framework | Commands | Pattern |
|-----------|----------|---------|
| Claude Code | `/help`, `/clear`, `/config`, `/skill-name` | `/command` |
| Oh-My-OpenCode | `/ralph-loop`, `/ulw-loop`, `/refactor`, `/init-deep` | `/command` |
| Kata | `/kata:new-project`, `/kata:plan-phase N`, `/kata:execute-phase N` | `/kata:action` |
| GSD | `/gsd:new-project`, `/gsd:plan-phase N`, `/gsd:execute-phase N` | `/gsd:action` |

---

### 5. Plugin Architecture

**Sources**: Oh-My-OpenCode, OpenCode (partial)

#### Plugin Interface

```typescript
interface Plugin {
  // Metadata
  name: string;
  version: string;
  description: string;
  author: string;
  
  // Lifecycle
  activate(context: PluginContext): Promise<void>;
  deactivate(): Promise<void>;
  
  // Contributions
  contributes: {
    hooks?: Hook[];
    tools?: Tool[];
    skills?: Skill[];
    commands?: SlashCommand[];
    providers?: Provider[];
    agents?: AgentDefinition[];
  };
}

interface PluginContext {
  // Access to harness systems
  hooks: HookSystem;
  tools: ToolRegistry;
  skills: SkillRegistry;
  commands: CommandRegistry;
  memory: MemoryStore;
  
  // Plugin-specific storage
  storage: PluginStorage;
  
  // Logging
  logger: Logger;
}
```

#### Plugin Configuration

```json
// .opencode/plugins.json
{
  "plugins": [
    {
      "name": "@omc/visual-engineering",
      "enabled": true,
      "config": {
        "defaultFramework": "react",
        "cssFramework": "tailwind"
      }
    },
    {
      "name": "local:./plugins/custom-plugin",
      "enabled": true
    }
  ]
}
```

---

### 6. MCP/ACP Integration

**Sources**: Claude Code, OpenCode, Oh-My-OpenCode

#### MCP Server Configuration

```json
// .mcp.json or ~/.claude/settings.json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": "/home/user/projects"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "custom-api": {
      "transport": "http",
      "url": "http://localhost:3001/mcp"
    }
  }
}
```

#### MCP Interface

```typescript
interface MCPServer {
  name: string;
  transport: "stdio" | "http" | "sse";
  
  // Connection
  connect(): Promise<void>;
  disconnect(): Promise<void>;
  
  // Tool discovery
  listTools(): Promise<MCPTool[]>;
  
  // Tool execution
  callTool(name: string, args: unknown): Promise<MCPResult>;
  
  // Resources (optional)
  listResources?(): Promise<MCPResource[]>;
  readResource?(uri: string): Promise<MCPContent>;
}

interface MCPManager {
  // Server management
  add(name: string, config: MCPServerConfig): Promise<void>;
  remove(name: string): Promise<void>;
  list(): MCPServer[];
  
  // Tool aggregation
  getAllTools(): MCPTool[];
  callTool(serverName: string, toolName: string, args: unknown): Promise<MCPResult>;
}
```

#### ACP (Agent Client Protocol) - OpenCode

```typescript
// ACP extends MCP for agent-to-agent communication
interface ACPAgent {
  // Identity
  id: string;
  capabilities: string[];
  
  // Communication
  send(message: ACPMessage): Promise<ACPResponse>;
  subscribe(event: string, handler: ACPHandler): void;
  
  // Delegation
  delegate(task: Task): Promise<TaskResult>;
}
```

---

### 7. Provider System

**Sources**: OpenCode, Oh-My-OpenCode

#### Provider Interface

```typescript
interface Provider {
  // Identity
  readonly name: string;
  readonly models: Model[];
  
  // Capabilities
  readonly capabilities: {
    streaming: boolean;
    tools: boolean;
    vision: boolean;
    embeddings: boolean;
    maxContextWindow: number;
    extendedThinking?: boolean;
  };
  
  // Core operations
  chat(request: ChatRequest): AsyncIterator<ChatChunk>;
  embed(text: string | string[]): Promise<Embedding[]>;
  
  // Lifecycle
  initialize(): Promise<void>;
  shutdown(): Promise<void>;
  healthCheck(): Promise<HealthStatus>;
}
```

#### Supported Providers (OpenCode)

| Provider | Package | Models |
|----------|---------|--------|
| Anthropic | `@ai-sdk/anthropic` | Claude Opus, Sonnet, Haiku |
| OpenAI | `@ai-sdk/openai` | GPT-4o, GPT-5, o1 |
| Google | `@ai-sdk/google` | Gemini 1.5/2.0 |
| Azure | `@ai-sdk/azure` | Azure OpenAI |
| AWS Bedrock | `@ai-sdk/amazon-bedrock` | Claude, Titan |
| xAI | `@ai-sdk/xai` | Grok |
| Mistral | `@ai-sdk/mistral` | Mistral Large |
| Groq | `@ai-sdk/groq` | Llama, Mixtral |
| Together | `@ai-sdk/togetherai` | Open models |
| Local | `@ai-sdk/openai-compatible` | Ollama, LMStudio |

#### Custom Provider Registration

```typescript
class CustomProvider implements Provider {
  readonly name = "custom";
  readonly models = [
    { id: "custom-model", contextWindow: 100_000 }
  ];
  
  async *chat(request: ChatRequest): AsyncIterator<ChatChunk> {
    const response = await this.client.generate({
      prompt: this.formatMessages(request.messages),
      ...request
    });
    
    for await (const chunk of response.stream()) {
      yield this.convertChunk(chunk);
    }
  }
}

// Register
harness.providers.register(new CustomProvider());
```

---

### 8. Agent Definitions

**Sources**: Oh-My-OpenCode, Kata, GSD

#### Agent Interface

```typescript
interface AgentDefinition {
  // Identity
  id: string;
  name: string;
  description: string;
  
  // Model selection
  model?: {
    provider: string;
    modelId: string;
  };
  
  // Behavior
  systemPrompt: string;
  temperature?: number;
  topP?: number;
  
  // Restrictions
  permissions: PermissionRuleset;
  tools: ToolWhitelist;
  
  // Delegation (for orchestrators)
  canDelegate: boolean;
  delegationTargets?: string[];  // Agent IDs that can be delegated to
}

interface AgentRegistry {
  register(agent: AgentDefinition): void;
  get(id: string): AgentDefinition | undefined;
  list(filter?: AgentFilter): AgentDefinition[];
  spawn(id: string, context?: AgentContext): Promise<Agent>;
}
```

#### Agent Configuration (Oh-My-OpenCode Style)

```yaml
# .opencode/agents/oracle.yaml
id: oracle
name: Oracle
description: High-IQ consultant for architecture and debugging
model:
  provider: openai
  modelId: gpt-5.2
systemPrompt: |
  You are Oracle, a read-only consultation agent for:
  - Architecture decisions
  - Complex debugging
  - Security analysis
  
  You CANNOT modify files. You provide advice only.
temperature: 0.7
permissions:
  - pattern: "read_file *"
    action: allow
  - pattern: "write_file *"
    action: deny
  - pattern: "edit_file *"
    action: deny
  - pattern: "bash *"
    action: deny
canDelegate: false
```

#### Specialized Agent Examples

| Agent | Framework | Role | Restrictions |
|-------|-----------|------|--------------|
| `sisyphus` | Oh-My-OpenCode | Main orchestrator | Full access |
| `prometheus` | Oh-My-OpenCode | Strategic planner | READ-ONLY |
| `oracle` | Oh-My-OpenCode | Architecture consultant | READ-ONLY |
| `sisyphus-junior` | Oh-My-OpenCode | Task executor | Cannot delegate |
| `kata-planner` | Kata | Creates plans | Standard |
| `kata-executor` | Kata | Implements tasks | Fresh 200k |
| `gsd-researcher` | GSD | Domain research | WebFetch, Context7 |

---

### 9. Configuration System

**Sources**: All tools

#### Configuration Hierarchy

```
Project Config   >  User Config  >  System Config  >  Defaults
./.opencode/config.json
                    ~/.config/opencode/config.json
                                     /etc/opencode/config.json
                                                      (built-in)
```

#### Configuration Schema

```typescript
interface HarnessConfig {
  // Provider configuration
  providers: {
    [name: string]: ProviderConfig;
  };
  
  // Default selections
  defaultProvider: string;
  defaultModel: string;
  
  // Orchestration
  orchestration: {
    topology: Topology;
    maxAgents: number;
    strategy: "specialized" | "generalist" | "adaptive";
  };
  
  // Session
  session: {
    persistence: "memory" | "file" | "database";
    storagePath?: string;
    autoSave: boolean;
    autoSaveInterval: number;
  };
  
  // Approval
  approval: {
    mode: "ask" | "allow" | "deny";
    defaultPolicies: PolicyAmendment[];
  };
  
  // Tools
  tools: {
    enabled: string[];
    disabled: string[];
    mcpServers: MCPServerConfig[];
  };
  
  // Hooks
  hooks: {
    [event: string]: HookConfig[];
  };
  
  // Limits
  limits: {
    maxContextTokens: number;
    maxOutputTokens: number;
    maxToolCalls: number;
    timeout: number;
  };
  
  // Categories (Oh-My-OpenCode)
  categories?: {
    [name: string]: CategoryConfig;
  };
}
```

#### Configuration Validation

```typescript
interface ConfigValidator {
  validate(config: unknown): ValidationResult;
  merge(configs: Partial<HarnessConfig>[]): HarnessConfig;
  watch(path: string, callback: (config: HarnessConfig) => void): void;
}
```

---

### 10. Approval Policies

**Sources**: Codex, Claude Code, OpenCode

#### Policy Interface

```typescript
interface PolicyAmendment {
  pattern: string;           // Glob pattern, e.g., "rm -rf *"
  action: "allow" | "deny" | "ask";
  scope: "session" | "project" | "user" | "permanent";
  reason?: string;
  expires?: Date;
}

interface ApprovalSystem {
  // Policy management
  addPolicy(policy: PolicyAmendment): void;
  removePolicy(pattern: string): void;
  listPolicies(): PolicyAmendment[];
  
  // Decision making
  check(operation: Operation): ApprovalDecision;
  
  // Queue management (Codex style)
  enqueue(request: ApprovalRequest): void;
  dequeue(): ApprovalRequest | undefined;
  current(): ApprovalRequest | undefined;
}

interface ApprovalRequest {
  id: string;
  operation: Operation;
  risk: RiskLevel;
  context: string;
  timestamp: Date;
}
```

#### Approval Modes

| Mode | Claude Code | OpenCode | Behavior |
|------|-------------|----------|----------|
| `ask` | Default | Default | Always prompt user |
| `allow` | Auto-accept | - | Auto-approve matching |
| `deny` | - | - | Auto-reject matching |
| `trust` | Full autonomy | - | No approvals needed |

#### Policy Configuration

```yaml
# .opencode/policies.yaml
policies:
  # Allow all reads
  - pattern: "read_file *"
    action: allow
    scope: permanent
    
  # Ask for writes in src/
  - pattern: "write_file src/*"
    action: ask
    scope: project
    
  # Deny dangerous commands
  - pattern: "rm -rf /"
    action: deny
    scope: permanent
    reason: "Catastrophic data loss"
    
  # Session-specific
  - pattern: "npm install *"
    action: allow
    scope: session
```

---

### 11. Workflow System

**Sources**: Kata, GSD, Oh-My-OpenCode

#### Workflow Interface

```typescript
interface Workflow {
  id: string;
  name: string;
  description: string;
  
  // Phases
  phases: Phase[];
  
  // State
  currentPhase: number;
  status: WorkflowStatus;
  
  // Artifacts
  artifactDir: string;
  
  // Execution
  start(): Promise<void>;
  advance(): Promise<void>;
  rollback(): Promise<void>;
}

interface Phase {
  id: string;
  name: string;
  description: string;
  
  // Execution
  command: string;              // Slash command to execute
  agents: string[];             // Agents involved
  
  // Dependencies
  dependsOn?: string[];         // Phase IDs
  
  // Artifacts
  inputs: string[];             // Required artifacts
  outputs: string[];            // Produced artifacts
}
```

#### Workflow Types

| Type | Framework | Phases | Description |
|------|-----------|--------|-------------|
| 8-Phase | Kata | Init, Milestone, Discuss, Plan, Execute, Verify, Review, Complete | Spec-driven |
| 6-Step | GSD | New-project, Discuss, Plan, Execute, Verify, Complete | Context-engineered |
| Ralph Loop | Oh-My-OpenCode | Continuous | Self-referential until done |
| PARL | Kimi K2 | Dynamic | Reinforcement learning |

#### Workflow Configuration

```yaml
# .planning/config.json or .kata/config.json
{
  "workflow": {
    "type": "8-phase",
    "parallelExecution": true,
    "maxConcurrentAgents": 3,
    "modelProfile": "balanced"
  },
  "phases": {
    "plan": {
      "verificationLoops": 3,
      "agents": ["planner", "checker"]
    },
    "execute": {
      "waveExecution": true,
      "atomicCommits": true
    }
  }
}
```

---

### 12. Memory & State System

**Sources**: Oh-My-OpenCode, Kata, GSD, OpenCode

#### Memory Interface

```typescript
interface MemoryStore {
  // Key-value operations
  set(key: string, value: unknown, options?: StoreOptions): Promise<void>;
  get(key: string): Promise<unknown | undefined>;
  delete(key: string): Promise<void>;
  
  // Search (with embeddings)
  search(query: string, options?: SearchOptions): Promise<SearchResult[]>;
  
  // Namespaces
  namespace(name: string): MemoryStore;
  
  // Persistence
  persist(): Promise<void>;
  load(): Promise<void>;
}

interface StoreOptions {
  namespace?: string;
  ttl?: number;              // Time to live in seconds
  tags?: string[];           // For filtering
  embedding?: boolean;       // Generate embedding for search
}

interface SearchOptions {
  namespace?: string;
  limit?: number;
  threshold?: number;        // Similarity threshold
  tags?: string[];
}
```

#### Memory Types

| Type | Framework | Purpose | Location |
|------|-----------|---------|----------|
| Session | All | Conversation history | Memory |
| Artifacts | Kata, GSD | Planning documents | `.planning/` |
| Notepads | Oh-My-OpenCode | Accumulated wisdom | `.sisyphus/notepads/` |
| STATE.md | GSD | Living memory | `.planning/STATE.md` |
| Embeddings | Oh-My-OpenCode | Semantic search | `.opencode/memory/` |

#### Wisdom Accumulation (Oh-My-OpenCode)

```typescript
interface WisdomSystem {
  // Learning
  learn(task: Task, result: Result): Promise<void>;
  
  // Retrieval
  recall(context: string): Promise<WisdomEntry[]>;
  
  // Persistence
  export(): Promise<WisdomExport>;
  import(data: WisdomExport): Promise<void>;
}

interface WisdomEntry {
  pattern: string;           // What was learned
  context: string;           // When it applies
  confidence: number;        // Reliability (0-1)
  source: string;            // Where learned
  timestamp: Date;
  occurrences: number;       // Times observed
}
```

---

## See Also

- [BEST-PRACTICES.md](BEST-PRACTICES.md) - Combined best practices
- [Individual Tool Docs](README.md) - Tool-specific documentation
- [CONCEPTS.md](../CONCEPTS.md) - Core concepts
- [PATTERNS.md](../PATTERNS.md) - Implementation patterns

---

## Implementation Status

| Component | Status | Notes |
|-----------|--------|-------|
| Message Types | ✅ Defined | Universal protocol |
| Provider Interface | ✅ Defined | Multi-provider ready |
| Tool Registry | ✅ Defined | Extensible |
| Agent Loop | ✅ Defined | Core execution pattern |
| Orchestrators | ✅ Defined | Multiple topologies |
| Session Manager | ✅ Defined | Persistence ready |
| Configuration | ✅ Defined | YAML/JSON support |
| Hooks | ✅ Defined | Extension points |

This is a **reference architecture**. Implementation requires adapting to specific language/runtime requirements.
