# Kata: Spec-Driven Multi-Agent Orchestration

> Choreographed patterns for Claude Code, practiced until perfected

---

## Overview

| Attribute | Value |
|-----------|-------|
| Name | Kata (型 - /ˈkɑːtɑː/) |
| Type | Multi-Agent Orchestrator |
| Source | [github.com/gannonh/kata](https://github.com/gannonh/kata) |
| Website | [kata.sh](https://kata.sh) |
| License | MIT |
| Runtime | Claude Code |
| Latest | v1.4.0 |

Kata is a **multi-agent orchestration framework for spec-driven development**, designed specifically for Claude Code. The name comes from martial arts, meaning "a choreographed pattern practiced repeatedly until perfected."

---

## Architecture

### Core Design Pattern

```
┌─────────────────────────────────────────────────────────────────┐
│                      Kata Architecture                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              User Input Layer                            │    │
│  │  ┌──────────────────┐  ┌───────────────────────────┐    │    │
│  │  │ Natural Language │  │ Slash Commands            │    │    │
│  │  │ "Start project"  │  │ /kata:new-project         │    │    │
│  │  └──────────────────┘  └───────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │         Skills (Thin Orchestrators) - 27+ Skills         │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │    │
│  │  │  starting-  │  │  planning-  │  │  executing- │      │    │
│  │  │  projects   │  │   phases    │  │   phases    │      │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘      │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │         Agents (Specialized Workers) - 19+ Agents        │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐    │    │
│  │  │ planner │  │executor │  │verifier │  │debugger │    │    │
│  │  │ Fresh   │  │ Fresh   │  │ Fresh   │  │ Fresh   │    │    │
│  │  │ 200k    │  │ 200k    │  │ 200k    │  │ 200k    │    │    │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                            │                                      │
│                            ▼                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              Artifacts (.planning/ directory)            │    │
│  │  PROJECT.md  ROADMAP.md  STATE.md  PLAN.md  SUMMARY.md  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Key Principle: Thin Orchestrators

| Component | Context Usage | Purpose |
|-----------|---------------|---------|
| Orchestrator | 30-40% | Coordinate, don't execute |
| Subagents | Fresh 200k each | Execute heavy work |
| **Result** | Full phase execution without context overflow |

---

## 8-Phase Development Lifecycle

### Phase Flow

```mermaid
flowchart TB
    subgraph Init["1. Initialize Project"]
        Q[Deep Questioning]
        V[Vision Capture]
    end
    
    subgraph Mile["2. Add Milestone"]
        R[Research]
        Req[Requirements]
        Road[Roadmap]
    end
    
    subgraph Disc["3. Discuss (Optional)"]
        Cap[Capture Decisions]
    end
    
    subgraph Plan["4. Plan Phase"]
        PR[Phase Research]
        Plans[Create Plans]
        Verify[Verify Plans]
    end
    
    subgraph Exec["5. Execute Phase"]
        Wave[Wave Execution]
        Atomic[Atomic Commits]
    end
    
    subgraph UAT["6. Verify (Optional)"]
        Test[UAT Testing]
        Debug[Debug Agents]
    end
    
    subgraph Rev["7. Review (Optional)"]
        Six[6 Review Agents]
    end
    
    subgraph Done["8. Complete Milestone"]
        Arch[Archive]
        Rel[Release]
    end
    
    Init --> Mile
    Mile --> Disc
    Disc --> Plan
    Plan --> Exec
    Exec --> UAT
    UAT --> Rev
    Rev --> Done
    Done -->|Next Milestone| Mile
```

### Phase Details

| Phase | Command | Agents Spawned |
|-------|---------|----------------|
| Initialize | `/kata:new-project` | 4 parallel researchers |
| Milestone | `/kata:add-milestone` | Roadmapper |
| Discuss | `/kata:discuss` | None (conversation) |
| Plan | `/kata:plan-phase N` | Researcher, Planner, Checker |
| Execute | `/kata:execute-phase N` | Executors (parallel waves) |
| Verify | `/kata:verify-work N` | Verifier, Debugger |
| Review | `/kata:review-pr` | 6 review agents |
| Complete | `/kata:complete-milestone` | None (automation) |

---

## Multi-Agent Orchestration

### Agent Types (19+)

| Agent | Role | Context |
|-------|------|---------|
| `kata-roadmapper` | Milestone planning | Standard |
| `kata-project-researcher` | Domain research (4 parallel) | Fresh 200k each |
| `kata-phase-researcher` | Phase-specific research | Fresh 200k |
| `kata-planner` | Creates executable plans | Standard |
| `kata-plan-checker` | Validates plans (loops) | Standard |
| `kata-executor` | Implements tasks | Fresh 200k per plan |
| `kata-verifier` | Confirms deliverables | Standard |
| `kata-debugger` | Fixes failures | Fresh 200k |
| `kata-code-reviewer` | Code quality | Fresh 200k |
| `kata-test-analyzer` | Test coverage | Fresh 200k |
| `kata-failure-finder` | Error handling | Fresh 200k |
| `kata-type-analyzer` | Type design | Fresh 200k |
| `kata-code-simplifier` | Maintainability | Fresh 200k |
| `kata-comment-analyzer` | Documentation | Fresh 200k |

### Orchestration Patterns

#### 1. Parallel Research (4 Agents)

```mermaid
flowchart LR
    Orch[Orchestrator] --> S[Stack Researcher]
    Orch --> F[Features Researcher]
    Orch --> A[Architecture Researcher]
    Orch --> P[Pitfalls Researcher]
    
    S --> Synth[Synthesizer]
    F --> Synth
    A --> Synth
    P --> Synth
```

#### 2. Verification Loop (3 Iterations Max)

```mermaid
flowchart TD
    Planner[Planner Creates Plans] --> Checker[Plan Checker Validates]
    Checker --> Pass{Pass?}
    Pass -->|Yes| Execute[Execute Phase]
    Pass -->|No| Count{< 3 iterations?}
    Count -->|Yes| Planner
    Count -->|No| Manual[Manual Review]
```

#### 3. Wave Execution

```mermaid
flowchart LR
    subgraph Wave1["Wave 1 (Parallel)"]
        P1[Plan A]
        P2[Plan B]
        P3[Plan C]
    end
    
    subgraph Wave2["Wave 2 (Depends on 1)"]
        P4[Plan D]
        P5[Plan E]
    end
    
    subgraph Wave3["Wave 3 (Depends on 2)"]
        P6[Plan F]
    end
    
    Wave1 --> Wave2
    Wave2 --> Wave3
```

#### 4. PR Review Swarm (6 Parallel)

```mermaid
flowchart TB
    PR[Pull Request] --> R1[Code Reviewer]
    PR --> R2[Test Analyzer]
    PR --> R3[Comment Analyzer]
    PR --> R4[Failure Finder]
    PR --> R5[Type Analyzer]
    PR --> R6[Code Simplifier]
    
    R1 --> Agg[Aggregate by Severity]
    R2 --> Agg
    R3 --> Agg
    R4 --> Agg
    R5 --> Agg
    R6 --> Agg
```

---

## Artifact System

### .planning/ Directory Structure

```
.planning/
├── PROJECT.md              # Project vision (always loaded)
├── REQUIREMENTS.md         # Scoped v1/v2 requirements
├── ROADMAP.md              # Phase structure
├── STATE.md                # Session memory, decisions
├── config.json             # Workflow preferences
├── research/               # Domain research
├── {phase}-CONTEXT.md      # Implementation vision
├── {phase}-RESEARCH.md     # Phase-specific research
├── {phase}-{N}-PLAN.md     # Executable task plans (XML)
├── {phase}-{N}-SUMMARY.md  # Execution summaries
├── {phase}-VERIFICATION.md # Automated verification
└── {phase}-UAT.md          # User acceptance results
```

### Context File Loading

| File | When Loaded | Purpose |
|------|-------------|---------|
| `PROJECT.md` | Always | Vision, requirements |
| `REQUIREMENTS.md` | Planning + Execution | Traceability IDs |
| `ROADMAP.md` | Navigation | Phase structure |
| `STATE.md` | Always | Living memory |
| `PLAN.md` | Execution only | Atomic tasks |
| `SUMMARY.md` | Post-execution | Results |

---

## XML Prompt Formatting

### Plan Structure

```xml
<plan>
  <task id="01-02-01">
    <description>Implement email confirmation flow</description>
    <verification>User receives confirmation email</verification>
    <depends_on>01-01-03</depends_on>
  </task>
  <task id="01-02-02">
    <description>Add password reset endpoint</description>
    <verification>POST /auth/reset returns 200</verification>
  </task>
</plan>
```

### Benefits of XML

| Benefit | Description |
|---------|-------------|
| **Precision** | No ambiguity in instructions |
| **Verification** | Built-in success criteria |
| **Anti-drift** | Prevents agent wandering |
| **Claude-optimized** | Leverages attention mechanism |

---

## Model Profiles

| Profile | Planning | Execution | Verification |
|---------|----------|-----------|--------------|
| `quality` | Opus | Opus | Sonnet |
| `balanced` | Opus | Sonnet | Sonnet |
| `budget` | Sonnet | Sonnet | Haiku |

---

## Git Integration

### Atomic Commits

```bash
# One commit per task
abc123f docs(08-02): complete user registration plan
def456g feat(08-02): add email confirmation flow
hij789k feat(08-02): implement password hashing
```

### Commit Convention

| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `test` | Test addition |
| `refactor` | Code refactoring |
| `docs` | Documentation |
| `chore` | Maintenance |

---

## Comparison Summary

### vs. Other Orchestrators

| Feature | Kata | Get-Shit-Done | Claude Code |
|---------|------|---------------|-------------|
| Approach | Spec-driven phases | Task decomposition | Single agent |
| Agent Count | ~10 specialized | ~11 specialized | 1 + subagents |
| Context Strategy | Fresh 200k per agent | Fresh 200k per agent | Shared |
| Git Integration | Atomic commits | Atomic commits | Manual |
| GitHub Integration | Deep (Issues→PRs→Releases) | Optional | None |

### When to Use Kata

| Use Case | Recommendation |
|----------|----------------|
| Spec-driven team projects | **Highly Recommended** |
| Phase-based development | **Highly Recommended** |
| GitHub-integrated workflows | **Recommended** |
| Quick ad-hoc tasks | Use `/kata:quick` |
| Simple single-agent tasks | Use vanilla Claude Code |

---

## Resources

| Resource | URL |
|----------|-----|
| Website | https://kata.sh |
| GitHub | https://github.com/gannonh/kata |
| Agent Skills Standard | https://agentskills.io |
| Documentation | https://kata.sh/docs |

---

## See Also

- [../README.md](../README.md) - Tools overview
- [diagrams.md](diagrams.md) - Detailed architecture diagrams
- [examples.md](examples.md) - Usage examples
- [../BEST-PRACTICES.md](../BEST-PRACTICES.md) - Integration patterns
