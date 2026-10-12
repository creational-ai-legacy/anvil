# QA — Knowledge

Durable per-project QA knowledge for anvil.

*See `~/.claude/skills/session-agents/references/knowledge.md` for what belongs here vs. doesn't.*

---

## Project type

Anvil is a **skills/commands/agents repository** (markdown + shell), not a service. Production "code" = `claude-code/dev/SKILL.md`, command files, agent files, references, templates, and the `deploy.sh` / `verify.sh` pair. There is no pytest/Jest unit suite — the "test framework" is `deploy.sh + verify.sh + structural greps`.

## Test layer mapping

- **L1 unit** — N/A. No code. Skill-modification tasks are exercised by structural greps against the post-deploy state.
- **L2 integration** — `claude-code/verify.sh` structural checks, incl. workflow byte-identity + `*-guard.sh` runs. Current check count lives in `docs/QA.md` § header (don't restate it here — second staleness surface). Per-task ACs add anchored greps (e.g., `grep -E '^> \*\*Goal doc\*\*' template.md`) — anchored regexes catch structural drift that bare greps miss. Every count delta must trace to a landed commit (history: 74→75 `218143f` dev-goal; 75→78 = `585e593` dev-ready + `14c905d` workflows ×2); a finding, if filed, names the coverage change (which checks appeared/disappeared — diff the pass-line set), never the raw number.
- **L3 live** — Operator-driven slash-command invocations in main conversation. Any command marked `disable-model-invocation: true` cannot be exercised by a spawned executor or QA agent; smoke is operator-only.
- **L4 real-substrate** — N/A. No external services or paid APIs.

## Authoritative refs (cross-layer constants)

Modules that own values spanning multiple surfaces — verify by import or grep against the source-of-truth, never by literal copy.

- **`verify.sh` `REQUIRED_COMMANDS` array** — pair-synced byte-identical with `verify-genesis.sh`. Check via `diff <(sed -n '/^REQUIRED_COMMANDS=(/,/^)/p' verify.sh) <(sed -n '/^REQUIRED_COMMANDS=(/,/^)/p' verify-genesis.sh)`. The plan-prescribed `grep -A N` form is leaky (matches consumer-loop site too); always use sed-range extraction. Pair-sync is array-content-level, not whole-file-equality (consumer-loop bodies legitimately differ: `COMMANDS_DIR` vs `r_file_exists`).
- **`deploy.sh` `SKILLS` / `OLD_SKILLS` / `OLD_AGENTS` / `OLD_COMMANDS` arrays** — same pair-sync rule. **OLD_COMMANDS is a deletion list** (runs `rm -f` on every entry); never add a still-live command to it. Auto-discovery via `cp -r commands/*.md` means new command files in source are deployed automatically — no deploy-script edit needed.
- **Usecases-doc file path `docs/[milestone-slug]-[task-slug]-usecases.md`** (replaced goal-doc path 2026-06-10, core-dev-usecases hard cutover) — no single SoT module; literal duplicated across ~12 surfaces (dev SKILL.md, CLAUDE.md, 4 dev agents, `1-design.md` + `2-plan.md` templates, `dev-usecases.md` command, ready trio, exam-guide recognition row, walkthrough Tier-2 row). Any future rename must propagate to all (WATCH W4). The cutover proved the watch: the rename needed a 4-pattern residue sweep + per-file allowlist to land clean.
- **Workflows component (added `14c905d`)** — `deploy.sh` copies each skill's `workflows/*.js` to `~/.claude/workflows/` (copy, not symlink); `verify.sh` asserts deployed copy is byte-identical to source AND runs each `workflows/*-guard.sh` (e.g. `review-loop-guard.sh` asserts guide-section anchors the JS points at still exist). Companion `*-guard.sh` files stay in source, never deployed. Genesis pair mirrors both. Editing a workflow `.js` without re-running `./deploy.sh` = guaranteed verify failure (byte-identity drift).
- **Doc-type vocabulary SoT** — the recognition tables (`review-doc-guide.md`, `review-doc-run-guide.md`, `exam-guide.md` § Document Type Recognition) own the 4-stage doc-type names (Vision, Architecture, Milestones, Tasks, Goal, Task Design, Plan, Results, Milestone Summary). Prose/agent labels normalize TO the tables ("code wins"), never the reverse. Established in the review-skill audit fix (2026-06-07).

## QA standing rules specific to anvil

- **Never declare a skill-modification task GO if source artifacts are untracked in git.** PROJECT_STATE.md saying "Complete" is necessary but not sufficient — `git ls-files` must show the new files. A fresh clone deploying must pass the full verify suite (current count in `docs/QA.md` § header). Filed as MED against core-goal-doc (2026-05-27).
- **Operator-only smoke for `disable-model-invocation: true` commands.** Stage 0 (`/dev-goal`) and any other operator-interactive command cannot be exercised by a spawned executor or QA. Document the smoke pattern in the per-task QA memo; let the operator run it. Don't try to fake it. **The documented smoke pattern must name its evidence check** — expected artifact path + anchored grep (+ `git status` for new files) — so pass/fail is verifiable by QA after the operator runs it, not just asserted.
- **Anchored greps for placement assertions.** When verifying "the right string is in the right place," use regexes that anchor BOTH content AND structural context (e.g., `^> \*\*X\*\*` anchors the blockquote prefix + bold marker). Bare `grep "X"` is paper-test territory.
- **Conditional-emission templates need agent-side strip-on-absence instruction.** When a template carries an unconditional line that should only appear under a condition (e.g., the `> **Goal doc**:` citation), the consuming agent's body must explicitly instruct strip-on-absence. Without it, every task that doesn't meet the condition carries an orphan citation. Verify the agent paragraph exists with the exact "remove the line" instruction.
- **Refactor-propagation sweeps are cross-skill, not per-skill — and never `--include='*.md'`.** When a refactor retires vocabulary, grep the retired terms across ALL skills and ALL file types: the review skill carried stale labels from the design skill's refactor (`9ab3460`), and the 2026-06-07 `.md`-scoped fix itself missed a "(Task Spec)" residual inside `review-loop.js` (workflow JS carries agent-prompt prose). One unrestricted sweep per QA pass until zero everywhere (WATCH W6).
- **Retired-vocabulary grep patterns fire word-internally** — `-goal` matches `user-goal-level`, `Non-Goals`, `actor-goal`. Proving a cutover clean requires line-by-line categorization against a file-scoped allowlist (which files may carry which legacy lines), never a raw count. Established by core-dev-usecases Step 8; the allowlist is file-scoped: a correct-meaning phrase in a non-allowlisted file is still a failure — fix by vocabulary substitution, not allowlist expansion.
- **Timestamp forensics on every results doc**: check the newest stamps against `date` AND the file's mtime before trusting the audit trail. Future-dated stamps = fabricated (model-guessed, not `date`-run) — found 2026-06-10 in core-review-triangulate-probe-lanes (review stamps 45–60 min in the future; step-completion stamps post-dating the Summary Completed). Artifact correctness can still be GO (re-verify claims directly); the stamps themselves are a MED audit-trail defect (WATCH W7). Also check QA's own grep before filing: a "missing constraint" can be the grep's casing, not the doc (the "No sudo" false-miss, same day).
- **Results docs can be LIVE while QA runs** — a parallel review-run can land review blocks/stamps between QA's first read and its verification greps (probe-lanes doc gained Steps-6/7 reviews + the Summary Reviewed stamp mid-assessment). Re-check any claimed-vs-observed gap immediately before filing: it may be a race, not a defect.

- **Wire bodies are plain text — no backticks in a shell `comms ... -m "..."` body.** Double quotes still command-substitute backtick spans: unknown tokens silently vanish from the body, real commands execute and splice stdout in. Put Markdown in the recipient's inbox file (Write/heredoc), wire = one-line pointer. Detector: a peer wire with an unexplained mid-sentence gap. (Architect fleet advisory 2026-09-03.)
- **Routing (2026-10-12):** PM owns tracker (Mission Control `anvil` + PROJECT_STATE.md) and routes deliverable checks to QA before marking done; `docs/QA.md` is the shared WATCH SoT. Custodian and skillwright are now user-level singletons, not anvil roster panes.

## Open WATCH list

See `docs/QA.md` § Open WATCH list for the live state. As of 2026-06-10: W1 (untracked source files — ACTIVE for core-dev-usecases, MED ≈ 2026-06-11T16:13), W2 (verify coverage-set drift), W3 (operator smoke — retargeted to `/dev-usecases` dogfood, evidence check named in `QA-core-dev-usecases.md`), W4 (usecases-doc path cross-layer duplication, ~12 surfaces). CLOSED: W5 (superseded by goal-doc retirement), W6 (5→4 refactor propagation — final `review-loop.js` residual fixed 2026-06-10, repo-wide grep zero).

## Known-flaky / quarantined tests

*— none currently —*
