# Implementation Guide

> AI Agent Study Guide - How-to guides for working with this repository

---

## Overview

This guide provides step-by-step instructions for common tasks in this documentation repository.

**Important**: This is a documentation-only repository. No implementation code should be created.

---

## Quick Start

### Prerequisites

| Tool | Purpose | Installation |
|------|---------|--------------|
| glow | Markdown preview | `brew install glow` |
| mermaid-cli | Diagram validation | `npm install -g @mermaid-js/mermaid-cli` |
| git | Version control | Pre-installed on macOS |

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/ray-manaloto/ai-agent-study-guide.git
cd ai-agent-study-guide

# Verify setup
ls -la docs/
./scripts/render-diagrams.sh
```

### First Steps

1. Read `AGENTS.md` for orientation
2. Browse `llms.txt` for content index
3. View diagrams: `open docs/codex-architecture.html`
4. Preview docs: `glow docs/architecture-diagram.md`

---

## How to Add Documentation

### Adding a New Mermaid Diagram

**When**: Documenting a new Codex-RS component or communication flow.

**Steps**:

1. **Research the component**
   ```bash
   # Clone Codex-RS source (if not already)
   git clone https://github.com/openai/codex.git /tmp/codex
   
   # Find relevant files
   find /tmp/codex/codex-rs -name "*.rs" | xargs grep -l "ComponentName"
   ```

2. **Study the source code**
   ```bash
   # Read the file
   cat /tmp/codex/codex-rs/path/to/file.rs
   
   # Find key types
   grep -A 20 "pub struct\|pub enum" /tmp/codex/codex-rs/path/to/file.rs
   ```

3. **Create the diagram**
   
   Open `docs/architecture-diagram.md` and add:
   ```markdown
   ## New Component Flow
   
   ```mermaid
   sequenceDiagram
       participant A as ComponentA<br/>(path/to/a.rs)
       participant B as ComponentB<br/>(path/to/b.rs)
       
       A->>B: method_call()
       B-->>A: return value
   ```
   ```

4. **Validate the diagram**
   ```bash
   ./scripts/render-diagrams.sh
   ```

5. **Update indexes**
   - Add reference to `llms.txt`
   - Add details to `llms-full.txt`

6. **Verify**
   ```bash
   glow docs/architecture-diagram.md
   open docs/codex-architecture.html
   ```

### Adding a New Concept

**When**: Documenting a communication pattern, safety mechanism, or architectural concept.

**Steps**:

1. **Choose the correct file**
   
   | Content Type | Target File |
   |--------------|-------------|
   | Communication pattern | `docs/CONCEPTS.md` |
   | Reusable code pattern | `docs/PATTERNS.md` |
   | Term definition | `docs/GLOSSARY.md` |
   | Architecture component | `docs/architecture-diagram.md` |

2. **Follow the file's format**
   
   For `CONCEPTS.md`:
   ```markdown
   ## Concept Name
   
   ### Problem
   What problem does this concept address?
   
   ### Solution
   How does Codex-RS solve it?
   
   **Source**: `codex-rs/path/to/file.rs`
   
   ### Benefits
   - Benefit 1
   - Benefit 2
   ```

3. **Include source references**
   ```markdown
   **Location**: `codex-rs/protocol/src/protocol.rs`
   **Source**: [GitHub](https://github.com/openai/codex/blob/main/codex-rs/protocol/src/protocol.rs)
   ```

4. **Update indexes**

5. **Verify consistency** with existing content

### Adding a New Pattern

**When**: Documenting a reusable implementation pattern from Codex-RS.

**Steps**:

1. **Open `docs/PATTERNS.md`**

2. **Follow the pattern template**
   ```markdown
   ## Pattern N: Pattern Name
   
   ### Problem
   What problem does this pattern solve?
   
   ### Solution
   ```rust
   // codex-rs/path/to/file.rs
   pub struct ExampleStruct {
       field: Type,
   }
   
   impl ExampleStruct {
       pub fn method(&self) -> Result {
           // Implementation
       }
   }
   ```
   
   ### Benefits
   - Benefit 1
   - Benefit 2
   
   ### Anti-Pattern
   What to avoid and why.
   ```

3. **Verify code against source**
   ```bash
   # Ensure code matches actual Codex-RS source
   grep -A 30 "pub struct ExampleStruct" /tmp/codex/codex-rs/path/to/file.rs
   ```

4. **Update indexes**

---

## How to Update Documentation

### Updating Existing Content

**Steps**:

1. **Read current content**
   ```bash
   cat docs/[file].md
   ```

2. **Check for cross-references**
   ```bash
   grep -l "[topic]" *.txt docs/*.md
   ```

3. **Make changes**
   - Maintain existing style
   - Use tables for structured data
   - Include source references

4. **Update all cross-references**
   - `llms.txt`
   - `llms-full.txt`
   - Any files that reference updated content

5. **Verify**
   ```bash
   glow docs/[file].md
   ```

### Updating the Index (llms.txt)

**When**: After any documentation change.

**Steps**:

1. **Open `llms.txt`**

2. **Find the relevant section**

3. **Update or add entry**
   ```
   ## Section Name
   
   - [file.md](docs/file.md): Brief description
   ```

4. **Ensure accuracy** of all descriptions

### Updating llms-full.txt

**When**: After significant documentation changes.

**Steps**:

1. **Open `llms-full.txt`**

2. **Add detailed content** from new documentation

3. **Maintain consistent structure**

---

## How to Verify Documentation

### Full Verification Checklist

```bash
# 1. Validate Mermaid diagrams
./scripts/render-diagrams.sh

# 2. Check file structure
ls -la docs/

# 3. Preview main documentation
glow docs/architecture-diagram.md
glow docs/CONCEPTS.md
glow docs/PATTERNS.md

# 4. View rendered diagrams
open docs/codex-architecture.html

# 5. Check index completeness
head -100 llms.txt

# 6. Search for TODOs
grep -r "TODO" docs/

# 7. Validate GitHub links
grep -r "github.com/openai/codex" docs/ | head -20
```

### Pre-Commit Verification

Before committing:

- [ ] Mermaid diagrams render without errors
- [ ] Source file paths included in code blocks
- [ ] GitHub links are valid
- [ ] `llms.txt` updated
- [ ] `llms-full.txt` updated (if needed)
- [ ] Consistent with existing style
- [ ] No implementation code created

---

## How to Research Codex-RS

### Setting Up Source Access

```bash
# Clone Codex-RS repository
git clone https://github.com/openai/codex.git /tmp/codex

# Navigate to Rust implementation
cd /tmp/codex/codex-rs

# Explore structure
ls -la */src/
```

### Finding Components

```bash
# Find by name
find /tmp/codex/codex-rs -name "*.rs" | xargs grep -l "ComponentName"

# Find struct/enum definitions
grep -rn "pub struct\|pub enum" /tmp/codex/codex-rs/

# Find implementations
grep -A 50 "impl ComponentName" /tmp/codex/codex-rs/path/to/file.rs
```

### Understanding Communication

```bash
# Find channel usage
grep -rn "Sender\|Receiver\|channel" /tmp/codex/codex-rs/

# Find event emissions
grep -rn "emit\|Event\|EventMsg" /tmp/codex/codex-rs/

# Find operation handling
grep -rn "Op::\|submit\|handle" /tmp/codex/codex-rs/
```

### Key Directories

| Directory | Contents |
|-----------|----------|
| `codex-rs/tui/src/` | UI components |
| `codex-rs/core/src/` | Agent logic |
| `codex-rs/protocol/src/` | Type definitions |
| `codex-rs/app-server/src/` | JSON-RPC handlers |

---

## How to Use Templates

### For LLM-Optimizing Other Projects

1. **Copy the template**
   ```bash
   cp docs/templates/LLM-OPTIMIZATION-TEMPLATE.md /path/to/target/project/
   ```

2. **Follow the template instructions**
   - Create AGENTS.md
   - Create llms.txt
   - Add .cursorrules
   - Document key patterns

3. **Customize for project specifics**

### Using the Agent Skill

1. **Install the skill** (if using compatible tool)
   ```bash
   npx skills install docs/templates/llm-project-optimization/SKILL.md
   ```

2. **Apply to target project**

---

## How to Handle Common Scenarios

### Scenario: Conflicting Information

**Problem**: Existing documentation conflicts with Codex-RS source.

**Solution**:
1. Verify against current source
2. Update documentation to match source
3. Note the correction in commit message
4. Update all cross-references

### Scenario: Unclear Architecture

**Problem**: Unclear how components interact.

**Solution**:
1. Read source code directly
2. Trace function calls
3. Look for channel usage
4. Document findings with diagram

### Scenario: Missing Context

**Problem**: Documentation lacks context for understanding.

**Solution**:
1. Add "Why this matters" section
2. Include comparison with alternatives
3. Link to related concepts

### Scenario: Broken Mermaid Diagram

**Problem**: Diagram won't render.

**Solution**:
1. Check syntax at https://mermaid.live/
2. Ensure proper indentation
3. Verify participant names are valid
4. Run `./scripts/render-diagrams.sh` for details

---

## Troubleshooting

### Mermaid Validation Fails

```bash
# Get detailed error
mmdc -i docs/architecture-diagram.md -o /tmp/test.png 2>&1

# Common issues:
# - Invalid syntax in diagram
# - Unescaped special characters
# - Missing closing tags
```

### glow Not Rendering

```bash
# Check installation
which glow

# Reinstall if needed
brew reinstall glow
```

### Links Not Working

```bash
# Check relative paths
ls -la docs/

# Verify file exists
test -f docs/[file].md && echo "exists" || echo "missing"
```

---

## Best Practices

### Documentation Style

| Practice | Example |
|----------|---------|
| Use tables | Mappings, comparisons |
| Use code blocks | All code with file paths |
| Use diagrams | Communication flows |
| Be concise | No filler words |
| Cite sources | GitHub links |

### Commit Messages

```
docs: add ThreadManager communication diagram

- Added sequence diagram for TUI ↔ ThreadManager flow
- Updated llms.txt with new content reference
- Verified against codex-rs/core/src/thread_manager.rs
```

### File Naming

| Type | Convention | Example |
|------|------------|---------|
| Core docs | SCREAMING_SNAKE.md | CONCEPTS.md |
| Technical | kebab-case.md | architecture-diagram.md |
| Config | Lowercase with dot | .cursorrules |

---

## Resources

| Resource | URL |
|----------|-----|
| Codex-RS Source | https://github.com/openai/codex |
| Mermaid Live Editor | https://mermaid.live/ |
| Mermaid Documentation | https://mermaid.js.org/ |
| glow Documentation | https://github.com/charmbracelet/glow |
| llms.txt Standard | https://llmstxt.org/ |
