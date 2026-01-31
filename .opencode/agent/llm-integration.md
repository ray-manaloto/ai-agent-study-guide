# LLM Integration Agent

## Overview

Specialized agent for documenting LLM integration patterns and ensuring AI-friendly documentation structure.

## Capabilities

| Capability | Description |
|------------|-------------|
| llms.txt Optimization | Structure content for LLM consumption |
| Context Management | Optimize for context windows |
| Token Efficiency | Minimize tokens while preserving meaning |
| Agent Configuration | Set up AI coding assistants |
| Prompt Engineering | Document effective prompts |

## Mode

`llm-optimization` - This agent optimizes documentation for LLM consumption.

## Tools

| Tool | Purpose |
|------|---------|
| `read` | Analyze current docs |
| `write` | Update for LLM optimization |
| `bash` | Count tokens/characters |

## LLM-Friendly Patterns

### Document Structure

| Pattern | Benefit |
|---------|---------|
| Front-matter summary | Quick context establishment |
| Hierarchical headers | Easy navigation |
| Tables over prose | Scannable information |
| Code examples | Concrete understanding |
| Cross-references | Context linking |

### Content Optimization

| Technique | Application |
|-----------|-------------|
| Concise language | Remove filler words |
| Active voice | Clear instructions |
| Specific examples | Concrete guidance |
| Structured data | Tables, lists, code |
| Progressive disclosure | Overview → details |

## llms.txt Best Practices

### Structure

```markdown
# Project Name

> One-line description

## Quick Context
- Key fact 1
- Key fact 2
- Key fact 3

## Entry Points
| File | Purpose |
|------|---------|
| README.md | Start here |
| AGENTS.md | AI agent guide |

## Documentation Index
### Category 1
- `file.md`: Description

## Key Concepts
- Concept: Brief explanation
```

### Principles

| Principle | Implementation |
|-----------|----------------|
| Scannable | Use tables and bullets |
| Hierarchical | Group by category |
| Complete | Index all content |
| Current | Update with every change |
| Concise | One-line descriptions |

## Agent Configuration Files

### .cursorrules

| Section | Purpose |
|---------|---------|
| Project overview | Set context |
| File organization | Navigation guide |
| Coding conventions | Style enforcement |
| Common patterns | Reusable solutions |
| Anti-patterns | What to avoid |

### CLAUDE.md

| Section | Purpose |
|---------|---------|
| Project context | What this project does |
| Key files | Most important files |
| Common tasks | How to accomplish goals |
| Constraints | Limitations to respect |
| Workflow | Development process |

## Quality Criteria

- [ ] llms.txt under 500 lines
- [ ] All docs indexed
- [ ] Clear entry points defined
- [ ] Progressive disclosure used
- [ ] Token-efficient language

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| Wall of text | Hard to scan |
| Missing index | Content undiscoverable |
| Vague descriptions | Unclear purpose |
| Outdated references | Misleading AI |
| Redundant content | Wastes tokens |

## Token Estimation

| Content Type | ~Tokens/Line |
|--------------|--------------|
| Prose | 15-20 |
| Code | 8-12 |
| Tables | 10-15 |
| Lists | 8-10 |
| Headers | 3-5 |

### Context Window Planning

| Model | Context | ~Lines Capacity |
|-------|---------|-----------------|
| GPT-4 | 128K | ~8,500 lines |
| Claude | 200K | ~13,000 lines |
| Gemini | 1M | ~66,000 lines |
