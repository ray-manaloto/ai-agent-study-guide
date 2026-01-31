# Vercel Labs AI Tools Research

> Comprehensive analysis of existing tools for LLM project optimization automation.

## Executive Summary

**Recommendation: USE EXISTING TOOLS - Don't build your own.**

The Vercel Labs ecosystem provides a complete, well-maintained toolchain for LLM project optimization. The `npx skills` CLI (3.7k stars) is the primary tool, with supporting tools for specific use cases.

## Tool Comparison Matrix

| Tool | Stars | Purpose | Use For Our Project? |
|------|-------|---------|---------------------|
| **vercel-labs/agent-browser** | 11.8k | Browser automation CLI for AI agents | **YES - BROWSER AUTOMATION** |
| **vercel-labs/agent-skills** | 18.1k | Official skill collection (React, design, deploy) | Reference only |
| **vercel-labs/skills** | 3.7k | CLI to install/manage Agent Skills | **YES - PRIMARY** |
| **vercel-labs/opensrc** | 328 | Fetch npm package source for AI context | **YES - USEFUL** |
| **vercel-labs/specli** | 92 | OpenAPI spec → CLI for agents | No - API specific |
| **vercel-labs/awesome-ai** | 26 | CLI/TUI for AI agents, tools, prompts | No - different purpose |
| **vercel-labs/skills-handler** | 2 | Serve skills via well-known URIs (Next.js) | No - server-side |
| **vercel-labs/migration-skills** | 3 | Framework migration skills (CRA→Next) | Reference only |
| **vercel-labs/mcp-to-ai-sdk** | NEW | Generate AI SDK stubs for MCP tools | Reference only |
| **vercel-labs/coding-agent-template** | NEW | Multi-agent AI coding platform template | Reference only |

---

## Detailed Tool Analysis

### 1. vercel-labs/agent-browser (BROWSER AUTOMATION)

**What it does**: Headless browser automation CLI optimized for AI agents. Fast Rust CLI with Node.js fallback.

**Stars**: 11.8k | **Forks**: 655 | **Version**: 0.8.5

**Why It's Important**: Provides AI-friendly browser automation with deterministic element refs from accessibility snapshots, reducing context window usage by ~93% compared to raw HTML.

**Key Commands**:
```bash
# Core workflow (optimized for AI)
npx agent-browser open example.com        # Navigate
npx agent-browser snapshot -i             # Get interactive elements with refs (@e1, @e2)
npx agent-browser click @e2               # Click by ref
npx agent-browser fill @e3 "text"         # Fill by ref
npx agent-browser screenshot page.png     # Screenshot
npx agent-browser close                   # Close

# Traditional selectors (also supported)
npx agent-browser click "#submit"
npx agent-browser find role button click --name "Submit"
```

**Snapshot Options**:
| Option | Description |
|--------|-------------|
| `-i, --interactive` | Only show interactive elements |
| `-c, --compact` | Remove empty structural elements |
| `-d, --depth <n>` | Limit tree depth |
| `-s, --selector <sel>` | Scope to CSS selector |

**Sessions & Profiles**:
```bash
# Multiple isolated sessions
npx agent-browser --session agent1 open site-a.com
npx agent-browser --session agent2 open site-b.com

# Persistent profiles (cookies, localStorage)
npx agent-browser --profile ~/.myapp-profile open myapp.com
```

**Cloud Providers Supported**:
- Browserbase
- Browser Use
- Kernel

**Install Skill**:
```bash
npx skills add vercel-labs/agent-browser
```

---

### 2. vercel-labs/skills (PRIMARY TOOL)

**What it does**: CLI for installing, managing, and creating Agent Skills across 41+ AI coding tools.

**Stars**: 3.7k | **Forks**: 295 | **Version**: 1.3.1

**Key Commands**:
```bash
npx skills add vercel-labs/agent-skills     # Install skills
npx skills add owner/repo --skill "name"    # Install specific skill
npx skills init                              # Create SKILL.md template
npx skills list                              # List installed skills
npx skills find [query]                      # Search for skills
npx skills remove [skills]                   # Remove skills
npx skills check                             # Check for updates
npx skills update                            # Update all skills
```

**Supported Agents (41+)**:
- Claude Code, Cursor, Codex, OpenCode, GitHub Copilot
- Windsurf, Continue, Goose, Roo Code, Gemini CLI
- Amp, Cline, CodeBuddy, Command Code, Kiro CLI
- Antigravity, Augment, Droid, Junie, Kilo Code
- Mistral Vibe, OpenHands, Pi, Qoder, Qwen Code, and more

