# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Anvil** — A production-grade product engineering toolkit for Claude Code and Claude Desktop.

**Claude Code** (`claude-code/`):
1. **design** - Design phase (concept to executable plan)
2. **dev** - Development loop (plan to working code)
3. **research** - Market validation and naming research
4. **review** - Quality assurance (doc review + skill review)

**Claude Desktop** (`claude-desktop/`):
1. **design** - Same 5-stage design workflow (outputs artifacts)
2. **market-research** - Market validation with Go/Pivot/Kill recommendation
3. **business-validation** - Business validation roadmaps with PoC-based experiments
4. **framework-alignment** - Strategic framework analysis (Four Loops, Flywheel, Dangerous Intelligence)

## Repo Structure

```
anvil/
├── README.md                   # Overview linking both environments
├── LICENSE
│
├── claude-code/                # Claude Code skills
│   ├── README.md               # CC-specific documentation
│   ├── deploy.sh               # Deploy skills and commands (local)
│   ├── deploy-genesis.sh       # Deploy skills to genesis (Raspberry Pi)
│   ├── verify.sh               # Verify deployment (local)
│   ├── verify-genesis.sh       # Verify deployment (genesis)
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
    ├── design/                 # Design skill (v2.0.0)
    ├── market-research/        # Market validation (v1.1.0)
    ├── business-validation/    # Business validation (v1.1.0)
    ├── framework-alignment/    # Framework analysis (v1.0.0)
    └── releases/               # Packaged .skill files
```

## Development Workflow (Claude Code)

### Making Changes

1. **Edit files in `claude-code/`** (NEVER edit `~/.claude/skills/` directly)
2. **Test locally** if needed
3. **Deploy**:
   ```bash
   cd claude-code
   ./deploy.sh
   ```
4. **Commit and push**: Standard git workflow

**IMPORTANT**: Always edit the source in `claude-code/`, then deploy. Never edit deployed files in `~/.claude/skills/` — they get overwritten on deploy.

**IMPORTANT**: `deploy-genesis.sh` is a SEPARATE manual action. Do NOT run it as part of "deploy and verify" or any routine deploy. Only run it when the user explicitly asks to deploy to genesis.

**IMPORTANT - Keep local/genesis pairs in sync**: `deploy.sh` ↔ `deploy-genesis.sh` and `verify.sh` ↔ `verify-genesis.sh` must stay mirrored. Whenever you edit one, apply the same change to its pair. The `SKILLS`, `OLD_SKILLS`, `OLD_COMMANDS`, `OLD_AGENTS`, `REQUIRED_COMMANDS`, and `REQUIRED_AGENTS` arrays must match across the pair (genesis scripts just target a remote host via SSH/SCP). Drift between local and genesis means genesis deploys will be stale or miss cleanup.

## Key Commands

