# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo contains skills for both Claude Code and Claude Desktop:

**Claude Code** (`claude-code/`):
1. **design** - Design phase (concept to executable plan)
2. **dev** - Development loop (plan to working code)
3. **market-research** - Market validation with Go/Pivot/Kill recommendation

**Claude Desktop** (`claude-desktop/`):
1. **dev-design** - Same 5-stage design workflow (outputs artifacts)
2. **market-research** - Market validation with Go/Pivot/Kill recommendation
3. **business-validation** - Business validation roadmaps with PoC-based experiments
4. **framework-alignment** - Strategic framework analysis (Four Loops, Flywheel, Dangerous Intelligence)

## Repo Structure

```
idea-to-mvp/
├── README.md                   # Overview linking both environments
├── LICENSE
│
├── claude-code/                # Claude Code skills
│   ├── README.md               # CC-specific documentation
│   ├── deploy.sh               # Deploy skills and commands
│   ├── verify.sh               # Verify deployment
│   ├── sync-from-user.sh       # Sync from deployed skills
│   └── [skill-name]/           # Each skill follows this structure
│       ├── SKILL.md            # Skill definition (required)
│       ├── commands/           # Slash commands
│       ├── agents/             # Subagents (optional)
│       ├── assets/templates/   # Output templates
│       └── references/         # Detailed guides
│
└── claude-desktop/             # Claude Desktop skills
    ├── README.md               # CD-specific documentation
    ├── package.sh              # Build .skill files
    ├── unpackage.sh            # Extract .skill files (single or all)
    ├── dev-design/             # Design skill (v1.5.0)
    ├── market-research/        # Market validation (v1.1.0)
    ├── business-validation/    # Business validation (v1.1.0)
    ├── framework-alignment/    # Framework analysis (v1.0.0)
    └── releases/               # Packaged .skill files
```

## Development Workflow (Claude Code)

### Making Changes

1. **Edit files in `claude-code/`** (not in `~/.claude/skills/`)
2. **Test locally** if needed
3. **Deploy**:
   ```bash
   cd claude-code
   ./deploy.sh
   ```
4. **Commit and push**: Standard git workflow

### Sync from Deployed Skills

If you made changes in `~/.claude/skills/design/`, `~/.claude/skills/dev/`, or `~/.claude/commands/`:

```bash
cd claude-code
./sync-from-user.sh
git status  # Review changes
```

## Key Commands

```bash
# Deploy Claude Code skills and commands
cd claude-code
./deploy.sh

# Verify deployment
./verify.sh

# Sync changes back from deployed skills
./sync-from-user.sh

# Package Claude Desktop skills
cd claude-desktop
./package.sh

# Unpackage Claude Desktop skills (after exporting from CD)
./unpackage.sh releases/my-skill.skill   # Single skill (new or update)
./unpackage.sh                            # All skills
```

## File Naming Conventions

**design skill creates:**
- `[slug]-north-star.md` - Vision and goals (e.g., `mc-north-star.md`)
- `[slug]-architecture.md` - Architecture (e.g., `mc-architecture.md`)
- `[slug]-milestones-overview.md` - Strategic milestone roadmap
- `[slug]-milestone.md` - Detailed milestone design (e.g., `core-milestone.md`)
- `[slug]-poc-design.md` - PoC plan (e.g., `core-poc-design.md`)

**dev skill creates:**
- `PROJECT_STATE.md` - Task and milestone tracking
- `docs/[milestone-slug]-[task-slug]-design.md` - Feature/bug design analysis
- `docs/[milestone-slug]-[task-slug]-plan.md` - Implementation guide
- `docs/[milestone-slug]-[task-slug]-results.md` - Progress tracking
- `tests/test_[task-slug]_*.py` - Tests grouped by task

## Templates

**design** (`claude-code/design/assets/templates/`):
- `north-star.md` - Stage 1 template
- `architecture.md` - Stage 2 template
- `milestones-overview.md` - Stage 3 template
- `milestone-design.md` - Stage 4 template
- `poc-design.md` - Stage 5 template

