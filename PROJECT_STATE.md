# Project State: Anvil

> **Last Updated**: 2026-03-10T23:08:21-0700

**Anvil** is a structured workflow for taking ideas from concept to working product, supporting both Claude Code (implementation) and Claude Desktop (design & research).

**Current Status**: Skills framework v2.0.0 with 4 Anvil skills (design, dev, research, review). Review skill has persistent review tracking with per-item history, auto-fix support, and step-splitting review capability. Sub-step notation (8a, 8b, 8c) supported across plan, execution, and review systems. Marketing milestone 1/6 tasks complete.

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

---

## What's Next

**Recommended Next Steps**:
1. Deploy step-splitting changes: `cd claude-code && ./deploy.sh && ./verify.sh`
2. Manual e2e validation: run `/review-doc-run` on an existing integer-only plan to confirm backward compatibility
3. Begin Distribution Listings task (awesome list PRs, SkillsMP indexing)
4. Begin LinkedIn Launch task (profile optimization, first posts)

**System Status**: ✅ **Production Ready + Step Splitting**
- 4 Anvil skills: design, dev, research, review
- 5-stage design skill v2.0.0 (simplified naming: vision, roadmap, task-spec)
- 3-stage dev skill with spec-driven plan workflow and sub-step support
- review skill: persistent review tracking with per-item history, --auto support, step scope check with split suggestions, parallel + sequential doc review, skill auditing
- All agents use bare role names, all forked commands use /spawn-* prefix
- research/ skill consolidates market-research and naming-research
- Marketing milestone 1/6 tasks complete (GitHub Presence)

---

## Latest Health Check

### 2026-03-10 - core-step-splitting Finalization
**Status**: ✅ On Track

**Context**:
Finalizing the core-step-splitting task -- added sub-step support (8a, 8b, 8c) to the plan step splitting workflow. Review system can now flag oversized steps and suggest concrete splits. Execution system handles sub-steps as first-class citizens. 11 existing files modified, zero new files created.

**Findings**:
- ✅ Alignment: Sub-step support directly extends the review and dev skills' capability -- oversized steps that were previously flagged as "structural suggestions" and skipped can now be split and applied. This completes a gap identified during review usage.
- ✅ Production: All changes are to production guide files (references, templates, agents, commands) that control real agent behavior. Changes are surgical line replacements, blockquote additions, and subsection additions. Deploy + verify not yet run after changes.
- ✅ Scope: All 11 implementation steps (0-10) executed per plan specification. Zero deviations from plan across all steps. 11/14 success criteria checked off in results doc; remaining 3 (step scope check details, plan template notation, backward compatibility) are implemented but pending deploy verification.
- ✅ Complexity: Proportionate -- 11 files modified with targeted edits. No new files created. No new abstractions or indirection layers. Sub-steps reuse existing step structure entirely.
- ⚠️ Gap: deploy.sh and verify.sh have not been run after the changes. Manual e2e validation (running review on an existing integer-only plan) not yet performed. These are the recommended next actions.
- ✅ Tests: N/A -- all changes are documentation-only. Each step validated via grep verification against acceptance criteria.

**Challenges**:
- Fix application logic needed to be duplicated in both review guides (sequential and parallel) to maintain each guide's self-contained property
- Pre-execution guard requires checking the results doc status before applying a split, adding a cross-document dependency to the fix application flow

**Results**:
- ✅ Review check #5 (step scope manageable) with cohesion-first decision logic and 4 splitting strategies
- ✅ Sub-step notation documented in plan template and results template
- ✅ Three sub-step prohibitions removed (execution guide line 15, planning guide lines 67 and 191)
- ✅ Execute-run orchestrator reads step IDs from plan headings instead of incrementing counter
- ✅ Executor agent and spawn command updated for step identifier notation
- ✅ Fix application logic documented in both review paths with pre-execution guard and match failure handling
- ✅ Review tracking template documents split step transition across review rounds

**Lessons Learned**:
- Generic heading matching (`### Step` without `N:`) future-proofs extraction against notation extensions
- Dumb orchestrators benefit from reading data from documents rather than generating it from assumptions
- Duplicating rules across self-contained guides is the right trade-off when cross-referencing would break readability

**Next**: Run `deploy.sh` + `verify.sh` to deploy changes. Manual e2e validation with integer-only plan. Continue Marketing milestone tasks.
