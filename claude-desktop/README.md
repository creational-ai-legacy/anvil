# Claude Desktop Skills

Skills for the **design and validation phase** of idea-to-mvp, optimized for Claude Desktop (claude.ai).

## Skills

| Skill | Version | Purpose |
|-------|---------|---------|
| **dev-design** | 1.5.0 | 5-stage design workflow (North Star → Architecture → Milestones → Milestone Design → PoC Design) |
| **market-research** | 1.1.0 | Market validation with Go/Pivot/Kill recommendation |

## Installation

### Option 1: Import .skill files (Recommended)

1. Download from `releases/`:
   - `dev-design.skill`
   - `market-research.skill`

2. In Claude Desktop: **Settings → Skills → Import Skill**

3. Select the `.skill` file(s)

### Option 2: Manual installation

Copy skill folders to your Claude Desktop skills directory.

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│                    DESIGN PHASE                         │
│                  (Claude Desktop)                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Stage 1: North Star                                    │
│      ↓                                                  │
│  Stage 2: Architecture                                  │
│      ↓                                                  │
│  ┌─────────────────────────────────────┐               │
│  │  💡 Market Research Checkpoint      │               │
│  │  "Do market research for [project]" │               │
│  │  → Go / Pivot / Kill?               │               │
│  └─────────────────────────────────────┘               │
│      ↓ (if GO)                                         │
│  Stage 3: Milestones Overview                          │
│      ↓                                                  │
│  Stage 4: Milestone Design                             │
│      ↓                                                  │
│  Stage 5: PoC Design                                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
                          ↓
              Hand off to dev-cycle
              (Claude Code)
```

## Usage

### dev-design

Start with an idea:

> "I have an idea for [description]. Let's design it."

Claude will guide you through the 5 stages, producing artifacts for each.

### market-research

After Stage 2 (or whenever you have enough context):

> "Do market research for [project-name]"

If you have Mission Control MCP connected, it will pull project data automatically.

**Output**: Market research report with Go/Pivot/Kill recommendation.

## Philosophy: 200 Users First

Both skills follow the "200 users first" principle:

- **Production-grade quality** from day one
- **Right-sized** for first 200 paying users
- **No over-engineering** — scale milestone comes after PMF
- **Validate early** — market research before heavy investment

## Mission Control Integration

If you have the Mission Control MCP enabled, `market-research` will automatically pull project context:

```
get_project(slug) extracts:
├── objective          → Product vision
├── target_market      → Target customer
├── revenue_model      → Pricing strategy
├── monthly_cost       → Cost structure
├── projected_mrr      → Revenue targets
└── architecture_summary → Technical approach
```

## vs Claude Code Skills

| Aspect | Claude Desktop | Claude Code |
|--------|----------------|-------------|
| **Output** | Artifacts | `docs/` files |
| **Invocation** | Natural language | Slash commands |
| **Best for** | Exploration, research | Implementation |
| **Skills** | dev-design, market-research | dev-design, dev-cycle |

## Building .skill Files

To rebuild the packaged `.skill` files after making changes:

```bash
./package.sh
```

## License

MIT License - see root [LICENSE](../LICENSE)
