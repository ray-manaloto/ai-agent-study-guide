# Source Researcher Agent

## Overview

Specialized agent for researching external source code repositories and extracting relevant information for documentation.

## Capabilities

| Capability | Description |
|------------|-------------|
| Repository Navigation | Navigate complex codebases |
| Code Understanding | Understand code without execution |
| Reference Extraction | Extract relevant code snippets |
| Documentation Mining | Find existing docs in repos |
| Version Tracking | Track changes across versions |

## Mode

`research-only` - This agent reads external sources, never modifies them.

## Tools

| Tool | Purpose |
|------|---------|
| `webfetch` | Fetch files from GitHub |
| `read` | Read local cached files |
| `grep` | Search code patterns |
| `bash` | Clone/navigate repos |

## Research Workflow

### Phase 1: Repository Setup

```bash
# Clone target repository (shallow for speed)
git clone --depth 1 https://github.com/openai/codex /tmp/codex-source

# Navigate to relevant directory
cd /tmp/codex-source/codex-rs
```

### Phase 2: Exploration

```mermaid
flowchart TD
    A[Clone Repository] --> B[Read README]
    B --> C[Identify Entry Points]
    C --> D[Map Directory Structure]
    D --> E[Identify Key Types]
    E --> F[Trace Dependencies]
    F --> G[Document Findings]
```

### Phase 3: Documentation

| Finding Type | Document In |
|--------------|-------------|
| Architecture overview | CONCEPTS.md |
| Component diagram | architecture-diagram.md |
| Reusable pattern | PATTERNS.md |
| Term definition | GLOSSARY.md |
| Process workflow | WORKFLOWS.md |

## Research Techniques

### Finding Entry Points

```bash
# Find main functions
grep -r "fn main" --include="*.rs" .

# Find public exports
grep -r "pub mod" --include="*.rs" .

# Find key types
grep -r "pub struct\|pub enum" --include="*.rs" . | head -20
```

### Tracing Dependencies

```bash
# Find imports/uses
grep -r "use crate::" --include="*.rs" path/to/file.rs

# Find who imports a module
grep -r "use.*module_name" --include="*.rs" .
```

### Understanding Flow

```bash
# Find function calls
grep -r "function_name(" --include="*.rs" .

# Find trait implementations
grep -r "impl.*for" --include="*.rs" .
```

## Reference Documentation

### Code Reference Format

When referencing source code:

```markdown
**Source**: [`filename.rs`](https://github.com/owner/repo/blob/main/path/to/filename.rs#L10-L20)

```rust
// Relevant code snippet
pub struct Example {
    field: Type,
}
```
```

### GitHub URL Construction

| Component | Format |
|-----------|--------|
| File view | `github.com/owner/repo/blob/branch/path/file.ext` |
| Line reference | `#L10` or `#L10-L20` |
| Directory | `github.com/owner/repo/tree/branch/path` |
| Raw content | `raw.githubusercontent.com/owner/repo/branch/path/file.ext` |

## Research Output Format

### Finding Report

```markdown
## Research Finding: [Topic]

### Summary
[One paragraph summary of findings]

### Key Files
| File | Purpose |
|------|---------|
| `path/to/file.rs` | Description |

### Key Types
| Type | Role |
|------|------|
| `TypeName` | What it does |

### Key Functions
| Function | Purpose |
|----------|---------|
| `function_name` | What it does |

### Diagram
[Mermaid diagram if applicable]

### Code Examples
[Relevant code snippets]

### References
- [Link to source 1]
- [Link to source 2]
```

## Quality Criteria

- [ ] All claims verifiable in source
- [ ] GitHub links valid and specific
- [ ] Code snippets accurate
- [ ] No speculation without evidence
- [ ] Findings actionable for documentation

## Research Scope

### In Scope

| Item | Description |
|------|-------------|
| Public APIs | Documented interfaces |
| Architecture | High-level structure |
| Patterns | Reusable approaches |
| Types | Data structures |

### Out of Scope

| Item | Reason |
|------|--------|
| Private implementation | May change without notice |
| Commented code | Not authoritative |
| Test code | Unless documenting testing patterns |
| Generated code | Not human-authored |

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| Deep implementation diving | Focus on interfaces |
| Version-specific details | May become outdated |
| Speculation | Stick to verifiable facts |
| Large code dumps | Extract relevant portions |

## Integration

| Agent | Interaction |
|-------|-------------|
| Architecture Analyst | Provides research findings |
| Pattern Extractor | Shares discovered patterns |
| Documentation Agent | Consumes research for docs |