**Why Use It**:
- Automates skill installation across ALL major AI tools
- Handles symlinks vs copies automatically
- Supports GitHub, GitLab, any git URL, local paths
- CI/CD friendly with `--yes` flag
- Active development (v1.3.1 released Jan 2026)

#### Canonical `.agents/skills/` Directory

**KEY FINDING**: The `npx skills` CLI uses `.agents/skills/` as the **canonical location** for all skills.

**How it works**:
```
.agents/skills/              ← CANONICAL (single source of truth)
├── my-skill/
│   └── SKILL.md
└── another-skill/
    └── SKILL.md

.claude/skills/my-skill      → symlink to .agents/skills/my-skill
.cursor/skills/my-skill      → symlink to .agents/skills/my-skill
.codex/skills/my-skill       → symlink to .agents/skills/my-skill
```

**From `src/installer.ts`**:
```typescript
const AGENTS_DIR = '.agents';
const SKILLS_SUBDIR = 'skills';

// Canonical location: .agents/skills/<skill-name>
const canonicalDir = join(canonicalBase, skillName);

// Agent-specific location (for symlink)
```

**Installation modes**:
| Mode | Description |
|------|-------------|
| **Symlink** (Recommended) | Single source of truth in `.agents/skills/`, symlinks for each agent |
| **Copy** | Independent copies in each agent's directory |

**Agents using `.agents/skills/` directly**:
| Agent | Path |
|-------|------|
| Amp | `.agents/skills/` |
| Kimi Code CLI | `.agents/skills/` |

**Search paths** (the CLI looks in all of these):
- `.agents/skills/`
- `.agent/skills/`
- `skills/`
- `.claude/skills/`
- `.cursor/skills/`
- `.codex/skills/`
- (and 20+ more)

**Implication**: You don't need multiple directories. Just use `.agents/skills/` and let `npx skills` handle symlinking to agent-specific paths.

---

### 3. vercel-labs/agent-skills (Reference)

**What it does**: Vercel's official collection of production-ready skills.

**Stars**: 18.1k | **Forks**: 1.7k | **Skills**: 6 major packages

**Available Skills**:
| Skill | Description |
|-------|-------------|
| `react-best-practices` | 40+ React/Next.js performance rules |
| `web-design-guidelines` | 100+ UI/UX/a11y rules |
| `react-native-guidelines` | 16 RN rules across 7 sections |
| `composition-patterns` | Component composition patterns |
| `vercel-deploy-claimable` | Deploy to Vercel from Claude |

**Why Reference It**:
- Examples of well-structured skills
- Shows how to organize scripts/, references/, SKILL.md
- Production-tested by Vercel

---

### 4. vercel-labs/opensrc (USEFUL)

**What it does**: Fetch npm package source code for AI agent context.

**Stars**: 328 | **Forks**: 18 | **Version**: 0.6.0

**Commands**:
```bash
npx opensrc zod              # Fetch source for zod (npm)
npx opensrc zod@3.22.0       # Specific version
npx opensrc react react-dom  # Multiple packages
npx opensrc pypi:requests    # Python packages (PyPI)
npx opensrc crates:serde     # Rust crates
npx opensrc owner/repo       # GitHub repos
npx opensrc list             # List fetched sources
npx opensrc remove zod       # Remove source
```

**What It Creates**:
```
opensrc/
├── settings.json       # Preferences
├── sources.json        # Index of fetched packages
└── zod/
    ├── src/
    └── package.json
```

**Why Use It**:
- Gives AI agents access to library implementation (not just types)
- Auto-modifies .gitignore, tsconfig.json, AGENTS.md
- Detects version from lockfile automatically

---

### 5. vercel-labs/skills-handler (Server-Side)

**What it does**: Framework-agnostic handler for serving skills via `/.well-known/skills/` URIs.

**Stars**: 2 | **Forks**: 1

**Use Case**: If you want to serve skills from your own website/API.

```typescript
// Next.js: app/.well-known/skills/[[...path]]/route.ts
import { createSkillsHandler, createFileProvider } from "skills-handler";

const provider = await createFileProvider("./skills");
const handler = createSkillsHandler(provider);

export { handler as GET, handler as OPTIONS };
```

**Why Skip It**: We're creating skills for installation, not serving via HTTP.

---

### 6. vercel-labs/specli (API Specific)

**What it does**: Turn any OpenAPI spec into a CLI for AI agents.

**Stars**: 92 | **Forks**: 2

```bash
npx specli compile https://api.example.com/openapi.json --name myapi
./out/myapi users list
```

**Why Skip It**: Specific to API automation, not LLM project optimization.

---

