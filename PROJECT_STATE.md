# Project State: Anvil

> **Last Updated**: 2026-02-26T17:54:23-0800

**Anvil** is a structured workflow for taking ideas from concept to working product, supporting both Claude Code (implementation) and Claude Desktop (design & research).

**Current Status**: Skills framework v2.0.0 with 4 Anvil skills (design, dev, research, review). Review skill consolidates verify + skill-reviewer with parallel subagent architecture. 73/73 verify.sh checks passing. Marketing milestone 1/6 tasks complete.

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

---

## What's Next

**Recommended Next Steps**:
1. Begin Distribution Listings task (awesome list PRs, SkillsMP indexing)
2. Begin LinkedIn Launch task (profile optimization, first posts)
3. Manual: Pin Anvil as flagship repo on creational-ai org page (GitHub web UI)

**System Status**: ✅ **Production Ready + Review Consolidated**
- 4 Anvil skills: design, dev, research, review
- 5-stage design skill v2.0.0 (simplified naming: vision, roadmap, task-spec)
- 3-stage dev skill with spec-driven plan workflow (full gap analysis complete)
- review skill: parallel (/review-doc-run) and sequential (/review-doc) doc review + skill auditing (/review-skill)
- All agents use bare role names, all forked commands use /spawn-* prefix
- research/ skill consolidates market-research and naming-research
- 73/73 verify.sh checks passing
- Marketing milestone 1/6 tasks complete (GitHub Presence)

---

## Latest Health Check

### 2026-02-26 - core-review-skill Finalization
**Status**: ✅ On Track

**Context**:
Finalizing the core-review-skill task -- consolidated verify/ and skill-reviewer/ skills into a unified review/ skill with parallel subagent architecture for doc review, sequential doc review, and skill auditing. Created 19 new files, updated deploy/verify scripts, deleted old directories.

**Findings**:
- ✅ Alignment: 4-skill toolkit (design, dev, research, review) is cleaner and more cohesive than 5 skills. Parallel review architecture adds genuine capability for faster, more thorough doc reviews.
- ✅ Production: All changes deployed via deploy.sh and verified via verify.sh (73/73 checks) -- real deployment, not mocks. Old verify/ and skill-reviewer/ artifacts fully cleaned up.
- ✅ Scope: All 12 implementation steps (0-11) executed per plan specification. All 10 success criteria met. Minimal deviations (milestone-details->milestone-summary rename, fallback edge case addition).
- ✅ Complexity: Proportionate -- 19 files is the natural count for 4 agents + 5 commands + 4 templates + 5 guides + 1 SKILL.md. Self-contained sequential guide duplicates check logic intentionally for architectural clarity.
- ✅ Gap: No outstanding gaps. Cross-reference integrity validated across all 19 files. All internal and external paths resolve correctly.
- ✅ Tests: 73/73 verify.sh checks passing (up from 66 baseline due to review skill additions and old skill cleanup checks).

**Challenges**:
- Self-contained vs cross-referencing guides: chose duplication for clear scope boundaries between sequential and parallel modes
- Convention updates (agent- to spawn-) required semantic guide rewrites beyond simple path substitution

**Results**:
- ✅ 4 Anvil skills: design, dev, research, review
- ✅ 4-agent review architecture: doc-reviewer, item-reviewer, holistic-reviewer, skill-reviewer
- ✅ 5 commands: /review-doc, /review-doc-run, /review-skill, /spawn-doc-reviewer, /spawn-skill-reviewer
- ✅ Old verify/ and skill-reviewer/ directories deleted from source and deployment
- ✅ CLAUDE.md and README.md updated for 4-skill toolkit

**Lessons Learned**:
- Cross-check migrated content against current codebase state, not just the source file
- Convention updates go beyond path search-and-replace -- guide logic may need semantic rewrites
- Cleanup validation (old files absent) is as important as creation validation (new files present)

**Next**: Begin Marketing milestone tasks (Distribution Listings, LinkedIn Launch). Core milestone is fully complete.
