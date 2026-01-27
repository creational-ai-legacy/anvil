# Claude Desktop Skills

Skills for the **design and validation phase** of idea-to-mvp, optimized for Claude Desktop (claude.ai).

## Skills

| Skill | Version | Purpose |
|-------|---------|---------|
| **design** | 1.5.0 | 5-stage design workflow (North Star → Architecture → Milestones → Milestone Design → PoC Design) |
| **market-research** | 1.1.0 | Market validation with Go/Pivot/Kill recommendation |
| **business-validation** | 1.1.0 | Business validation roadmaps with PoC-based experiments |
| **framework-alignment** | 1.0.0 | Strategic framework analysis (Four Loops, Flywheel, Dangerous Intelligence) |

## Installation

### Option 1: Import .skill files (Recommended)

1. Download from `releases/`:
   - `design.skill`
   - `market-research.skill`
   - `business-validation.skill`
   - `framework-alignment.skill`

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
              Hand off to dev
              (Claude Code)
```

## Usage

### design

Start with an idea:

> "I have an idea for [description]. Let's design it."

Claude will guide you through the 5 stages, producing artifacts for each.

### market-research

After Stage 2 (or whenever you have enough context):

> "Do market research for [project-name]"

If you have Mission Control MCP connected, it will pull project data automatically.

**Output**: Market research report with Go/Pivot/Kill recommendation.

### business-validation

When you need to figure out the path to revenue:

> "How do I make money with [project]?"
> "What's blocking me from launching?"
> "Who would pay for this?"

Pulls full context from Mission Control (project → milestones → tasks), challenges assumptions, identifies real blockers.

**Output**: Business validation roadmap with PoC-based experiments and success criteria.

### framework-alignment

When you need strategic alignment analysis:

> "Framework alignment for [project]"
> "Are we building the right loops?"
> "What signals are we missing?"
> "How do we build a moat?"

Analyzes against Three Strategic Frameworks (Four Loops, Flywheel, Dangerous Intelligence). Identifies signal infrastructure gaps.

**Output**: Framework alignment doc with net inventory and implementation priorities.

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
| **Skills** | design, market-research, business-validation, framework-alignment | design, dev, market-research |

## Development

### Editing in Claude Desktop → Repo

If you edited skills in Claude Desktop and exported new `.skill` files:

```bash
# 1. Export .skill files from Claude Desktop to releases/

# 2. Unpackage (single skill or all)
./unpackage.sh releases/my-skill.skill   # Single skill (new or update)
./unpackage.sh                            # All skills

# 3. Review changes
git status
```

### Editing in Repo → Claude Desktop

If you edited source folders directly:

```bash
# 1. Package source folders into .skill files
./package.sh

# 2. Import .skill files in Claude Desktop
#    Settings → Skills → Import Skill
```

### Scripts

| Script | Purpose |
|--------|---------|
| `package.sh` | Source folders → `.skill` files |
| `unpackage.sh [file]` | `.skill` files → Source folders (single or all) |

## License

MIT License - see root [LICENSE](../LICENSE)
