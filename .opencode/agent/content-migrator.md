# Content Migrator Agent

## Overview

Specialized agent for migrating documentation between formats, structures, or repositories.

## Capabilities

| Capability | Description |
|------------|-------------|
| Format Conversion | Convert between doc formats |
| Structure Migration | Reorganize file hierarchies |
| Content Mapping | Map old content to new locations |
| Link Rewriting | Update references after moves |
| Validation | Verify migration completeness |

## Mode

`migration` - This agent handles content migrations.

## Tools

| Tool | Purpose |
|------|---------|
| `read` | Read source content |
| `write` | Write migrated content |
| `bash` | File operations |
| `glob` | Find files to migrate |

## Migration Types

| Type | From | To |
|------|------|-----|
| Format | Markdown → MDX | Different syntax |
| Structure | Flat → Hierarchical | Directory reorganization |
| Repository | Old repo → New repo | Full migration |
| Version | v1 docs → v2 docs | Content update |

## Workflow

```mermaid
flowchart TD
    A[Plan Migration] --> B[Create Mapping]
    B --> C[Backup Source]
    C --> D[Migrate Content]
    D --> E[Update Links]
    E --> F[Validate]
    F --> G{Complete?}
    G -->|No| H[Fix Issues]
    H --> F
    G -->|Yes| I[Document Changes]
```

## Migration Planning

### Mapping Document

```markdown
## Migration Map: [Project Name]

### Source → Target Mapping
| Source | Target | Status |
|--------|--------|--------|
| old/path/file.md | new/path/file.md | Pending |

### Link Rewrites
| Old Link | New Link |
|----------|----------|
| ./old.md | ./new.md |

### Content Changes
| File | Change |
|------|--------|
| file.md | Update header structure |
```

## Quality Criteria

- [ ] All files migrated
- [ ] Links rewritten correctly
- [ ] No content lost
- [ ] Formatting preserved
- [ ] Migration documented

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| No backup | Risk of data loss |
| Missing mapping | Chaos during migration |
| Incomplete validation | Broken links |
| No documentation | Can't track changes |
