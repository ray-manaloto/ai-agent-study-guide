# AI Agent Workflows

> Step-by-step workflows for AI agents working on this repository

## Workflow 1: Add New Architecture Diagram

### When to Use
Adding a new Mermaid diagram to document a Codex-RS component or flow.

### Steps

1. **Research the component**
   ```bash
   # Check existing documentation first
   cat docs/architecture-diagram.md
   cat llms-full.txt
   ```

2. **Reference source code**
   - Open https://github.com/openai/codex/tree/main/codex-rs
   - Locate relevant source files
   - Extract key types and flows

3. **Create the diagram**
   ```markdown
   ## New Section Title
   
   ```mermaid
   sequenceDiagram
       participant A as Component A<br/>(path/to/file.rs)
       participant B as Component B
       A->>B: message
   ```
   ```

4. **Validate the diagram**
   ```bash
   mmdc -i docs/architecture-diagram.md -o /tmp/test.png
   # Check for errors in output
   ```

5. **Update indexes**
   - Add entry to `llms.txt`
   - Add details to `llms-full.txt`

6. **Verify changes**
   ```bash
   # View rendered output
   open docs/codex-architecture.html
   # Or terminal preview
   glow docs/architecture-diagram.md
   ```

### Quality Checklist
- [ ] Diagram renders without errors
- [ ] Includes source file paths in participant labels
- [ ] Uses consistent styling with existing diagrams
- [ ] llms.txt updated
- [ ] llms-full.txt updated

---

## Workflow 2: Update Existing Documentation

### When to Use
Modifying existing content in docs/ files.

### Steps

1. **Read current content**
   ```bash
   cat docs/[file].md
   ```

2. **Check for dependencies**
   - Does llms.txt reference this content?
   - Does llms-full.txt include this content?
   - Are there cross-references in other docs?

3. **Make changes**
   - Keep style consistent with existing content
   - Use tables for mappings
   - Include source links

4. **Update all indexes**
   ```bash
   # Check what needs updating
   grep -l "[changed content]" *.txt docs/*.md
   ```

5. **Validate**
   - Mermaid diagrams render
   - Links are valid
   - No broken references

### Quality Checklist
- [ ] Consistent with existing style
- [ ] All cross-references updated
- [ ] llms.txt reflects changes
- [ ] llms-full.txt reflects changes

---

## Workflow 3: Add New Concept Documentation

### When to Use
Documenting a new concept, pattern, or term.

### Steps

1. **Choose the right file**
   | Content Type | File |
   |--------------|------|
   | Communication pattern | docs/CONCEPTS.md |
   | Term definition | docs/GLOSSARY.md |
   | Reusable pattern | docs/PATTERNS.md |
   | Architecture flow | docs/architecture-diagram.md |

2. **Follow file conventions**
   - CONCEPTS.md: Problem → Solution → Benefits
   - GLOSSARY.md: Term → Definition (1-2 sentences)
   - PATTERNS.md: Problem → Solution → Code → Benefits

3. **Include source references**
   ```markdown
   Location: `codex-rs/path/to/file.rs`
   ```

4. **Update indexes**
   - Add to llms.txt documentation list
   - Add details to llms-full.txt

### Quality Checklist
- [ ] Added to correct file
- [ ] Follows file's existing format
- [ ] Includes source file reference
- [ ] Indexed in llms.txt
- [ ] Detailed in llms-full.txt

---

## Workflow 4: Verify Repository Integrity

### When to Use
Before committing changes or after major updates.

### Steps

1. **Check Mermaid diagrams**
   ```bash
   ./scripts/render-diagrams.sh
   ```

2. **Verify file structure**
   ```bash
   # Expected structure
   ls -la docs/
   # Should see: architecture-diagram.md, codex-architecture.html, 
   #             CONCEPTS.md, GLOSSARY.md, PATTERNS.md, WORKFLOWS.md
   ```

3. **Check index completeness**
   ```bash
   # All docs should be in llms.txt
   head -50 llms.txt
   ```

4. **Validate links**
   ```bash
   # Check for broken GitHub links
   grep -r "github.com/openai/codex" docs/ | head -20
   ```

### Quality Checklist
- [ ] All Mermaid diagrams render
- [ ] File structure matches expected
- [ ] llms.txt indexes all docs
- [ ] llms-full.txt is comprehensive
- [ ] No broken links

---

## Workflow 5: Research Codex-RS Source

### When to Use
Need to understand or document a Codex-RS component.

### Steps

1. **Clone Codex repository** (if not already)
   ```bash
   git clone https://github.com/openai/codex.git /tmp/codex
   ```

2. **Locate component**
   ```bash
   # Find by name
   find /tmp/codex/codex-rs -name "*.rs" | xargs grep -l "ComponentName"
   
   # Or browse structure
   ls /tmp/codex/codex-rs/*/src/
   ```

3. **Extract key types**
   ```bash
   # Find struct/enum definitions
   grep -A 20 "pub struct\|pub enum" /tmp/codex/codex-rs/path/to/file.rs
   ```

4. **Document findings**
   - Add to appropriate docs/ file
   - Include file path in documentation
   - Link to GitHub for full source

### Key Directories

| Directory | Contains |
|-----------|----------|
| `codex-rs/tui/src/` | UI components, App, widgets |
| `codex-rs/core/src/` | Agent, threads, execution |
| `codex-rs/protocol/src/` | Op, EventMsg, Event types |
| `codex-rs/app-server/src/` | JSON-RPC, external clients |

---

## Common Mistakes to Avoid

| Mistake | Correct Approach |
|---------|------------------|
| Creating implementation code | This is documentation only |
| Modifying HTML directly | Regenerate from Mermaid source |
| Forgetting to update llms.txt | Always update after doc changes |
| Using outdated Codex-RS info | Verify against current source |
| Verbose documentation | Keep concise, use tables |
