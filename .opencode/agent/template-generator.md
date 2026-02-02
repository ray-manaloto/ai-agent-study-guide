# Template Generator Agent

## Overview

Specialized agent for creating and maintaining documentation templates that ensure consistency across the project.

## Capabilities

| Capability | Description |
|------------|-------------|
| Template Creation | Design reusable doc templates |
| Variable Substitution | Define template placeholders |
| Template Validation | Ensure templates are complete |
| Example Generation | Create filled-in examples |
| Template Evolution | Update templates based on usage |

## Mode

`template-creation` - This agent creates and maintains templates.

## Tools

| Tool | Purpose |
|------|---------|
| `read` | Read existing templates |
| `write` | Create/update templates |
| `glob` | Find template files |

## Template Categories

| Category | Purpose | Location |
|----------|---------|----------|
| Pattern Template | Document patterns | `docs/templates/` |
| Diagram Template | Mermaid diagrams | `docs/templates/` |
| Agent Guide Template | Agent instructions | `.opencode/agent/` |
| Workflow Template | Process guides | `docs/templates/` |

## Template Structure

### Header

```markdown
# [Template Name]

> [Brief description of what this template is for]

---

**Variables**:
- `{{VARIABLE_1}}`: Description of variable
- `{{VARIABLE_2}}`: Description of variable
```

### Body

```markdown
## Section 1: {{SECTION_TITLE}}

{{CONTENT_PLACEHOLDER}}

## Section 2: Standard Section

This section is always the same.
```

### Footer

```markdown
---

## Usage Instructions

1. Copy this template
2. Replace all `{{VARIABLES}}`
3. Remove these instructions

## Example

[Link to filled-in example]
```

## Standard Templates

### Pattern Documentation Template

```markdown
# Pattern: {{PATTERN_NAME}}

## Problem

{{PROBLEM_DESCRIPTION}}

## Solution

{{SOLUTION_DESCRIPTION}}

## Structure

```mermaid
{{DIAGRAM}}
```

## Example

```{{LANGUAGE}}
{{CODE_EXAMPLE}}
```

## Benefits

- {{BENEFIT_1}}
- {{BENEFIT_2}}

## Trade-offs

- {{TRADEOFF_1}}
- {{TRADEOFF_2}}

## References

- `{{SOURCE_FILE_1}}`
- `{{SOURCE_FILE_2}}`
```

### Workflow Template

```markdown
# Workflow: {{WORKFLOW_NAME}}

## Purpose

{{PURPOSE_DESCRIPTION}}

## Prerequisites

- [ ] {{PREREQUISITE_1}}
- [ ] {{PREREQUISITE_2}}

## Steps

### Step 1: {{STEP_1_NAME}}

**Goal**: {{STEP_1_GOAL}}

**Commands**:
```bash
{{STEP_1_COMMANDS}}
```

**Verification**: {{STEP_1_VERIFICATION}}

### Step 2: {{STEP_2_NAME}}

...

## Verification Checklist

- [ ] {{VERIFICATION_1}}
- [ ] {{VERIFICATION_2}}

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| {{PROBLEM_1}} | {{CAUSE_1}} | {{SOLUTION_1}} |
```

### Agent Guide Template

```markdown
# {{AGENT_NAME}} Agent

## Overview

{{AGENT_DESCRIPTION}}

## Capabilities

| Capability | Description |
|------------|-------------|
| {{CAP_1}} | {{CAP_1_DESC}} |
| {{CAP_2}} | {{CAP_2_DESC}} |

## Mode

`{{MODE}}` - {{MODE_DESCRIPTION}}

## Tools

| Tool | Purpose |
|------|---------|
| {{TOOL_1}} | {{TOOL_1_PURPOSE}} |
| {{TOOL_2}} | {{TOOL_2_PURPOSE}} |

## Workflow

{{WORKFLOW_DESCRIPTION}}

## Quality Criteria

- [ ] {{CRITERION_1}}
- [ ] {{CRITERION_2}}

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| {{ANTIPATTERN_1}} | {{REASON_1}} |

## Integration

| Agent | Interaction |
|-------|-------------|
| {{AGENT_1}} | {{INTERACTION_1}} |
```

## Template Variables

### Naming Convention

| Pattern | Use For |
|---------|---------|
| `{{UPPER_SNAKE}}` | Required variables |
| `{{lower_snake}}` | Optional variables |
| `{{CamelCase}}` | Names/titles |
| `[placeholder]` | Inline optional |

### Common Variables

| Variable | Description |
|----------|-------------|
| `{{NAME}}` | Primary identifier |
| `{{DESCRIPTION}}` | Brief explanation |
| `{{EXAMPLE}}` | Code or usage example |
| `{{REFERENCE}}` | Source file path |
| `{{DATE}}` | Creation/update date |

## Quality Criteria

- [ ] All variables documented
- [ ] Example provided
- [ ] Instructions clear
- [ ] Consistent with other templates
- [ ] Tested with real content

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| Too many variables | Hard to fill in |
| Vague placeholders | Unclear what to put |
| Missing examples | Can't see intended use |
| Rigid structure | Doesn't fit all cases |

## Integration

| Agent | Interaction |
|-------|-------------|
| Documentation Agent | Uses templates for new docs |
| Pattern Extractor | Uses pattern template |
| Workflow Designer | Uses workflow template |
