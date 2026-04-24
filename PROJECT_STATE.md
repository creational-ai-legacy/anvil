# Project State: Anvil

> **Last Updated**: 2026-04-23T15:57:50-0700

**Anvil** is a structured workflow for taking ideas from concept to working product, supporting both Claude Code (implementation) and Claude Desktop (design & research).

**Current Status**: Skills framework v2.0.0 with 4 Anvil skills (design, dev, research, review). Review skill has persistent review tracking, per-item history, auto-fix support, step-splitting, paired tick-driven review loops (`/review-doc-run-loop` + `/exam-loop`), and now an operator-facing `/walkthrough` command for pedagogical per-unit elaboration with five-angle rendering. Sub-step notation (8a, 8b, 8c) supported across plan, execution, and review systems. Marketing milestone 1/6 tasks complete.

---

## Progress

### Milestone: Core

| ID | Name | Type | Status | Docs |
|-----|------|------|--------|------|
| add-milestone-stage | Add Milestone Design Stage | feature | ✅ Complete | `add-milestone-stage-*.md` |
| refactor-overview-to-design-focus | Refactor dev-cycle Overview to Design Focus | refactor | ✅ Complete | — |
| cc-design-v2-upgrade | CC Design Skill v2.0 Upgrade | refactor | ✅ Complete | `cc-design-v2-upgrade-*.md` |
| dev-skill-gap-s1 | Design Stage Enhancements (Risk Profile, Constraints, Impl Options, Parallelization) | refactor | ✅ Complete | `dev-skill-gap-s1-*.md` |
| dev-skill-gap-s2 | Spec-Driven Plan Template, Results Deviation Tracking, Review Expansion | refactor | ✅ Complete | `dev-skill-gap-s2-*.md` |
| dev-skill-gap-s3 | Stale Pre-Spec-Driven Reference Cleanup | refactor | ✅ Complete | `dev-skill-gap-s3-*.md` |
| design-naming-cleanup | Design Naming Cleanup (drop "product-" prefix) | refactor | ✅ Complete | `design-naming-cleanup-*.md` |
| poc-to-task | Stage 5 Rename: PoC Spec to Task Spec | refactor | ✅ Complete | `core-poc-to-task-*.md` |
| naming-refactor | Naming Refactor (Claude Code Conventions) | refactor | ✅ Complete | `core-naming-refactor-*.md` |
| review-skill | Unified Review Skill (verify + skill-reviewer consolidation) | refactor | ✅ Complete | `core-review-skill-*.md` |
| review-tracking | Persistent Review Tracking with Per-Item History | feature | ✅ Complete | `core-review-tracking-*.md` |
| step-splitting | Sub-Step Support for Plan Step Splitting | feature | ✅ Complete | `core-step-splitting-*.md` |
| review-auto-loops | Auto Loops: /review-doc-run-loop + /exam-loop (tick-driven staggered review) | feature | ✅ Complete (Step 6 ⏭️ skipped) | `core-review-auto-loops-*.md` |
| review-walkthrough | Operator-Facing /walkthrough Command (five-angle per-unit elaboration) | feature | ✅ Complete (smoke test ⏸ operator gate) | `core-review-walkthrough-*.md` |

### Milestone: Marketing

| ID | Name | Type | Status | Docs |
|-----|------|------|--------|------|
| github-presence | README v2.0.0 + Creational Org Profile | feature | ✅ Complete | `marketing-github-presence-*.md` |
| distribution-listings | Awesome List + SkillsMP Listings | feature | ⬜ Pending | — |
| linkedin-launch | LinkedIn Build-in-Public Content | feature | ⬜ Pending | — |
| community-seeding | Reddit, HN, Discord Community Posts | feature | ⬜ Pending | — |
| creational-devlog | Astro Devlog + First Article | feature | ⬜ Pending | — |
| traction-evaluation | Channel Effectiveness Report | feature | ⬜ Pending | — |

---

