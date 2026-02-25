# Project State: Anvil

> **Last Updated**: 2026-02-24T19:25:06-0800

**Anvil** is a structured workflow for taking ideas from concept to working product, supporting both Claude Code (implementation) and Claude Desktop (design & research).

**Current Status**: Skills framework v2.0.0 with 5-stage design workflow and 3-stage dev workflow. All naming cleanups complete: vision/roadmap simplified, Stage 5 generalized to "Task Spec". Full gap analysis complete (S1+S2+S3). Ready for production use.

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

---

## What's Next

**Recommended Next Steps**:
1. Clean up legacy `poc-design` references in claude-code/README.md (older naming convention predating poc-to-task rename)
2. Test the full design workflow end-to-end on a real project to validate all naming changes
3. Test the spec-driven dev workflow on a real task
4. Consider a migration note if existing active plans need updating to the new template structure

**System Status**: ✅ **Production Ready**
- 5-stage design skill v2.0.0 (simplified naming: vision, roadmap, task-spec)
- 3-stage dev skill with spec-driven plan workflow (full gap analysis complete)
- Design stage enhanced (Risk Profile, Constraints, Implementation Options, parallelization)
- Dev stage enhanced (Specification + AC steps, Deviation tracking, Review plan AC, LOC signal)
- Stage 5 generalized: "Task Spec" with Type field (PoC / Feature / Issue / Refactor)
- All naming cleanups complete (product-vision -> vision, product-roadmap -> roadmap, poc-spec -> task-spec)
- Market research skill
- Video professor skill
- Skill reviewer skill
- 43/43 verify checks passing

---

## Latest Health Check

### 2026-02-24 - core-poc-to-task Finalization
**Status**: ✅ On Track

**Context**:
Finalizing the core-poc-to-task task which renamed design skill Stage 5 from "PoC Spec" to "Task Spec" across CC and CD. Rewrote templates and guides with generalized "Task" language, added Type and Validates fields, updated all cross-references across 23 files.

**Findings**:
- ✅ All 10 success criteria met -- zero stale `poc-spec` / "PoC Spec" references
- ✅ 5 files renamed via git mv, 23 files updated with new references
- ✅ Template has Type field (PoC / Feature / Issue / Refactor) and Validates field
- ✅ Guide has Task Types section with type table and usage guidance
- ✅ "PoC" preserved as valid task type in dev skill (25 occurrences across 11 files)
- ✅ business-validation skill completely untouched
- ✅ deploy.sh and verify.sh both pass; old command removed, new command deployed
- ✅ No scope drift beyond 3 additional Stage 4 files caught during verification sweep

**Challenges**:
- Prerequisite grep used hyphenated `poc-spec` form which missed display name "PoC Spec" in Stage 4 files; caught by comprehensive Step 6 sweep
- Plan reference counts were approximate (CLAUDE.md had 4 refs not 2); grep verification after each step was the real acceptance check

**Results**:
- ✅ Stage 5 generalized from "PoC Spec" to "Task Spec" across all skill files
- ✅ `/design-task-spec` command deployed and functional
- ✅ Type field enables explicit task categorization in milestone planning

**Lessons Learned**:
- Baseline grep must search both path form and display name form to catch all references
- Plan occurrence counts are approximate; grep sweeps are the real acceptance criteria

**Next**: Clean up legacy `poc-design` references in claude-code/README.md. Test the full design workflow end-to-end on a real project.