```bash
# Deploy Claude Code skills and commands (local)
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
- `docs/[slug]-vision.md` - Vision and goals (e.g., `docs/mc-vision.md`)
- `docs/[slug]-architecture.md` - Architecture (e.g., `docs/mc-architecture.md`)
- `docs/[slug]-roadmap.md` - Strategic milestone roadmap
- `docs/[slug]-milestone-spec.md` - Detailed milestone spec (e.g., `docs/core-milestone-spec.md`)
- `docs/[slug]-task-spec.md` - Task spec (e.g., `docs/core-task-spec.md`)
- `docs/naming-research.md` - Naming research

**dev skill creates:**
- `PROJECT_STATE.md` - Task and milestone tracking
- `docs/[milestone-slug]-[task-slug]-design.md` - Feature/bug design analysis
- `docs/[milestone-slug]-[task-slug]-plan.md` - Implementation guide
- `docs/[milestone-slug]-[task-slug]-results.md` - Progress tracking
- `docs/[milestone]-milestone-summary.md` - Milestone summary
- `tests/` - Tests per environment conventions (e.g., Python: `test_[task-slug]_*.py`)

## Templates

**design** (`claude-code/design/assets/templates/`):
- `1-vision.md` - Stage 1 template
- `2-architecture.md` - Stage 2 template
- `3-roadmap.md` - Stage 3 template
- `4-milestone-spec.md` - Stage 4 template
- `5-task-spec.md` - Stage 5 template

**dev** (`claude-code/dev/assets/templates/`):
- `1-design.md` - Stage 1 output (Problem Analysis + Proposed Steps)
- `2-plan.md` - Stage 2 output
- `3-results.md` - Stage 3 output
- `PROJECT_STATE.md` - Project tracking template
- `lessons-learned.md` - Lessons consolidation
- `diagram.md` - Task diagram template
- `milestone-summary.md` - Milestone summary template

## Reference Guides

**design** (`claude-code/design/references/`):
- `1-vision-guide.md` through `5-task-spec-guide.md`

**dev** (`claude-code/dev/references/`):
- `1-design-guide.md` through `3-execution-guide.md`
- `review-guide.md` - Conceptual review process (Stage 3b)
- `python-guide.md` - Python environment guide
- `unity-guide.md` - Unity/C# environment guide
- `lessons-guide.md`, `diagram-guide.md`, `milestone-summary-guide.md`
- `health-guide.md`

**review** (`claude-code/review/references/`):
- `review-doc-guide.md` - Sequential document review guide
- `review-doc-run-guide.md` - Parallel document review orchestrator guide
- `review-item-guide.md` - Per-item review checks
- `review-holistic-guide.md` - Cross-cutting review checks
- `skill-review-guide.md` - Skill auditing guide
- `exam-guide.md` - Independent examination guide (review + monitor modes)
- `review-loop-guide.md` - Tick-driven loop guide for /review-doc-run-loop and /exam-loop (single source of truth for loop mechanics)

**research** (`claude-code/research/references/`):
- `market-research-guide.md` - Market research process guide
- `naming-research-guide.md` - Naming research guide

## Slash Commands

**design commands**:
- `/design-vision` - Create vision document (Stage 1)
- `/design-architecture` - Create architecture document (Stage 2)
- `/design-roadmap` - Create milestone roadmap (Stage 3)
- `/design-milestone-spec` - Create detailed milestone spec (Stage 4)
- `/design-task-spec` - Create task spec (Stage 5)

**dev commands**:
- `/dev-design` - Create design document (Stage 1)
- `/dev-plan` - Plan implementation steps (Stage 2)
- `/dev-execute` - Execute one step (Stage 3)
- `/dev-execute-run` - Run all steps to completion (auto-finalize, `--auto` adds review-run + mc-update)
- `/dev-review` - Review completed step against design (conceptual review)
- `/dev-review-run` - Review all completed steps in parallel
- `/dev-diagram` - Generate task diagram
- `/dev-finalize` - Wrap up task (timestamp + lessons + diagram + health)
- `/dev-milestone-summary` - Generate milestone summary
- `/dev-health` - Project health check (standalone, also included in finalize)

**Spawn commands** (run in background via subagents):
- `/spawn-dev-designer` - Design agent for Stage 1
- `/spawn-dev-planner` - Plan agent for Stage 2
- `/spawn-dev-executor` - Execute agent for Stage 3
- `/spawn-dev-reviewer` - Review agent for conceptual review (Stage 3b)
- `/spawn-dev-finalizer` - Finalize agent (timestamp + lessons + diagram + health)
- `/spawn-dev-milestone-summarizer` - Milestone summary agent
- `/spawn-market-researcher` - Market research agent
- `/spawn-naming-researcher` - Naming research agent
- `/spawn-doc-reviewer` - Document review agent (supports --auto)
- `/spawn-skill-reviewer` - Skill review agent

**Research commands**:
- `/market-research` - Market validation with Go/Pivot/Kill recommendation
- `/naming-research` - Research and evaluate product/project name candidates

**Review commands**:
- `/review-doc` - Sequential document review (supports --auto)
- `/review-doc-run` - Parallel document review with background subagents (supports --auto)
- `/review-doc-run-loop` - Tick-driven loop that coordinates with `/exam-loop` via the shared review doc (long-running, main conversation only)
- `/review-skill` - Audit a skill for structure, frontmatter, and consistency
- `/exam` - Independent critical examination of a document
- `/exam-loop` - Tick-driven loop that coordinates with `/review-doc-run-loop` via the shared review doc (long-running, main conversation only)
- `/monitor` - Monitor execution progress with periodic status reports

Commands are deployed to `~/.claude/commands/`

## Deployment

**Claude Code (local)**: `claude-code/deploy.sh` deploys to:
- `~/.claude/skills/design/`
- `~/.claude/skills/dev/`
- `~/.claude/skills/research/`
- `~/.claude/skills/review/`
- `~/.claude/commands/` (collected from each skill's `commands/` folder)
- `~/.claude/agents/`

**Claude Code (genesis)**: `claude-code/deploy-genesis.sh` deploys the same skills to `genesis:/home/pi/.claude/` via SSH. `claude-code/verify-genesis.sh` validates the remote deployment (mirrors `verify.sh` via SSH). Keep the local/genesis pairs in sync — see "Keep local/genesis pairs in sync" note above.

**Claude Desktop**: `claude-desktop/package.sh` creates:
- `releases/design.skill`
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

**Remote**: `git@github-creational:creational-ai/anvil.git`

### git-crypt

`docs/` is encrypted with git-crypt (appears as binary blobs on GitHub, readable locally).

- **Config**: `.gitattributes` defines encrypted paths
- **Check status**: `git-crypt status -e` (list encrypted files)
- **New clone**: `git-crypt unlock` after cloning (requires GPG key for `dominic@creational.ai`)
- **Adding encrypted paths**: Edit `.gitattributes`, add pattern with `filter=git-crypt diff=git-crypt`

## Contributing Guidelines

- Keep each skill's SKILL.md as the source of truth
- Templates should be generic (no project-specific content)
- References provide detailed stage guidance
- Test slash commands after changes
- Deploy before pushing to verify changes work
- **Severity / risk / probability / confidence labels**: Always use `HIGH / MED / LOW` (uppercase, abbreviated). Never use `Medium`, `H/M/L`, `High/Medium/Low`, or other variations.
- design skill is pure design (NO CODE)
- dev skill allows code (Stage 1 is design-only, Stages 2-3 allow code)

**Agent `tools` field gotcha**: Do NOT add a `tools` field to agents that need MCP tools (e.g., `dev-executor`). Specifying `tools` in agent frontmatter creates an allowlist that **excludes** all MCP tools (UnityMCP, mission-control, etc.). Omitting `tools` entirely lets the agent inherit ALL tools including MCP. This is intentional — execution agents work across different projects with different MCP servers, so the tool set cannot be hardcoded.

---

## Mission Control Integration

**This project is tracked in Mission Control portfolio system.**

When using Mission Control MCP tools (`mcp__mission-control__*`) to manage tasks, milestones, or project status, you are acting as the **PM (Project Manager) role**. Read these docs to understand the workflow, timestamp conventions, and scope:

- **Slug:** `anvil`
- **Role:** PM (Project Manager)
- **Read 1st:** [PM_GUIDE.md](file:///Users/docchang/Development/Mission%20Control/docs/PM_GUIDE.md)
- **Read 2nd:** [MCP_TOOLS_REFERENCE.md](file:///Users/docchang/Development/Mission%20Control/docs/MCP_TOOLS_REFERENCE.md)

---