## Key Decisions

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-01-03 | 5-stage design workflow | Supports organic milestone growth with clear/unclear path distinction |
| 2026-01-03 | Environment split (CD vs CC) | Stages 1-2 in Claude Desktop for exploration, 3-5 in Claude Code for structure |
| 2026-01-26 | Rename dev-design to design, dev-cycle to dev | Cleaner naming conventions |
| 2026-02-07 | Sync CC design skill with CD v2.0.0 naming | Consistent naming across CC and CD, adopt content improvements (Testing Strategy, Feedback Loops, 200 Users First) |
| 2026-02-16 | Add Risk Profile, Constraints, standard Implementation Options, parallelization hints to design stage | Close Stage 1 gaps from gap analysis; richer design docs for downstream stages to leverage |
| 2026-02-16 | Spec-driven plan steps with Specification + Acceptance Criteria instead of Code/Tests blocks | Close Stage 2/3/3b gaps; leaner plans, explicit executor-reviewer contract, deviation tracking |
| 2026-02-24 | Drop "product-" prefix from vision/roadmap naming across design skill | Redundant prefix; simplify to `vision` and `roadmap` for cleaner naming conventions |
| 2026-02-24 | Rename Stage 5 from "PoC Spec" to "Task Spec" | Stage 5 is generic task decomposition, not PoC-specific; "PoC" stays as one of 4 task types |
| 2026-02-24 | README restructured as landing page | Hook, badges, elevated Quick Start, proof section, competitive positioning convert visitors to stars |
| 2026-02-24 | Org profile lists only verified public repos | Broken links on a profile card look incomplete; list only Anvil, VisualFlow, Unity Builds |
| 2026-02-24 | No links on "Built with Anvil" product list | Only Anvil has a confirmed public repo in the org; linking others would create dead links |
| 2026-02-26 | Naming refactor: spawn-* prefix, bare role agents, research/ skill, verify/ skill | Align with official Claude Code conventions; fix skill-command collision; clean foundation for verify v2 |
| 2026-02-26 | Consolidate verify + skill-reviewer into unified review skill | 4-skill toolkit cleaner than 5; parallel subagent architecture enables faster doc reviews; single quality assurance entry point |
| 2026-03-10 | Sub-step notation (8a, 8b, 8c) for plan step splitting | Letter suffixes preserve existing step numbers (no renumbering), one level only, review-driven splits with pre-execution guard |
| 2026-04-18 | Add paired tick-driven review loops (`/review-doc-run-loop` + `/exam-loop`) with single-source-of-truth `review-loop-guide.md` | Two independent main-conversation sessions coordinate staggered R → E → R → E cycles via shared review doc without manual hand-off. Echo-encoded state survives compaction; tuning constants (POLL_INTERVAL_SECONDS=240, MAX_IDLE_TICKS=4, MAX_ROUNDS=20) defined once in guide. Single-pass `/review-doc-run` and `/exam` untouched. |
| 2026-04-18 | SKIP Step 6 integration tests entirely for core-review-auto-loops | User directive: exercise new commands in daily use and iterate empirically. Two-session paired integration tests deemed unnecessary overhead; load-bearing wake-up-when-idle assumption accepted as unverified at feature-ship time. Rework cost identical whether discovered now or later. |
| 2026-04-23 | Thin-wrapper-plus-fat-guide pattern for `/walkthrough` | Mirrors existing review-command pattern (`/exam`, `/monitor`, `/review-doc`); single edit surface for walkthrough behavior; keeps command markdown at ~39 lines while guide owns ~195 lines of semantic rules. Registration trio (Quick Reference row + Commands list entry + Capabilities subsection) enforced via 3 separate acceptance greps — no partial registration possible. |
| 2026-04-23 | When Specification and Acceptance Criteria contradict, the grep wins | Step 2 Specification said "mention `--auto`" but Acceptance Criterion #6 required `grep -cE "--auto" == 0`. Enforced greps are the binding contract; "mention X" directives are drafting artifacts. Resolved by "No flags." without naming specific disavowed flags. |
| 2026-04-23 | Live smoke test for `/walkthrough` deferred to operator as manual gate | Executor agent cannot run interactive commands in a fresh Claude Code session with human-in-loop pause semantics. All automatable preconditions (deploy, verify, byte-match, count delta, doc-unchanged) pass, giving the manual test maximum precondition strength. Same pattern as any `disable-model-invocation: true` command requiring operator input. |

---

## What's Next

