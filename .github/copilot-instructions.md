# GitHub Copilot Instructions

## Entry Points
- AGENTS.md - AI instructions
- llms.txt - Doc index
- docs/WORKFLOWS.md - Task execution steps
- docs/AGENTS.md - Subdirectory context

## Project Type
Documentation-only. No implementation code.

## Tasks
1. Add/update Mermaid diagrams in docs/
2. Update llms.txt and llms-full.txt indexes
3. Follow docs/WORKFLOWS.md for step-by-step

## File Restrictions
- DO modify: docs/*.md, *.txt, README.md
- DO NOT modify: docs/codex-architecture.html
- DO NOT create: Implementation code

## Key Fact
TUI → ThreadManager (direct)
NOT: TUI → MessageProcessor → ThreadManager