**dev** (`claude-code/dev/assets/templates/`):
- `design.md` - Stage 1 output (Problem Analysis + Proposed Steps)
- `plan.md` - Stage 2 output
- `results.md` - Stage 3 output
- `lessons-learned.md` - Lessons consolidation
- `diagram.md` - Task diagram template
- `milestone-details.md` - Milestone summary template

## Reference Guides

**design** (`claude-code/design/references/`):
- `1-north-star-guide.md` through `5-poc-design-guide.md`

**dev** (`claude-code/dev/references/`):
- `1-design-guide.md` through `3-execution-guide.md`
- `lessons-guide.md`, `diagram-guide.md`, `milestone-details-guide.md`
- `verify-doc-guide.md`

## Slash Commands

**design commands**:
- `/design-northstar` - Create vision document (Stage 1)
- `/design-architecture` - Create architecture document (Stage 2)
- `/design-milestones-overview` - Create milestone roadmap (Stage 3)
- `/design-milestone-design` - Create detailed milestone design (Stage 4)
- `/design-poc-design` - Create PoC breakdown (Stage 5)

**dev commands**:
- `/dev-design` - Create design document (Stage 1)
- `/dev-plan` - Plan implementation steps (Stage 2)
- `/dev-execute` - Execute step-by-step (Stage 3)
- `/dev-lessons` - Consolidate lessons learned
- `/dev-diagram` - Generate task diagram
- `/dev-finalize` - Wrap up task (timestamp + lessons + diagram + health)
- `/milestone-details` - Generate milestone summary
- `/dev-health` - Project health check (standalone, also included in finalize)

**Agent commands**:
- `/agent-dev-design` - Design agent for Stage 1
- `/agent-dev-plan` - Plan agent for Stage 2
- `/agent-dev-execute` - Execute agent for Stage 3
- `/agent-dev-finalize` - Finalize agent (timestamp + lessons + diagram + health)
- `/agent-milestone-details` - Milestone details agent
- `/agent-verify-doc` - Document verification agent
- `/agent-market-research` - Market research agent

**Research commands**:
- `/market-research` - Market validation with Go/Pivot/Kill recommendation

**Utility commands**:
- `/verify-doc` - Document verification

Commands are deployed to `~/.claude/commands/`

## Deployment

**Claude Code**: `claude-code/deploy.sh` deploys to:
- `~/.claude/skills/design/`
- `~/.claude/skills/dev/`
- `~/.claude/skills/market-research/`
- `~/.claude/commands/` (collected from each skill's `commands/` folder)
- `~/.claude/agents/`

**Claude Desktop**: `claude-desktop/package.sh` creates:
- `releases/dev-design.skill`
- `releases/market-research.skill`
- `releases/business-validation.skill`
- `releases/framework-alignment.skill`

## Git Workflow

```bash
# Standard workflow
git add .
git commit -m "Description"
git push
```

**Remote**: `git@github-creational:creational-ai/idea-to-mvp.git`

## Contributing Guidelines

- Keep each skill's SKILL.md as the source of truth
- Templates should be generic (no project-specific content)
- References provide detailed stage guidance
- Test slash commands after changes
- Deploy before pushing to verify changes work
- design skill is pure design (NO CODE)
- dev skill allows code (Stage 1 is design-only, Stages 2-3 allow code)

---

## Mission Control Integration

**This project is tracked in Mission Control portfolio system.**

When using Mission Control MCP tools (`mcp__mission-control__*`) to manage tasks, milestones, or project status, you are acting as the **PM (Project Manager) role**. Read these docs to understand the workflow, timestamp conventions, and scope:

- **Slug:** `idea-to-mvp`
- **Role:** PM (Project Manager)
- **Read 1st:** [PM_GUIDE.md](file:///Users/docchang/Development/Mission%20Control/docs/PM_GUIDE.md)
- **Read 2nd:** [MCP_TOOLS_REFERENCE.md](file:///Users/docchang/Development/Mission%20Control/docs/MCP_TOOLS_REFERENCE.md)

---
