# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repo contains skills for both Claude Code and Claude Desktop:

**Claude Code** (`claude-code/`):
1. **dev-design** - Design phase (concept to executable plan)
2. **dev-cycle** - Development loop (plan to working code)
3. **market-research** - Market validation with Go/Pivot/Kill recommendation

**Claude Desktop** (`claude-desktop/`):
1. **dev-design** - Same 5-stage design workflow (outputs artifacts)
2. **market-research** - Market validation with Go/Pivot/Kill recommendation

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
    ├── unpackage.sh            # Extract .skill files
    ├── dev-design/             # Design skill (v1.5.0)
    ├── market-research/        # Market validation (v1.1.0)
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

If you made changes in `~/.claude/skills/dev-design/`, `~/.claude/skills/dev-cycle/`, or `~/.claude/commands/`:

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
```

## File Naming Conventions

**dev-design creates:**
- `[slug]-north-star.md` - Vision and goals (e.g., `mc-north-star.md`)
- `[slug]-architecture.md` - Architecture (e.g., `mc-architecture.md`)
- `[slug]-milestones-overview.md` - Strategic milestone roadmap
- `[slug]-milestone.md` - Detailed milestone design (e.g., `core-milestone.md`)
- `[slug]-poc-design.md` - PoC plan (e.g., `core-poc-design.md`)

**dev-cycle creates:**
- `PROJECT_STATE.md` - Task and milestone tracking
- `docs/[milestone-slug]-[task-slug]-overview.md` - Feature/bug design analysis
- `docs/[milestone-slug]-[task-slug]-implementation.md` - Implementation guide
- `docs/[milestone-slug]-[task-slug]-results.md` - Progress tracking
- `tests/test_[task-slug]_*.py` - Tests grouped by task

## Templates

**dev-design** (`claude-code/dev-design/assets/templates/`):
- `north-star.md` - Stage 1 template
- `architecture.md` - Stage 2 template
- `milestones-overview.md` - Stage 3 template
- `milestone-design.md` - Stage 4 template
- `poc-design.md` - Stage 5 template

**dev-cycle** (`claude-code/dev-cycle/assets/templates/`):
- `overview.md` - Stage 1 output
- `implementation-plan.md` - Stage 2 output
- `implementation-results.md` - Stage 3 output
- `lessons-learned.md` - Lessons consolidation
- `diagram.md` - Task diagram template
- `milestone-details.md` - Milestone summary template

## Reference Guides

**dev-design** (`claude-code/dev-design/references/`):
- `1-north-star-guide.md` through `5-poc-design-guide.md`

**dev-cycle** (`claude-code/dev-cycle/references/`):
- `1-overview-guide.md` through `3-execution-guide.md`
- `lessons-guide.md`, `diagram-guide.md`, `milestone-details-guide.md`
- `verify-doc-guide.md`

## Slash Commands

**dev-design commands**:
- `/design-northstar` - Create vision document (Stage 1)
- `/design-architecture` - Create architecture document (Stage 2)
- `/design-milestones-overview` - Create milestone roadmap (Stage 3)
- `/design-milestone-design` - Create detailed milestone design (Stage 4)
- `/design-poc-design` - Create PoC breakdown (Stage 5)

**dev-cycle commands**:
- `/dev-overview` - Create high-level design (Stage 1)
- `/dev-plan` - Plan implementation steps (Stage 2)
- `/dev-execute` - Execute step-by-step (Stage 3)
- `/dev-lessons` - Consolidate lessons learned
- `/dev-diagram` - Generate task diagram
- `/dev-finalize` - Wrap up task (timestamp + lessons + diagram)
- `/dev-milestone-details` - Generate milestone summary
- `/small-win-check` - Project health check

**Agent commands**:
- `/agent-dev-plan` - Plan agent for Stage 2
- `/agent-dev-execute` - Execute agent for Stage 3
- `/agent-dev-milestone-details` - Milestone details agent
- `/agent-verify-doc` - Document verification agent
- `/agent-market-research` - Market research agent

**Research commands**:
- `/market-research` - Market validation with Go/Pivot/Kill recommendation

**Utility commands**:
- `/verify-doc` - Document verification

Commands are deployed to `~/.claude/commands/`

## Deployment

**Claude Code**: `claude-code/deploy.sh` deploys to:
- `~/.claude/skills/dev-design/`
- `~/.claude/skills/dev-cycle/`
- `~/.claude/skills/market-research/`
- `~/.claude/commands/` (collected from each skill's `commands/` folder)
- `~/.claude/agents/`

**Claude Desktop**: `claude-desktop/package.sh` creates:
- `releases/dev-design.skill`
- `releases/market-research.skill`

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
- dev-design is pure design (NO CODE)
- dev-cycle allows code (Stage 1 is design-only, Stages 2-3 allow code)
