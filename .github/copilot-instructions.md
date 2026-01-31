# GitHub Copilot Instructions

## Project Context
Documentation repository studying OpenAI Codex-RS AI agent architecture. No implementation code.

## Primary Tasks
1. Add/update Mermaid diagrams in `docs/`
2. Write concise, LLM-optimized documentation
3. Maintain `llms.txt` and `llms-full.txt` indexes

## Code Patterns
- Mermaid for all diagrams
- Rust code snippets for type examples
- Tables for component mappings
- Links to GitHub source files

## Key Architecture Fact
TUI communicates directly with ThreadManager via channels, NOT through MessageProcessor.

## File Restrictions
- DO modify: `docs/*.md`, `*.txt`, `README.md`
- DO NOT modify: `docs/codex-architecture.html` (generated)
- DO NOT create: Implementation code, new dependencies
