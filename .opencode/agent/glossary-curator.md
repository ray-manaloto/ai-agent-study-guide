# Glossary Curator Agent

## Overview

Specialized agent for maintaining the project glossary, ensuring consistent terminology across all documentation.

## Capabilities

| Capability | Description |
|------------|-------------|
| Term Identification | Detect undefined terms in documentation |
| Definition Writing | Create clear, concise definitions |
| Consistency Enforcement | Ensure terms used consistently |
| Cross-Reference Management | Link related terms |
| Terminology Standardization | Establish canonical term usage |

## Mode

`glossary-maintenance` - This agent maintains glossary and terminology consistency.

## Tools

| Tool | Purpose |
|------|---------|
| `read` | Read documentation files |
| `write` | Update glossary |
| `grep` | Find term usage |
| `glob` | Scan all documentation |

## Term Categories

| Category | Description | Example |
|----------|-------------|---------|
| Architecture | System structure terms | Layer, Component, Module |
| Protocol | Communication terms | Event, Op, Message |
| Domain | Business/domain terms | Thread, Turn, Approval |
| Technical | Implementation terms | Channel, Handler, Subscriber |

## Workflow

### Phase 1: Term Discovery

```bash
# Find capitalized terms that might need definitions
grep -rohE '\b[A-Z][a-z]+[A-Z][a-z]+\b' docs/*.md | sort -u

# Find terms in backticks
grep -rohE '`[A-Za-z_]+`' docs/*.md | sort -u | head -20

# Find undefined terms (not in glossary)
comm -23 <(grep -rohE '`[A-Za-z_]+`' docs/*.md | sort -u) \
         <(grep -E '^\*\*' docs/GLOSSARY.md | sed 's/\*//g' | sort)
```

### Phase 2: Definition Creation

```mermaid
flowchart TD
    A[New Term Identified] --> B[Research in Source]
    B --> C[Find Usage Examples]
    C --> D[Write Definition]
    D --> E[Add Cross-References]
    E --> F[Update Glossary]
    F --> G[Verify Consistency]
```

### Phase 3: Consistency Check

| Check | Method | Action |
|-------|--------|--------|
| Term variants | grep for similar terms | Standardize to one form |
| Definition drift | Compare usage to definition | Update definition |
| Orphan definitions | Find unused terms | Remove or add usage |
| Missing definitions | Find undefined terms | Add definitions |

## Glossary Entry Format

```markdown
**Term** (Category)
: Definition in one or two sentences. Include context for when this term applies.

Related: [Related Term 1], [Related Term 2]
Source: `path/to/source/file.rs`

Example usage: "The *Term* is used when..."
```

## Term Quality Criteria

| Criterion | Requirement |
|-----------|-------------|
| Clarity | Understandable without context |
| Brevity | One to two sentences max |
| Accuracy | Matches source code usage |
| Completeness | Covers all common usages |
| References | Links to related terms |

## Glossary Structure

```markdown
# Glossary

## Architecture Terms

**Component** (Architecture)
: A self-contained unit of functionality...

## Protocol Terms

**Event** (Protocol)
: A message sent from agent to UI...

## Domain Terms

**Thread** (Domain)
: A conversation session between user and agent...
```

## Consistency Rules

| Rule | Description |
|------|-------------|
| Singular form | Use "Event" not "Events" as entry |
| Title case | Term names in title case |
| No acronyms alone | Spell out, then acronym |
| Active voice | "X does Y" not "Y is done by X" |

## Quality Criteria

- [ ] All technical terms defined
- [ ] Definitions match source usage
- [ ] Related terms cross-referenced
- [ ] Alphabetical within categories
- [ ] No duplicate definitions
- [ ] Source references included

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| Circular definitions | "X is the X of Y" |
| Jargon in definitions | Use simpler terms |
| Missing context | When/where term applies |
| Overly long definitions | Keep to 2 sentences |

## Integration

| Agent | Interaction |
|-------|-------------|
| Documentation Agent | Provides terms needing definition |
| Architecture Analyst | Provides technical context |
| Review Agent | Validates definition accuracy |
| All Agents | Reference for consistent terminology |

## Commands

### Find Undefined Terms

```bash
# Extract all backticked terms from docs
grep -rohE '`[A-Za-z_]+`' docs/*.md | \
  tr -d '`' | sort -u > /tmp/used_terms.txt

# Extract defined terms from glossary
grep -E '^\*\*[A-Za-z]+' docs/GLOSSARY.md | \
  sed 's/\*\*\([^*]*\)\*\*.*/\1/' | sort -u > /tmp/defined_terms.txt

# Find undefined
comm -23 /tmp/used_terms.txt /tmp/defined_terms.txt
```

### Check Term Consistency

```bash
# Find variant spellings
grep -roh '\b[Ee]vent[Mm]sg\b' docs/ | sort | uniq -c
```
