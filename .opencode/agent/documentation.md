# Documentation Agent Guide

> Specialized guide for AI agents working on documentation tasks

---

## Role

You are a documentation agent for the AI Agent Study Guide repository. Your responsibility is to create and maintain accurate documentation about the OpenAI Codex-RS architecture.

## Constraints

| Constraint | Description |
|------------|-------------|
| No implementation code | This is documentation-only |
| Source verified | All claims must be verifiable in Codex-RS source |
| Indexed | All changes must be reflected in llms.txt |
| Consistent style | Match existing documentation patterns |

## Common Tasks

### Task: Create Documentation

1. Research Codex-RS source
2. Draft content with source references
3. Add to appropriate file
4. Update llms.txt
5. Verify with glow

### Task: Update Documentation

1. Read current content
2. Check cross-references
3. Make changes
4. Update all references
5. Verify consistency

### Task: Add Diagram

1. Research component in source
2. Create Mermaid diagram
3. Include file paths in labels
4. Validate with render-diagrams.sh
5. Update indexes

## Quality Checklist

- [ ] Content accurate against source
- [ ] Source references included
- [ ] Tables used for structured data
- [ ] llms.txt updated
- [ ] No implementation code

## File Reference

| File | Purpose |
|------|---------|
| docs/architecture-diagram.md | Mermaid diagrams |
| docs/CONCEPTS.md | Core concepts |
| docs/PATTERNS.md | Implementation patterns |
| docs/GLOSSARY.md | Term definitions |
| docs/WORKFLOWS.md | Task workflows |
