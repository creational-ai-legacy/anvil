# Claude Code Skills

Skills for the **implementation phase** of idea-to-mvp, designed for Claude Code (CLI).

## Skills

| Skill | Purpose |
|-------|---------|
| **design** | 5-stage design workflow (North Star → Architecture → Milestones → Milestone Design → PoC Design) |
| **dev** | 3-stage development loop (Design → Plan → Execute) |
| **market-research** | Market validation with Go/Pivot/Kill recommendation |

## Installation

```bash
# Deploy skills and commands to ~/.claude/
./deploy.sh

# Verify deployment
./verify.sh
```

## Workflow

```
DESIGN PHASE (design skill)
─────────────────────────
/design-northstar           → Vision document
        ↓
/design-architecture        → Technical design
        ↓
/design-milestones-overview → Strategic roadmap
        ↓
/design-milestone-design    → Detailed milestone design
        ↓
/design-poc-design          → Atomic proof-of-concepts

DEVELOPMENT PHASE (dev skill)
─────────────────────────────
/dev-design                 → Analyze task (NO CODE)
        ↓
/dev-plan                   → Plan implementation steps
        ↓
/dev-execute                → Execute step-by-step with tests
        ↓
/dev-finalize               → Wrap up (timestamp + lessons + diagram + health)
        ↓
Repeat for next task
```

## Commands

### design Commands

| Command | Purpose |
|---------|---------|
| `/design-northstar` | Create vision document (Stage 1) |
| `/design-architecture` | Create architecture document (Stage 2) |
| `/design-milestones-overview` | Create milestone roadmap (Stage 3) |
| `/design-milestone-design` | Create detailed milestone design (Stage 4) |
| `/design-poc-design` | Create PoC breakdown (Stage 5) |

### dev Commands

| Command | Purpose |
|---------|---------|
| `/dev-design` | Create design document (Stage 1, NO CODE) |
| `/dev-plan` | Plan implementation steps (Stage 2) |
| `/dev-execute` | Execute step-by-step (Stage 3) |
| `/dev-lessons` | Consolidate lessons learned |
| `/dev-diagram` | Generate ASCII summary diagram |
| `/dev-finalize` | Wrap up task (timestamp + lessons + diagram + health) |
| `/milestone-details` | Generate milestone summary document |
| `/dev-health` | Project health check |

### Agent Commands

| Command | Purpose |
|---------|---------|
| `/agent-dev-design` | Design agent for Stage 1 |
| `/agent-dev-plan` | Plan agent for Stage 2 |
| `/agent-dev-execute` | Execute agent for Stage 3 |
| `/agent-dev-finalize` | Finalize agent (timestamp + lessons + diagram + health) |
| `/agent-milestone-details` | Milestone details agent |
| `/agent-verify-doc` | Document verification agent |
| `/agent-market-research` | Market research agent |

### Research Commands

| Command | Purpose |
|---------|---------|
| `/market-research` | Market validation with Go/Pivot/Kill recommendation |

### Utility Commands

| Command | Purpose |
|---------|---------|
| `/verify-doc` | Verify design or implementation documents |

## Output Files

**design skill creates:**
- `docs/[slug]-north-star.md`
- `docs/[slug]-architecture.md`
- `docs/[slug]-milestones-overview.md`
- `docs/[slug]-milestone.md`
- `docs/[slug]-poc-design.md`

**dev skill creates:**
- `docs/[milestone]-[task]-design.md`
- `docs/[milestone]-[task]-plan.md`
- `docs/[milestone]-[task]-results.md`
- `docs/[milestone]-milestone-details.md`

**market-research creates:**
- `docs/[slug]-market-research.md`

## Key Principles

- **design skill is NO-CODE** — Pure design and planning
- **dev skill allows code** — Stage 1 is design-only, Stages 2-3 allow code
- **One task at a time** — Plan and execute incrementally
- **Production-grade quality** — OOP, Pydantic, type hints, tests required
- **Self-contained work** — Each item works independently
- **200-users-first** — Right-sized for early users, scale comes later

## File Structure

```
claude-code/
├── README.md               # This file
├── deploy.sh               # Deploy to ~/.claude/
├── verify.sh               # Verify deployment
├── sync-from-user.sh       # Sync from deployed skills
│
└── [skill-name]/           # Each skill follows this structure
    ├── SKILL.md            # Skill definition (required)
    ├── commands/           # Slash commands (deployed to ~/.claude/commands/)
    ├── agents/             # Subagents (deployed to ~/.claude/agents/)
    ├── assets/templates/   # Output templates
    └── references/         # Detailed guides
```

**Current skills:** design, dev, market-research

**Deploys to:**
- `~/.claude/skills/[skill-name]/` (SKILL.md, assets/, references/)
- `~/.claude/commands/` (collected from all skill commands/ folders)
- `~/.claude/agents/` (collected from all skill agents/ folders)

## Development

### Making Changes

1. Edit files in this folder
2. Deploy: `./deploy.sh`
3. Test in Claude Code

### Sync from Deployed

If you made changes directly in `~/.claude/`:

```bash
./sync-from-user.sh
```

## License

MIT License - see root [LICENSE](../LICENSE)