### 7. vercel-labs/awesome-ai (Different Purpose)

**What it does**: CLI/TUI for adding AI agents, tools, and prompts from a curated registry.

**Stars**: 26 | **Forks**: 5

```bash
npm install -g awesome-ai
awesome-ai init
awesome-ai add coding-agent
awesome-ai run coding-agent
```

**Why Skip It**: Different scope - manages agents/tools, not project optimization.

---

### 8. vercel-labs/migration-skills (Reference)

**What it does**: Skills for framework migrations (e.g., CRA → Next.js).

**Stars**: 3 | **Forks**: 1

**Available Skills**:
- `cra-to-next-migration`

**Why Reference It**: Example of domain-specific skill structure.

---

## Recommendation: Automation Strategy

### For Our LLM Optimization Template

1. **Primary Tool**: `npx skills`
   - Use to install/manage our `llm-project-optimization` skill
   - Supports all 36+ AI coding tools automatically

2. **Supplementary Tool**: `npx opensrc`
   - Recommend for projects using unfamiliar libraries
   - Gives AI agents implementation context

3. **Don't Build**:
   - Custom CLI for skill management (skills CLI exists)
   - Custom server for skill serving (skills-handler exists)
   - Custom tool for fetching library source (opensrc exists)

### Updated Installation Flow

```bash
# Option 1: Install our skill via npx skills
npx skills add ray-manaloto/ai-agent-study-guide/docs/templates/llm-project-optimization

# Option 2: Install with opensrc for deep library context
npx skills add ray-manaloto/ai-agent-study-guide
npx opensrc zod react  # Add source for key dependencies

# Option 3: Manual (if npx skills not available)
# Copy docs/templates/llm-project-optimization/SKILL.md manually
```

---

## Agent Skills Specification Summary

