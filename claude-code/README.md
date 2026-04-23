# Claude Code Skills

Skills for the **implementation phase** of Anvil, designed for Claude Code (CLI).

## Skills

| Skill | Purpose |
|-------|---------|
| **design** | 5-stage design workflow (Vision → Architecture → Roadmap → Milestone Spec → Task Spec) |
| **dev** | 3-stage development loop (Design → Plan → Execute) |
| **research** | Market validation and naming research |
| **review** | Quality assurance (doc review + skill review) |

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
/design-vision              → Vision document
        ↓
/design-architecture        → Technical design
        ↓
/design-roadmap             → Strategic roadmap
        ↓
/design-milestone-spec      → Detailed milestone spec
        ↓
/design-task-spec           → Atomic tasks with dependencies

DEVELOPMENT PHASE (dev skill)
─────────────────────────────
/dev-design                 → Analyze task (NO CODE)
        ↓
/dev-plan                   → Plan implementation steps
        ↓
/dev-execute                → Execute one step with tests
        ↓ (or)
/dev-execute-run            → Run all steps to completion (auto-finalize)
        ↓
/dev-finalize               → Wrap up (timestamp + lessons + diagram + health)
        ↓
Repeat for next task
```

## Most Common Workflow

The typical dev task workflow with review loops:

```
1.  /dev-design <description>                Design analysis (no code)
2.  /review-doc-run <design doc> --auto      Review until solid (repeat as needed)
3.  /dev-plan <design doc>                   Create implementation steps
4.  /review-doc-run <plan doc> --auto        Review until solid (repeat as needed)
5.  /dev-execute-run                         Execute all steps + auto-finalize
6.  /dev-review-run <results doc>            Conceptual review of completed work
```

**Steps 2 and 4** are iterative — run reviews until all items are clean, fixing issues between rounds. The `--auto` flag auto-applies suggested fixes.

**Step 5** runs all plan steps sequentially, then auto-finalizes (timestamp, lessons, diagram, health check).

**Step 6** is optional but recommended — catches intent drift, silent assumptions, and architectural issues across the completed implementation.

## Commands

### design Commands

| Command | Purpose |
|---------|---------|
| `/design-vision` | Create vision document (Stage 1) |
| `/design-architecture` | Create architecture document (Stage 2) |
| `/design-roadmap` | Create milestone roadmap (Stage 3) |
| `/design-milestone-spec` | Create detailed milestone spec (Stage 4) |
| `/design-task-spec` | Create task spec (Stage 5) |

### dev Commands

| Command | Purpose |
|---------|---------|
| `/dev-design` | Create design document (Stage 1, NO CODE) |
| `/dev-plan` | Plan implementation steps (Stage 2) |
| `/dev-execute` | Execute one step (Stage 3) |
| `/dev-execute-run` | Run all steps to completion (auto-finalize) |
| `/dev-review` | Review completed step against design |
| `/dev-review-run` | Review all completed steps in parallel |
| `/dev-diagram` | Generate ASCII summary diagram |
| `/dev-finalize` | Wrap up task (timestamp + lessons + diagram + health) |
| `/dev-milestone-summary` | Generate milestone summary document |
| `/dev-health` | Project health check |

### Spawn Commands (Background Agents)

| Command | Purpose |
|---------|---------|
| `/spawn-dev-designer` | Design agent for Stage 1 |
| `/spawn-dev-planner` | Plan agent for Stage 2 |
| `/spawn-dev-executor` | Execute agent for Stage 3 |
| `/spawn-dev-reviewer` | Review agent for conceptual review |
| `/spawn-dev-finalizer` | Finalize agent (timestamp + lessons + diagram + health) |
| `/spawn-dev-milestone-summarizer` | Milestone summary agent |
| `/spawn-market-researcher` | Market research agent |
| `/spawn-naming-researcher` | Naming research agent |
| `/spawn-doc-reviewer` | Document review agent (supports --auto) |
| `/spawn-skill-reviewer` | Skill review agent |

### Research Commands

| Command | Purpose |
|---------|---------|
| `/market-research` | Market validation with Go/Pivot/Kill recommendation |
| `/naming-research` | Research and evaluate product/project name candidates |

### Review Commands

| Command | Purpose |
|---------|---------|
| `/review-doc` | Sequential document review (supports --auto) |
| `/review-doc-run` | Parallel document review with background subagents (supports --auto) |
| `/review-doc-loop` | Tick-driven loop that pairs with `/exam-loop` (long-running, main conversation only) |
| `/review-skill` | Audit skills for structure, frontmatter, and consistency |
| `/exam-loop` | Tick-driven loop that pairs with `/review-doc-loop` (long-running, main conversation only) |

## Output Files

**design skill creates:**
- `docs/[slug]-vision.md`
- `docs/[slug]-architecture.md`
- `docs/[slug]-roadmap.md`
- `docs/[slug]-milestone-spec.md`
- `docs/[slug]-task-spec.md`

**dev skill creates:**
- `docs/[milestone]-[task]-design.md`
- `docs/[milestone]-[task]-plan.md`
- `docs/[milestone]-[task]-results.md`
- `docs/[milestone]-milestone-summary.md`

**research creates:**
- `docs/[slug]-market-research.md`
- `docs/naming-research.md`

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

**Current skills:** design, dev, research, review

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
