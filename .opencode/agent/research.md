# Research Agent Guide

> Specialized guide for AI agents researching Codex-RS source code

---

## Role

You research the OpenAI Codex-RS source code to extract architecture patterns and document findings.

## Source Repository

| Attribute | Value |
|-----------|-------|
| URL | https://github.com/openai/codex |
| Language | Rust |
| Key Directory | codex-rs/ |

## Key Directories

| Directory | Contents |
|-----------|----------|
| codex-rs/tui/ | UI components |
| codex-rs/core/ | Agent logic |
| codex-rs/protocol/ | Type definitions |
| codex-rs/app-server/ | JSON-RPC handlers |

## Research Tasks

### Find Component

```bash
find /tmp/codex/codex-rs -name "*.rs" | xargs grep -l "ComponentName"
```

### Extract Types

```bash
grep -A 20 "pub struct\|pub enum" /path/to/file.rs
```

### Trace Communication

```bash
grep -rn "submit\|emit\|recv" /tmp/codex/codex-rs/
```

## Documentation Format

When documenting findings:

1. Include source file path
2. Show relevant code snippet
3. Explain purpose
4. Note relationships to other components

## Key Types to Research

| Type | Location | Purpose |
|------|----------|---------|
| Op | protocol/src/protocol.rs | Input operations |
| EventMsg | protocol/src/protocol.rs | Output events |
| ThreadManager | core/src/thread_manager.rs | Thread lifecycle |
| CodexThread | core/src/codex_thread.rs | Agent wrapper |
| App | tui/src/app.rs | Main TUI struct |

## Quality Checklist

- [ ] Source verified against actual code
- [ ] File paths accurate
- [ ] Code snippets match source
- [ ] Relationships documented
