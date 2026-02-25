# Project State: Anvil

> **Last Updated**: 2026-02-24T23:25:34-0800

**Anvil** is a structured workflow for taking ideas from concept to working product, supporting both Claude Code (implementation) and Claude Desktop (design & research).

**Current Status**: Skills framework v2.0.0 with 5-stage design workflow and 3-stage dev workflow. All naming cleanups complete. Marketing milestone started: GitHub Presence task complete (README restructured as landing page, Creational org profile live). Ready for distribution and content tasks.

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

---

## What's Next

**Recommended Next Steps**:
1. Manual: Pin Anvil as flagship repo on creational-ai org page (GitHub web UI)
2. Manual: Verify README and org profile render correctly on GitHub
3. Begin Distribution Listings task (awesome list PRs, SkillsMP indexing)
4. Begin LinkedIn Launch task (profile optimization, first posts)
5. Clean up legacy `poc-design` references in claude-code/README.md

**System Status**: ✅ **Production Ready + Marketing Started**
- 5-stage design skill v2.0.0 (simplified naming: vision, roadmap, task-spec)
- 3-stage dev skill with spec-driven plan workflow (full gap analysis complete)
- Marketing milestone 1/6 tasks complete (GitHub Presence)
- README restructured as landing page (hook, badges, proof, comparison)
- Creational org profile live at github.com/creational-ai
- Market research skill
- Video professor skill
- Skill reviewer skill
- 43/43 verify checks passing

---

## Latest Health Check

### 2026-02-24 - marketing-github-presence Finalization
**Status**: ✅ On Track

**Context**:
Finalizing the marketing-github-presence task -- first task in the Marketing milestone. Restructured Anvil README as a landing page and created Creational GitHub org profile. This is the foundation that all downstream marketing tasks (distribution listings, LinkedIn, community, devlog) depend on.

**Findings**:
- ✅ Alignment: GitHub Presence is the foundational task for the Marketing milestone; all downstream tasks depend on a polished README to link to
- ✅ Production: README is live on public GitHub repo; org profile is live at github.com/creational-ai -- no mocks
- ✅ Scope: All 5 implementation steps (0-4) executed per plan specification with minimal deviations
- ✅ Complexity: Proportionate -- two markdown files modified/created, no unnecessary abstractions
- ✅ 18/18 structural verification checks passing; workflow diagrams verified byte-for-byte identical to originals
- ✅ All 4 internal links validated (claude-desktop/releases, claude-code/README.md, claude-desktop/README.md, LICENSE)

**Challenges**:
- `gh` CLI could not create repos in creational-ai org (token lacks `admin:org` scope); resolved by manual repo creation via GitHub web UI
- Org repo pinning is GitHub web UI-only -- no API or CLI support; noted as manual follow-up

**Results**:
- ✅ README restructured: ASCII anvil at top, one-line hook, badges, Quick Start elevated, proof section, comparison table
- ✅ Org profile live with flagship project, 3 linked public repos, attribution
- ✅ All success criteria met except manual pin step (GitHub web UI only)

**Lessons Learned**:
- MD5 checksums of extracted sections reliably verify content preservation during file restructuring
- Prerequisite research on public repo status prevents broken links in proof and profile content
- `gh` CLI auth (token) and SSH git auth are independent; verify both for cross-org workflows

**Next**: Pin Anvil on org page (manual). Begin Distribution Listings and LinkedIn Launch tasks.
