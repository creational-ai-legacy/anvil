```
                               ┌────────────────────────────┐
         ╭─────────────────────┤                            │
          ╰──╮                 │      🔨 A N V I L 🔨       │
             ╰──╮              └───┐                  ┌─────┘
                ╰──────────────────┤                  │
                                   └────┐        ┌────┘
                                        │        │
                                   ┌────┘        └────┐
                                   │                  │
                                   └──────────────────┘
```

# Anvil

Turns Claude into a full product team — architect, developer, QA reviewer, market researcher, strategist — with stage-gated workflows that eliminate hallucination from design through deployment.

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-v0.0.9-green.svg)](https://github.com/creational-ai/anvil/releases)
[![GitHub Stars](https://img.shields.io/github/stars/creational-ai/anvil?style=social)](https://github.com/creational-ai/anvil)

## Quick Start

### Claude Desktop

1. Download `.skill` files from [`claude-desktop/releases/`](claude-desktop/releases/)
2. In Claude Desktop: **Settings > Skills > Import Skill**

See [`claude-desktop/README.md`](claude-desktop/README.md) for details.

### Claude Code

```bash
cd claude-code
./deploy.sh
./verify.sh
```

See [`claude-code/README.md`](claude-code/README.md) for details.

## Design Workflow

5 stages from raw idea to executable task plan. **Strictly no-code** — forces
architectural thinking before any implementation.

```
         ┌──────────────────────┐
         │      Raw Idea        │
         └──────────┬───────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │  1. Vision           │  Problem, solution, feasibility
         └──────────┬───────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │  2. Architecture     │  Tech stack, data flows, integrations
         └──────────┬───────────┘
                    │
              ┌─────┴──────┐
              │  Market    │
              │  Research  │  Go / Pivot / Kill?
              └─────┬──────┘
                    │ GO
                    ▼
         ┌──────────────────────┐
         │  3. Roadmap          │  Strategic milestone breakdown
         └──────────┬───────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │  4. Milestone Spec   │  Detailed per-milestone design
         └──────────┬───────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │  5. Task Spec        │  Atomic tasks + success criteria
         └──────────┬───────────┘
                    │
                    ▼
              Hand off tasks
```

Each stage produces a document from a **mandatory template** — no freeform output.
User runs `/verify-doc` between stages to catch gaps before moving forward.

## Development Workflow

3-stage loop per task. Spec-driven plans mean the AI implements from
specifications, not from pre-written code it might hallucinate.

```
         ┌──────────────────────┐
    ┌───▶│  Pick task from plan │
    │    └──────────┬───────────┘
    │               │
    │               ▼
    │    ┌──────────────────────┐
    │    │  1. Design (no code) │  Analyze, risk profile, constraints
    │    │     /verify-doc ✓    │  Approach per item, sequence
    │    └──────────┬───────────┘
    │               │
    │               ▼
    │    ┌──────────────────────┐
    │    │  2. Plan             │  Spec-driven steps (no code blocks)
    │    │     /verify-doc ✓    │  Acceptance criteria per step
    │    └──────────┬───────────┘
    │               │
    │               ▼
    │    ┌──────────────────────────────┐
    │    │  3. Execute + Finalize       │
    │    │                              │
    │    │    Implement ──▶ Test ──┐    │
    │    │        ▲          FAIL  │    │
    │    │        └────────────────┘    │
    │    │                   PASS       │
    │    │                    ▼         │
    │    │             Document + STOP  │
    │    │            ▼ next step       │
    │    │    ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄      │
    │    │    all steps done:           │
    │    │    Timestamp, lessons,       │
    │    │    diagram, health check     │
    │    └──────────────┬───────────────┘
    │                   │
    │                   ▼
    │    ┌──────────────────────┐
    │    │  Review (opt-in)     │  5 checks: intent, assumptions,
    │    │                      │  trade-offs, complexity, drift
    │    └──────────┬───────────┘
    │               │
    └───────────────┘
          next task
```

The test loop enforces **implement → test → fix → retest** on every single step.
The 5-check review catches AI-specific failures: silent assumptions, unsurfaced
trade-offs, and architectural drift from the design.

## Built with Anvil

Every product in the Creational ecosystem was designed and built using Anvil's stage-gated methodology.

- **Mission Control** -- AI project intelligence and portfolio management (MCP server)
- **Video Professor** -- YouTube data extraction and analysis (MCP server)
- **Hexar.io** -- Mobile game with AI-powered community features
- **Unity UI** -- Unity game interface components

## How Anvil Compares

| Capability | Anvil | superpowers | Skill collections |
|------------|-------|-------------|-------------------|
| Design workflow (idea to architecture to roadmap) | Full 5-stage | -- | -- |
| Dev workflow (design to plan to execute) | Spec-driven, stage-gated | Brainstorm to plan to execute | Individual commands |
| Anti-hallucination gates | Mandatory templates, spec-driven plans, 5-check review | TDD-first approach | -- |
| Market validation | Go/Pivot/Kill research | -- | -- |
| Quality review | 5-check conceptual review | Verification skills | -- |

superpowers is excellent for the coding phase and has a more mature marketplace presence. Anvil's strength is the full lifecycle -- from raw idea through market validation to shipped product. They're complementary, not mutually exclusive; you can use superpowers for coding discipline alongside Anvil's design-through-deployment methodology.

## Skills

### Claude Code

| Skill | Purpose |
|-------|---------|
| **design** | 5-stage design workflow: Vision, Architecture, Roadmap, Milestone Spec, Task Spec |
| **dev** | Development loop: design analysis, planning, step-by-step execution with tests, review, finalization |
| **market-research** | Market validation with Go/Pivot/Kill recommendation |
| **skill-reviewer** | Audit skills for structure, frontmatter, cross-references, and consistency |

### Claude Desktop

| Skill | Purpose |
|-------|---------|
| **design** (v2.0.0) | Same 5-stage design workflow (outputs as artifacts) |
| **market-research** (v1.1.0) | Market validation with Go/Pivot/Kill recommendation |
| **business-validation** (v1.1.0) | Business validation roadmaps with PoC-based experiments |
| **framework-alignment** (v1.0.0) | Strategic framework analysis (Four Loops, Flywheel, Dangerous Intelligence) |

## Key Principles

- **design skill is NO-CODE** — Pure design and planning
- **dev skill allows code** — Stage 1 is design-only, Stages 2-3 allow code
- **One task at a time** — Plan and execute incrementally
- **Production-grade quality** — OOP, validated data models, type hints, tests required
- **200-users-first** — Right-sized for early users, scale comes later
- **Validate early** — Market research before heavy investment

## Repository Structure

```
anvil/
├── README.md
├── CLAUDE.md
├── LICENSE
│
├── claude-code/                # Claude Code skills
│   ├── README.md
│   ├── deploy.sh              # Deploy skills and commands (local)
│   ├── deploy-genesis.sh      # Deploy skills to genesis (Raspberry Pi)
│   ├── verify.sh              # Verify deployment
│   ├── sync-from-user.sh      # Sync from deployed skills
│   ├── design/                # 5-stage design workflow
│   ├── dev/                   # Development loop
│   ├── market-research/       # Market validation
│   └── skill-reviewer/        # Skill auditing
│
└── claude-desktop/             # Claude Desktop skills
    ├── README.md
    ├── package.sh             # Build .skill files
    ├── unpackage.sh           # Extract .skill files
    ├── design/                # Design skill (v2.0.0)
    ├── market-research/       # Market validation (v1.1.0)
    ├── business-validation/   # Business validation (v1.1.0)
    ├── framework-alignment/   # Framework analysis (v1.0.0)
    └── releases/              # Packaged .skill files
```

## License

MIT License - see [LICENSE](LICENSE) for details.
