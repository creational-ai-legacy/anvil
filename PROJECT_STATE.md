# Project State: Anvil

> **Last Updated**: 2026-04-18T00:12:50-0700

**Anvil** is a structured workflow for taking ideas from concept to working product, supporting both Claude Code (implementation) and Claude Desktop (design & research).

**Current Status**: Skills framework v2.0.0 with 4 Anvil skills (design, dev, research, review). Review skill has persistent review tracking, per-item history, auto-fix support, step-splitting, and now paired tick-driven review loops (`/review-doc-run-loop` + `/exam-loop`) backed by a single-source-of-truth `review-loop-guide.md`. Sub-step notation (8a, 8b, 8c) supported across plan, execution, and review systems. Marketing milestone 1/6 tasks complete.

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

---

## What's Next

**Recommended Next Steps**:
1. User manual `/help` check in a fresh Claude Code session: confirm `/review-doc-run-loop` and `/exam-loop` appear with expected `argument-hint`
2. Exercise new loop commands in actual daily use; log any wake-up, resume-math, or parser issues as follow-up bugs
3. If the wake-up-when-idle primitive fails in real use, escalate to Monitor-tool pivot per plan's Step 6 Trade-offs (~14–24 hour rework)
4. Begin Distribution Listings task (awesome list PRs, SkillsMP indexing)
5. Begin LinkedIn Launch task (profile optimization, first posts)

**System Status**: ✅ **Production Ready + Auto Loops**
- 4 Anvil skills: design, dev, research, review
- 5-stage design skill v2.0.0 (simplified naming: vision, roadmap, task-spec)
- 3-stage dev skill with spec-driven plan workflow and sub-step support
- review skill: persistent review tracking with per-item history, --auto support, step scope check with split suggestions, parallel + sequential doc review, skill auditing, paired tick-driven review loops (`/review-doc-run-loop` + `/exam-loop`)
- review-loop-guide.md owns all loop mechanics (parser, roles, gates, tick loop, echo state, termination, tuning) as single source of truth
- All agents use bare role names, all forked commands use /spawn-* prefix
- research/ skill consolidates market-research and naming-research
- Marketing milestone 1/6 tasks complete (GitHub Presence)
- 42 deployed commands, 16 agents, 73/73 verify checks passing

---

## Latest Health Check

### 2026-04-18 - core-review-auto-loops Finalization
**Status**: ⚠️ Minor Concerns (structural completion ✅, runtime validation deliberately deferred)

**Context**:
Finalizing the core-review-auto-loops task — delivered paired tick-driven review loops via two new commands (`/review-doc-run-loop`, `/exam-loop`) and one new reference (`review-loop-guide.md`). All 5 structural steps (0-5) complete. Step 6 integration tests (12 subtests) skipped entirely per explicit user directive; validation deferred to empirical daily use.

**Findings**:
- ✅ Alignment: The new loop commands extend the review skill's value proposition (staggered R → E cycles without manual hand-off) while preserving single-pass `/review-doc-run` and `/exam` behavior unchanged. Additive-only across SKILL.md, CLAUDE.md, README.md documentation surfaces. Matches the review skill's "parallel + sequential doc review, skill auditing" evolution trajectory.
- ✅ Production: All changes are to production surfaces (commands, references, skill metadata, project docs). `deploy.sh && verify.sh` passes 73/73 checks. Byte-identical deploy diffs across all four review-skill surfaces.
- ⚠️ Gap: Step 6 runtime validation skipped per user directive. 12 integration subtests NOT executed; the load-bearing wake-up-when-idle primitive (Test 6.1) remains empirically unverified at feature-ship time. Risk accepted: failure would surface on first real-workflow use and trigger reactive rework (~14-24 hours for Monitor-tool pivot per plan's Step 6 Trade-offs).
- ✅ Scope: Five structural steps executed per plan specification with zero deviations on behavioral content. Two documented deviations are procedural only: (a) Prerequisite 3 baseline capture bypassed per user directive; (b) Step 6 entire block skipped per user directive. Both recorded in Key Decisions with full rationale.
- ✅ Complexity: Proportionate — 3 new files (1 guide, 2 thin wrappers) + 3 additive documentation edits. Loop guide is 554 lines (within 400-600 target). Each wrapper is ~49 lines (within 40-60 target). Single-source-of-truth principle upheld: all loop mechanics live in `review-loop-guide.md`; wrappers only expose per-side surface area.
- ✅ Tests: N/A for this task — all changes are documentation/command files validated via structural greps and deploy+verify. Runtime integration tests deliberately skipped per user directive; daily-use iteration is the validation pathway.

**Challenges**:
- The load-bearing wake-up-when-idle primitive (tick-driven background timer via echo-encoded state) could not be empirically validated within the `/dev-execute` session — integration phase is structurally user-driven. The executor correctly surfaced this limit rather than fabricating success.
- User directive to skip Step 6 arrived after the executor had prepared Track A / Track B recipes; the honest response was to record the directive with full Deviation from Plan narrative and preserve `⏭️ SKIPPED` status, not silent ✅.

**Results**:
- ✅ `review-loop-guide.md` deployed (554 lines): parser, role assignment, coordination protocol, tick-driven loop structure, mid-round compaction recovery, termination rules, tuning constants (single-definition-site)
- ✅ `/review-doc-run-loop` command deployed with `disable-model-invocation: true` and paired-flag warning in Usage block
- ✅ `/exam-loop` command deployed with mirror-symmetric Process list (byte-identical across both wrappers)
- ✅ Three documentation surfaces updated additively (SKILL.md, CLAUDE.md, README.md) with consistent "tick-driven loop" terminology
- ✅ Non-regression confirmed: `/review-doc-run`, `/exam`, `review-tracking.md` all byte-identical pre/post
- ✅ `deploy.sh && verify.sh` 73/73 passing; command count rose 40 → 42

**Lessons Learned**:
- Empirical-use-over-synthetic-tests is a legitimate validation strategy when users have high workflow exposure and failure modes are obvious in use. Preserve skips as explicit `⏭️ SKIPPED` status with Deviation from Plan narrative, not silent completion — keeps decisions auditable.
- Integration phases needing multiple paired sessions or wall-clock elapse cannot run inside `/dev-execute`. Future plans should mark such steps "user-driven, executor produces readiness checklist only" — extend the Prerequisite 3 ("USER ACTION REQUIRED") pattern into the step itself.
- Single-source-of-truth bears out: thin wrappers + one fat guide means future loop-semantics changes touch only the guide. "Do NOT duplicate guide content" in surface docs is a forcing function that prevents drift.

**Next**: User runs `/help` in a fresh session to confirm both new commands are discoverable. User exercises `/review-doc-run-loop` and `/exam-loop` in daily use. Any wake-up, resume-math, or parser issues feed a follow-up `/dev-design` cycle; Monitor-tool pivot is the escalation path if the wake-up primitive fails.
