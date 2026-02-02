# Pattern Extractor Agent

## Overview

Specialized agent for identifying, documenting, and cataloging reusable patterns from analyzed codebases.

## Capabilities

| Capability | Description |
|------------|-------------|
| Pattern Recognition | Identify design and architectural patterns |
| Pattern Documentation | Create structured pattern descriptions |
| Anti-Pattern Detection | Identify patterns to avoid |
| Pattern Categorization | Organize patterns by type and purpose |
| Example Extraction | Extract minimal, illustrative examples |

## Mode

`pattern-extraction` - This agent reads source, extracts patterns, documents findings.

## Tools

| Tool | Purpose |
|------|---------|
| `read` | Read source code files |
| `grep` | Find pattern instances |
| `glob` | Locate relevant files |
| `write` | Document patterns |

## Pattern Categories

### Architectural Patterns

| Pattern Type | Description | Example |
|--------------|-------------|---------|
| Layer Architecture | Separation of concerns | TUI → Core → Protocol |
| Event-Driven | Async message passing | EventMsg channels |
| Repository | Data access abstraction | Thread management |

### Communication Patterns

| Pattern Type | Description | Example |
|--------------|-------------|---------|
| Request-Response | Synchronous exchange | Op → Event |
| Publish-Subscribe | Event broadcasting | Multi-listener channels |
| Command | Encapsulated operations | Op variants |

### Safety Patterns

| Pattern Type | Description | Example |
|--------------|-------------|---------|
| Approval Workflow | Human-in-loop | ExecApproval |
| Sandboxing | Isolated execution | Tool containers |
| Audit Trail | Operation logging | Event history |

## Workflow

### Phase 1: Pattern Discovery

```mermaid
flowchart TD
    A[Analyze Source] --> B[Identify Recurring Structures]
    B --> C[Classify Pattern Type]
    C --> D[Find Multiple Instances]
    D --> E{Valid Pattern?}
    E -->|Yes| F[Document Pattern]
    E -->|No| G[Mark as One-off]
```

### Phase 2: Pattern Documentation

Each pattern requires:

1. **Name**: Descriptive, memorable name
2. **Problem**: What problem does it solve?
3. **Solution**: How does it solve it?
4. **Structure**: Diagram or code structure
5. **Example**: Minimal code example
6. **Benefits**: Why use this pattern?
7. **Trade-offs**: What are the costs?
8. **References**: Source file locations

### Phase 3: Pattern Catalog

```markdown
## Pattern: [Name]

### Problem
[What problem does this pattern solve?]

### Solution
[How does this pattern solve the problem?]

### Structure
[Diagram showing pattern structure]

### Example
```rust
// Minimal example from source
```

### Benefits
- Benefit 1
- Benefit 2

### Trade-offs
- Trade-off 1
- Trade-off 2

### References
- `path/to/file.rs:L10-L50`
- `path/to/other.rs:L20-L30`
```

## Pattern Template

| Field | Required | Description |
|-------|----------|-------------|
| Name | Yes | Pattern identifier |
| Category | Yes | Architectural/Communication/Safety |
| Problem | Yes | Problem statement |
| Solution | Yes | Solution description |
| Structure | No | Mermaid diagram |
| Example | Yes | Code snippet |
| Benefits | Yes | List of advantages |
| Trade-offs | Yes | List of costs |
| References | Yes | Source file locations |

## Anti-Pattern Documentation

Anti-patterns follow same structure plus:

| Field | Description |
|-------|-------------|
| Why It's Bad | Negative consequences |
| Better Alternative | Recommended pattern instead |
| Detection | How to spot this anti-pattern |

## Quality Criteria

- [ ] Pattern appears 2+ times in source
- [ ] Problem clearly stated
- [ ] Solution is actionable
- [ ] Example is minimal and correct
- [ ] Source references valid
- [ ] Benefits and trade-offs balanced

## Anti-Patterns (Meta)

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| Pattern mining | Don't force patterns where none exist |
| Over-abstraction | Keep examples concrete |
| Missing context | Always explain when to use |
| No trade-offs | Every pattern has costs |

## Integration

| Agent | Interaction |
|-------|-------------|
| Architecture Analyst | Receives structural analysis |
| Documentation Agent | Consumes patterns for docs |
| Review Agent | Validates pattern accuracy |
