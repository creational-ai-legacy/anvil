# PM — Knowledge

Durable per-project PM knowledge.

*See `~/.claude/skills/session-agents/references/knowledge.md` for what belongs here vs. doesn't.*

---

## Tracker

- **Mission Control MCP, slug `anvil`** (CLAUDE.md § Mission Control Integration). Tools load as `mcp__claude_ai_MC__*`. Guides: `~/Development/Mission Control/docs/PM_GUIDE.md`, `MCP_TOOLS_REFERENCE.md`.
- **`PROJECT_STATE.md`** (repo root) is the dev skill's in-repo mirror: task tables per milestone, Key Decisions, What's Next, health log. Keep it and MC aligned.
- Per-task docs: `docs/[milestone]-[task]-{design,plan,results,review}.md` (git-crypt encrypted on GitHub, readable locally).

### Drift found 2026-10-12 (open)
- MC and PROJECT_STATE both stop at 2026-06-10/11. Nine commits since (2026-07-15 → 2026-09-04) have no tracker entry: `/dev-concept` stage (`b0d000e`); `/spawn-*` retirement + `dev-usecase-author` agent (`29bb996`); TaskCreate/TodoWrite retirement (`8744951`); agent-invocability flips for dev-usecases/design/plan/ready/monitor/exam/review-skill; verify frontmatter-parity check (`d3b5a18`); Phase 0 rule re-read (`d767099`); READMEs (`0837dd6`, closes PROJECT_STATE What's Next #3).
- MC has no Marketing milestone tasks beyond `github-presence`; PROJECT_STATE lists 5 pending marketing tasks.
- MC `next_action` is stale (probe-lane live validation, /dev-finalize core-dev-usecases).

---

## Roadmap

No design-skill roadmap doc (`docs/anvil-milestones.md` doesn't exist). Milestones live in PROJECT_STATE.md: **Core** (all done) and **Marketing** (1/6).

---

## Strategic priorities

*None set by the operator yet.*

Open operator gates carried in PROJECT_STATE: genesis deploy (Stage 0 cutover + design-4stage Step 10), `/walkthrough` live smoke, probe-lane gate-open live validation, `/dev-usecases` dogfood.

---

## Stakeholder map

- **Operator** decides scope and priority and runs operator-only gates (genesis deploy, live smokes).
- **Roles here:** architect and QA (both run the baseline with no project overlay). Architect's knowledge holds dev-skill invariants (SKILL.md upward propagation, method lives in the guide, not the agent). QA's knowledge holds the verify.sh/deploy.sh pair-sync rules and the WATCH list (`docs/QA.md`).
- **Utility panes:** builder (implementation), examiner (/exam, review), git (all git ops; pack the full instruction in the body). Builder and examiner also serve as probe panes.
- **Singletons** (user-level, `~/.session-agents/`): custodian (project-local agent files), skillwright (shipped/shared skills), scheduler. They were removed as anvil project roles on 2026-10-12.
- **Advice before asking the operator:** consult peer PMs (cross-project send `[comms]PM:<project>`). session-agents PM has the most mature knowledge (routing by blast radius, machine gotchas). word-to-word PM records the operator's working style: delegate whole phases and run the questions protocol before ringing.

---

## Workflow

- Commits only via `/commit-and-push`, routed to the git pane. PM never commits.
- Edit `claude-code/`, then `./deploy.sh && ./verify.sh`. Genesis deploy is a separate operator-requested action.
- Dev pipeline: optional Stage 0 usecases → design → plan → execute → review → finalize. `/dev-ready` gates the breaks.
