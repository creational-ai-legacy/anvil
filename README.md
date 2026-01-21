# idea-to-mvp

![Claude Skill](https://img.shields.io/badge/Claude-Skill-blue)

A structured workflow for taking ideas from concept to working product. Supports both **Claude Code** (implementation) and **Claude Desktop** (design & research).

## Two Environments, One Methodology

```
┌─────────────────────────────────────────────────────────────────┐
│                     CLAUDE DESKTOP                              │
│              (Design & Market Validation)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  dev-design (v1.5.0)          market-research (v1.1.0)         │
│  ├── North Star               ├── Market size                  │
│  ├── Architecture             ├── Competitors                  │
│  ├── Milestones Overview      ├── Positioning                  │
│  ├── Milestone Design         ├── GTM strategy                 │
│  └── PoC Design               └── Go/Pivot/Kill                │
│                                                                 │
│  Output: Artifacts            Output: Artifacts                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                               ↓
                    Hand off design docs
                               ↓
┌─────────────────────────────────────────────────────────────────┐
│                      CLAUDE CODE                                │
│                   (Implementation)                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  dev-design                   dev-cycle                         │
│  ├── North Star               ├── Overview (no code)           │
│  ├── Architecture             ├── Implementation Plan          │
│  ├── Milestones Overview      └── Execution + Tests            │
│  ├── Milestone Design                                          │
│  └── PoC Design               Output: docs/ + code files       │
│                                                                 │
│  Output: docs/ folder         Invocation: /slash-commands      │
│  Invocation: /slash-commands                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### Claude Code (Implementation)

```bash
git clone git@github-creational:creational-ai/idea-to-mvp.git
cd idea-to-mvp

# Deploy skills and commands to ~/.claude/
./deploy.sh

# Verify deployment
./verify.sh
```

### Claude Desktop (Design & Research)

1. Navigate to `claude-desktop/releases/`
2. Download `.skill` files
3. In Claude Desktop: **Settings → Skills → Import Skill**

Or rebuild from source:
```bash
cd claude-desktop
./package.sh
```

See [`claude-desktop/README.md`](claude-desktop/README.md) for details.

---

## Claude Code Skills

### dev-design — Design Phase

Creates the foundation before any code is written. **NO CODE allowed.**

**Stages**:
1. North Star — Refine idea into vision doc
2. Architecture — Technical architecture
3. Milestones Overview — Strategic milestone roadmap
4. Milestone Design — Detailed design per milestone
5. PoC Design — Define atomic proofs-of-concept

**Commands**:
- `/design-northstar` — Create vision document
- `/design-architecture` — Create architecture document
- `/design-milestones-overview` — Create milestone roadmap
- `/design-milestone-design` — Create detailed milestone design
- `/design-poc-design` — Create PoC breakdown

**Output**: `docs/[slug]-*.md` files

### dev-cycle — Development Loop

Implements tasks through a repeating 3-stage cycle.

**Stages**:
1. Overview — Analyze features/bugs (design only, NO CODE)
2. Implementation Plan — Break into steps with code snippets
3. Execution — Implement with tests

**Commands**:
- `/dev-overview` — Create high-level design
- `/dev-plan` — Plan implementation steps
- `/dev-execute` — Execute step-by-step
- `/dev-lessons` — Consolidate lessons learned
- `/small-win-check` — Health check after work completion

**Agent Commands** (for subagent invocation):
- `/agent-dev-plan` — Plan agent for Stage 2
- `/agent-dev-execute` — Execute agent for Stage 3

**Output**: `docs/[milestone-slug]-[task-slug]-*.md` files + implementation

---

## Claude Desktop Skills

See [`claude-desktop/README.md`](claude-desktop/README.md) for full details.

### dev-design (v1.5.0) — Design Phase

Same 5-stage workflow, optimized for Claude Desktop:
- Outputs as **artifacts** (not files)
- **Natural language** triggers (no slash commands)
- **200-users-first** philosophy baked in
- **Market research checkpoint** after Stage 2

### market-research (v1.1.0) — Market Validation

Thorough market validation producing a Go/Pivot/Kill recommendation.
- **Mission Control MCP integration** — auto-pulls project context
- **Evidence-based** — 20-30+ web searches
- **Decision-ready** — clear recommendation with reasoning

---

## Workflow

### Full Workflow (Both Environments)

```
CLAUDE DESKTOP
──────────────
1. dev-design Stages 1-2
   → North Star artifact
   → Architecture artifact

2. Market Research Checkpoint
   → "Do market research for [project]"
   → Go / Pivot / Kill?

3. dev-design Stages 3-5 (if GO)
   → Milestones Overview artifact
   → Milestone Design artifact
   → PoC Design artifact

CLAUDE CODE
───────────
4. Import design docs to project

5. dev-cycle loop (per task)
   → /dev-overview (optional)
   → /dev-plan
   → /dev-execute
   → /dev-lessons
   → Repeat

6. /small-win-check after completion
```

### Claude Code Only Workflow

```
1. /design-northstar → Vision document
2. /design-architecture → Technical design
3. /design-milestones-overview → Strategic roadmap
4. /design-milestone-design → Detailed milestone design
5. /design-poc-design → Atomic proof-of-concepts

6. /dev-overview → Analyze first task
7. /dev-plan → Plan implementation
8. /dev-execute → Execute step-by-step
9. /dev-lessons → Consolidate lessons
10. Repeat 6-9 for each task

11. /small-win-check → Update PROJECT_STATE.md
```

---

## Key Principles

- **dev-design is NO-CODE** — Pure design and planning
- **dev-cycle allows code** — Stage 1 is design-only, Stages 2-3 allow code
- **One task at a time** — Plan and execute incrementally
- **Production-grade quality** — OOP, Pydantic, type hints, tests required
- **Self-contained work** — Each item works independently
- **200-users-first** — Right-sized for early users, scale comes later
- **Validate early** — Market research before heavy investment

---

## File Structure

```
idea-to-mvp/
├── README.md                   # This file
├── LICENSE
│
├── # ─── Claude Code ───────────────────────────────
├── deploy.sh                   # Deploy CC skills + commands
├── verify.sh                   # Verify CC deployment
├── sync-from-user.sh           # Sync from deployed skills
│
├── dev-design/                 # CC: Design skill (5 stages)
│   ├── SKILL.md
│   ├── assets/templates/
│   └── references/
│
├── dev-cycle/                  # CC: Development skill (3 stages)
│   ├── SKILL.md
│   ├── assets/templates/
│   ├── agents/
│   └── references/
│
├── commands/                   # CC: Slash commands
│   ├── design-*.md
│   ├── dev-*.md
│   └── ...
│
├── # ─── Claude Desktop ────────────────────────────
└── claude-desktop/
    ├── README.md               # CD-specific documentation
    ├── package.sh              # Build .skill files
    │
    ├── dev-design/             # CD: Design skill (v1.5.0)
    │   ├── SKILL.md
    │   ├── assets/templates/
    │   └── references/
    │
    ├── market-research/        # CD: Market validation (v1.1.0)
    │   ├── SKILL.md
    │   ├── assets/templates/
    │   └── references/
    │
    └── releases/               # Packaged .skill files
        ├── dev-design.skill
        └── market-research.skill
```

**Claude Code deploys to**:
- `~/.claude/skills/dev-design/`
- `~/.claude/skills/dev-cycle/`
- `~/.claude/commands/`

**Claude Desktop**: Import `.skill` files via Settings

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