**Recommended Next Steps**:
1. **Operator action**: Run `/walkthrough docs/core-review-walkthrough-design.md` in a fresh Claude Code session; confirm first unit renders five angles, `stop` ends the session cleanly with a summary line, and `git diff docs/core-review-walkthrough-design.md` returns empty. Check off the final Success Criterion.
2. User manual `/help` check in a fresh Claude Code session: confirm `/walkthrough`, `/review-doc-run-loop`, and `/exam-loop` all appear with expected `argument-hint`
3. Exercise new loop commands + `/walkthrough` in actual daily use; log any wake-up, resume-math, parser, or walkthrough-rendering issues as follow-up bugs
4. If the wake-up-when-idle primitive fails in real use, escalate to Monitor-tool pivot per plan's Step 6 Trade-offs (~14–24 hour rework)
5. Begin Distribution Listings task (awesome list PRs, SkillsMP indexing)
6. Begin LinkedIn Launch task (profile optimization, first posts)

**System Status**: ✅ **Production Ready + Auto Loops + Walkthrough**
- 4 Anvil skills: design, dev, research, review
- 5-stage design skill v2.0.0 (simplified naming: vision, roadmap, task-spec)
- 3-stage dev skill with spec-driven plan workflow and sub-step support
- review skill: persistent review tracking with per-item history, --auto support, step scope check with split suggestions, parallel + sequential doc review, skill auditing, paired tick-driven review loops (`/review-doc-run-loop` + `/exam-loop`), operator-facing `/walkthrough` for pedagogical per-unit elaboration
- review-loop-guide.md owns all loop mechanics (parser, roles, gates, tick loop, echo state, termination, tuning) as single source of truth
- walkthrough-guide.md owns five-angle elaboration rules, three-tier adaptive vocabulary, unit extraction depth detection, per-unit advance semantics
- All agents use bare role names, all forked commands use /spawn-* prefix
- research/ skill consolidates market-research and naming-research
- Marketing milestone 1/6 tasks complete (GitHub Presence)
- 43 deployed commands, 16 agents, 74/74 verify checks passing

---

## Latest Health Check

### 2026-04-23 - core-review-walkthrough Finalization
**Status**: ⚠️ Minor Concerns (structural completion ✅, live smoke test deferred to operator)

**Context**:
Finalizing the core-review-walkthrough task — delivered an operator-facing `/walkthrough` command with five-angle per-unit elaboration. All 5 implementation steps complete (plus Step 0 baseline). Two new files (`walkthrough.md` command + `walkthrough-guide.md` reference); two additive registrations (SKILL.md + CLAUDE.md). 7/8 Success Criteria auto-verified; 1/8 (live smoke test) is a manual operator gate deferred by plan design.

