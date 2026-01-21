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
│  Trigger: Natural language    Trigger: Natural language         │
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
│  └── PoC Design               market-research                  │
│                               └── Go/Pivot/Kill                │
│  Output: docs/ folder                                           │
│  Trigger: /slash-commands     Output: docs/ + code files       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### Claude Desktop

1. Download `.skill` files from [`claude-desktop/releases/`](claude-desktop/releases/)
2. In Claude Desktop: **Settings → Skills → Import Skill**

See [`claude-desktop/README.md`](claude-desktop/README.md) for details.

### Claude Code

```bash
cd claude-code
./deploy.sh
./verify.sh
```

See [`claude-code/README.md`](claude-code/README.md) for details.

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
   → /dev-overview
   → /dev-plan
   → /dev-execute
   → /dev-finalize
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
9. /dev-finalize → Wrap up task
10. Repeat 6-9 for each task

11. /small-win-check → Update PROJECT_STATE.md
```

## Key Principles

- **dev-design is NO-CODE** — Pure design and planning
- **dev-cycle allows code** — Stage 1 is design-only, Stages 2-3 allow code
- **One task at a time** — Plan and execute incrementally
- **Production-grade quality** — OOP, Pydantic, type hints, tests required
- **Self-contained work** — Each item works independently
- **200-users-first** — Right-sized for early users, scale comes later
- **Validate early** — Market research before heavy investment

## Repository Structure

```
idea-to-mvp/
├── README.md                   # This file
├── LICENSE
│
├── claude-code/                # Claude Code skills
│   ├── README.md               # CC documentation
│   ├── deploy.sh
│   ├── verify.sh
│   ├── sync-from-user.sh
│   ├── dev-design/
│   ├── dev-cycle/
│   └── commands/
│
└── claude-desktop/             # Claude Desktop skills
    ├── README.md               # CD documentation
    ├── package.sh
    ├── dev-design/
    ├── market-research/
    └── releases/
```

## License

MIT License - see [LICENSE](LICENSE) for details.