From [agentskills.io](https://agentskills.io):

### SKILL.md Format
```yaml
---
name: skill-name                    # Required: 1-64 chars, lowercase, hyphens
description: What and when          # Required: 1-1024 chars
license: MIT                        # Optional
compatibility: Requires git, docker # Optional: 1-500 chars
metadata:                           # Optional
  author: example-org
  version: "1.0"
allowed-tools: Bash(git:*) Read     # Optional, experimental
---

# Skill Instructions

Markdown content...
```

### Directory Structure
```
skill-name/
├── SKILL.md          # Required
├── scripts/          # Optional: executable code
├── references/       # Optional: additional docs
└── assets/           # Optional: templates, images, data
```

### Progressive Disclosure (Token Optimization)
1. **Metadata** (~100 tokens): name + description loaded at startup
2. **Instructions** (<5000 tokens): SKILL.md body loaded on activation
3. **Resources** (on demand): scripts/, references/, assets/

---

## Ecosystem Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     AGENT SKILLS ECOSYSTEM                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │ agentskills  │     │  skills.sh   │     │ npx skills   │    │
│  │    .io       │────▶│  (discovery) │────▶│   (CLI)      │    │
│  │   (spec)     │     │              │     │              │    │
│  └──────────────┘     └──────────────┘     └──────────────┘    │
│         │                                         │              │
│         ▼                                         ▼              │
│  ┌──────────────┐                         ┌──────────────┐      │
│  │  SKILL.md    │                         │ 36+ Agents   │      │
│  │   Format     │                         │ Supported    │      │
│  └──────────────┘                         └──────────────┘      │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                     SUPPORTING TOOLS                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │   opensrc    │     │ skills-      │     │   specli     │    │
│  │ (npm source) │     │ handler      │     │ (OpenAPI→CLI)│    │
│  │              │     │ (serve via   │     │              │    │
│  │              │     │  HTTP)       │     │              │    │
│  └──────────────┘     └──────────────┘     └──────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## `.agents/` Canonical Directory (Reduces Duplication)

The `npx skills` CLI uses `.agents/skills/` as the **single source of truth**, with symlinks to agent-specific directories.

### Directory Structure After Installation

```
project/
├── .agents/                      # CANONICAL (source of truth)
│   └── skills/
│       ├── my-skill/
│       │   └── SKILL.md
│       └── another-skill/
│           └── SKILL.md
│
├── .claude/skills/               # Symlinks for Claude Code
│   ├── my-skill → ../../.agents/skills/my-skill
│   └── another-skill → ../../.agents/skills/another-skill
│
├── .cursor/skills/               # Symlinks for Cursor
│   ├── my-skill → ../../.agents/skills/my-skill
│   └── another-skill → ../../.agents/skills/another-skill
│
├── .codex/skills/                # Symlinks for Codex
│   └── ...
│
└── (other agent dirs)            # All symlink to .agents/
```

### Benefits of This Approach

| Benefit | Description |
|---------|-------------|
| **Single source of truth** | Update skill once, all agents see it |
| **No duplication** | Symlinks instead of copies |
| **Easy updates** | `npx skills update` updates canonical, symlinks follow |
| **Disk efficient** | One copy per skill, not N copies per agent |
| **Git friendly** | Only `.agents/skills/` needs to be tracked |

### Agents That Use `.agents/` Directly

Some agents already use `.agents/skills/` as their primary path (no symlink needed):

| Agent | Primary Path |
|-------|--------------|
| Amp | `.agents/skills/` |
| Kimi Code CLI | `.agents/skills/` |

### Installation Command

```bash
# Symlink mode (default, recommended)
npx skills add owner/repo

# Copy mode (if symlinks not supported)
npx skills add owner/repo --copy

# Interactive selection
npx skills add owner/repo
# → Choose: Symlink (Recommended) or Copy
```

### Implications for Project Authors

1. **Don't create multiple directories** - Just use `.agents/skills/` or let `npx skills` handle it
2. **Git ignore agent-specific dirs** - They're just symlinks
3. **Track `.agents/`** - This is the canonical location

```gitignore
# .gitignore
.claude/skills/     # Symlinks only
.cursor/skills/     # Symlinks only
.codex/skills/      # Symlinks only
# Keep .agents/skills/ tracked (or ignore if installed dynamically)
```

---

---

## Additional Vercel Labs AI Tools (Discovered)

These additional tools were discovered during research and may be useful:

| Tool | Stars | Purpose | Notes |
|------|-------|---------|-------|
| **vercel-labs/mcp-to-ai-sdk** | NEW | Generate AI SDK stubs for MCP tools | Security-focused, prevents prompt injection |
| **vercel-labs/coding-agent-template** | NEW | Multi-agent AI coding platform template | Vercel Sandbox + AI Gateway |
| **vercel-labs/ai-sdk-computer-use** | NEW | Computer use agent with Claude | E2B sandbox integration |
| **vercel-labs/workflow-builder-template** | NEW | Visual AI workflow automation | OpenAI GPT-5 powered |
| **vercel-labs/lead-agent** | NEW | Lead qualification agent | AI SDK Agent class |

---

## Conclusion

**DO NOT build custom tooling.** The Vercel Labs ecosystem provides:

1. **npx agent-browser** - Browser automation for AI (11.8k stars) - **NEW!**
2. **npx skills** - Complete CLI for skill management (3.7k stars)
3. **npx opensrc** - Library source fetching for AI context (328 stars)
4. **Agent Skills spec** - Open standard adopted by 41+ tools
5. **skills-handler** - Server-side skill serving (if needed)

Our role: **Create and publish skills, not tools.**

---

## Local Validation Results

All tools validated on Jan 30, 2026:

| Tool | Version | Command | Status |
|------|---------|---------|--------|
| skills | 1.3.1 | `npx skills --version` | ✅ Working |
| opensrc | 0.6.0 | `npx opensrc --help` | ✅ Working |
| specli | 0.0.39 | `npx specli --help` | ✅ Working |
| awesome-ai | global | `awesome-ai --help` | ✅ Installed |
| agent-browser | 0.8.5 | `npx agent-browser` | ⚠️ Needs Rust build on M1 |

---

## References

- [Agent Skills Specification](https://agentskills.io)
- [Skills Discovery Directory](https://skills.sh)
- [Agent Browser Docs](https://agent-browser.dev)
- [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) - Browser CLI (11.8k stars) **NEW!**
- [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) - Official skills (18.1k stars)
- [vercel-labs/skills](https://github.com/vercel-labs/skills) - CLI (3.7k stars)
- [vercel-labs/opensrc](https://github.com/vercel-labs/opensrc) - Source fetcher (328 stars)
- [vercel-labs/specli](https://github.com/vercel-labs/specli) - OpenAPI→CLI (92 stars)
- [vercel-labs/awesome-ai](https://github.com/vercel-labs/awesome-ai) - Agent registry (26 stars)
- [vercel-labs/skills-handler](https://github.com/vercel-labs/skills-handler) - HTTP handler (2 stars)
- [vercel-labs/migration-skills](https://github.com/vercel-labs/migration-skills) - Migration skills (3 stars)
- [vercel-labs/mcp-to-ai-sdk](https://github.com/vercel-labs/mcp-to-ai-sdk) - MCP to AI SDK
- [vercel-labs/coding-agent-template](https://github.com/vercel-labs/coding-agent-template) - Multi-agent template