**Findings**:
- ✅ Alignment: `/walkthrough` closes the operator-comprehension gap adjacent to existing review commands (`/review-doc`, `/exam`, `/monitor`). Pedagogical per-unit pacing is a net-new capability; additive to the review skill, preserves all existing behavior. Matches the skill's "parallel + sequential doc review, skill auditing, tick-driven loops" evolution trajectory.
- ✅ Production: All changes are to production surfaces (command, reference, skill metadata, project docs). `deploy.sh && verify.sh` passes 74/74 checks (up from 73 — one new count-assertion for the +1 command). Byte-identical diff between source and deployed for both the command file and the guide file.
- ⚠️ Gap: Live smoke test (Acceptance Criterion #6) is a manual operator gate by plan design — runtime behavior (argument parsing, doc-type detection, five-angle rendering, per-unit pause semantics) not yet empirically validated. Same shape as `core-review-auto-loops` Step 6 deferral: executor agent provably cannot satisfy "fresh Claude Code session with operator typing `stop`" requirement. Risk: a frontmatter typo or path-resolution bug in the deployed command could survive into production use. Mitigated by byte-for-byte source-to-deployed diff and `disable-model-invocation: true` flag.
- ✅ Scope: Five implementation steps executed per plan specification. One documented deviation (Step 2): Specification said "mention `--auto`" but Acceptance Criterion #6 required `grep -cE "--auto" == 0`. Resolved in favor of the enforced grep (AC wins); rationale recorded in Key Decisions. No scope drift — 2 new files, 2 additive registrations, 0 deletions, `git diff` on source docs unchanged.
- ✅ Complexity: Proportionate — guide is ~195 lines (owns five-angle rules, three-tier adaptive vocabulary, per-unit advance semantics), command is 39 lines (thin wrapper). Single-source-of-truth pattern upheld: guide owns semantics, command points at guide via absolute path. No premature abstractions; no redundant surface area across the two files.
- ✅ Tests: N/A for runtime — walkthrough is operator-interactive (same pattern as `/monitor`, `/exam`, `/review-doc-loop`). Structural checks all pass via acceptance greps: 10/10 on guide, 7/7 on command, 6/6 on SKILL.md, 4/4 on CLAUDE.md, deploy+verify 74/74. No fix-iteration loops on Steps 1, 3, 4; one fix iteration on Step 2 (spec-vs-AC contradiction).

**Challenges**:
- The Step 2 Specification-vs-Acceptance-Criteria contradiction (mention `--auto` vs. grep returns 0) required a resolution path: executor chose the enforced grep as the binding contract, recorded the rationale, and removed the `--auto` disavowal. Future plan authors should cross-check "mention X" directives against "grep for X returns 0" criteria before locking the plan.
- The live smoke test gate could not be auto-satisfied from within the execution agent (recursive self-invocation blocked + `disable-model-invocation: true` in walkthrough's own frontmatter + no terminal input channel for the operator's `stop` signal). Executor correctly handed off to operator with a single-line "run this next" instruction rather than simulating success.

**Results**:
- ✅ `walkthrough-guide.md` deployed (~195 lines): argument parsing, doc-type recognition (references `exam-guide.md` without duplication), three-tier adaptive vocabulary, unit extraction depth detection, five-angle elaboration rules, common pitfalls, per-unit advance semantics, invariants, process outline
- ✅ `/walkthrough <doc-path> [notes]` command deployed with `disable-model-invocation: true`, thin-wrapper pattern matching `exam.md` / `monitor.md` / `review-doc.md`
- ✅ SKILL.md extended with the registration trio: Quick Reference row + Commands list entry + Capabilities subsection. `git diff` shows +3 additions, 0 deletions.
- ✅ CLAUDE.md Review commands list extended by exactly one line immediately after `/monitor`. `git diff` shows +1 addition, 0 deletions.
- ✅ `deploy.sh && verify.sh` 74/74 passing; command count rose 42 → 43 (+1 delta confirmed via `$((post - baseline))` arithmetic with whitespace-normalized capture)
- ✅ Non-regression confirmed: source doc `docs/core-review-walkthrough-design.md` byte-identical (`git diff` returns empty); all 9 pre-existing review commands still present
- ⏸ Live smoke test deferred to operator as final sign-off

**Lessons Learned**:
- When Specification and Acceptance Criteria contradict in a plan, the enforced grep is the binding contract; "mention X" directives are drafting artifacts. Future plan authors should cross-check them before locking the plan.
- Executor agents cannot satisfy interactive manual gates. The correct response is to max-out automatable preconditions and hand off with a clear "run this next" instruction, not simulate the test. `disable-model-invocation: true` commands are designed for operator-only invocation — the flag is their interactive-only contract.
- `verify.sh` is a structural safety net, not an end-to-end test. It validates file presence, count expectations, and directory structure — deployable-state-wise. Runtime behavior (argument parsing, doc-type detection, pause semantics) lives behind the manual gate. Future skill-authoring plans should keep this split explicit.
- SKILL.md registration is a three-point trio (Quick Reference row + Commands list entry + Capabilities subsection); acceptance criteria enforce all three via separate greps — no partial registration possible. Worth formalizing as the "skill registration contract" for any future command addition.

**Next**: Operator runs `/walkthrough docs/core-review-walkthrough-design.md` in a fresh Claude Code session; observes first unit rendering five angles; types `stop`; confirms summary line appears and `git diff docs/core-review-walkthrough-design.md` returns empty. Check off final Success Criterion. Then `/help` sanity check confirms the new command is discoverable. Exercise in daily use; log any rendering/depth-detection/vocabulary-tier issues as follow-up bugs. Separately: when user explicitly requests, run `./deploy-genesis.sh && ./verify-genesis.sh` to propagate to genesis.
