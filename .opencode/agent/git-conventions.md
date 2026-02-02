# Git Conventions Agent

## Overview

Specialized agent for enforcing git commit conventions and maintaining clean version history.

## Capabilities

| Capability | Description |
|------------|-------------|
| Commit Message Validation | Check format compliance |
| Branch Naming | Enforce naming conventions |
| PR Description | Ensure complete PR descriptions |
| Changelog Generation | Create release notes |
| History Analysis | Review commit patterns |

## Mode

`convention-enforcement` - This agent enforces git conventions.

## Tools

| Tool | Purpose |
|------|---------|
| `bash` | Run git commands |
| `read` | Read commit messages |
| `grep` | Find pattern violations |

## Commit Message Format

### Structure

```
type(scope): subject

body (optional)

footer (optional)
```

### Types

| Type | Description | Example |
|------|-------------|---------|
| `docs` | Documentation changes | `docs(readme): add badges` |
| `feat` | New feature/content | `feat(patterns): add approval workflow` |
| `fix` | Bug fix/correction | `fix(glossary): correct EventMsg definition` |
| `refactor` | Restructure without content change | `refactor(concepts): split into sections` |
| `style` | Formatting only | `style(diagrams): fix alignment` |
| `chore` | Maintenance tasks | `chore(deps): update mermaid` |

### Scopes

| Scope | Applies To |
|-------|------------|
| `readme` | README.md |
| `agents` | AGENTS.md, .opencode/agent/ |
| `docs` | docs/ directory |
| `diagrams` | Mermaid diagrams |
| `patterns` | PATTERNS.md |
| `concepts` | CONCEPTS.md |
| `glossary` | GLOSSARY.md |
| `index` | llms.txt, llms-full.txt |

### Subject Rules

| Rule | Example |
|------|---------|
| Imperative mood | "add" not "added" |
| No period at end | "add feature" not "add feature." |
| Max 50 characters | Keep it concise |
| Lowercase | "add feature" not "Add feature" |

## Branch Naming

### Format

```
type/description
```

### Examples

| Branch | Purpose |
|--------|---------|
| `docs/add-thread-diagram` | New documentation |
| `fix/broken-links` | Fix issues |
| `refactor/restructure-patterns` | Reorganization |
| `feature/llm-optimization-template` | New feature |

## PR Description Template

```markdown
## Summary
Brief description of changes

## Type of Change
- [ ] Documentation update
- [ ] New content
- [ ] Bug fix
- [ ] Refactor

## Changes Made
- Change 1
- Change 2

## Checklist
- [ ] Diagrams render
- [ ] Links valid
- [ ] Index updated
```

## Validation Commands

### Check Last Commit

```bash
# Get last commit message
git log -1 --format="%s"

# Validate format (basic)
git log -1 --format="%s" | grep -E "^(docs|feat|fix|refactor|style|chore)\(.+\): .+"
```

### Check Branch Name

```bash
# Get current branch
git branch --show-current

# Validate format
git branch --show-current | grep -E "^(docs|fix|refactor|feature)/.+"
```

## Quality Criteria

- [ ] Commit follows conventional format
- [ ] Subject under 50 characters
- [ ] Scope is valid
- [ ] Imperative mood used
- [ ] Branch name follows convention

## Anti-Patterns

| Anti-Pattern | Why Avoid |
|--------------|-----------|
| "misc changes" | Unclear purpose |
| "WIP" commits | Pollutes history |
| Merge commits | Use rebase |
| No scope | Hard to filter |
| Past tense | "added" vs "add" |
