# review

Unified quality assurance skill for document review and skill auditing.

## Overview

This skill consolidates document verification and skill auditing into a single review capability. It checks design and implementation documents for soundness, logical consistency, dependency chains, contradictions, and surprises -- and audits Claude Code skills for structural correctness, frontmatter validity, cross-reference integrity, and convention compliance.

**Doc review** supports two modes:
- **Sequential** (`/review-doc`) -- single-pass review, all checks run in order
- **Parallel** (`/review-doc-run`) -- scatter-gather architecture with item + holistic agents for faster reviews of multi-item documents

**Skill review** (`/review-skill`) audits a skill's structure, frontmatter, architecture hierarchy, and cross-references.

## Architecture

4 agents, each with a distinct role:

| Agent | Role | Tools |
|-------|------|-------|
| `doc-reviewer` | Sequential doc review (full pass) | Full (can apply fixes) |
| `item-reviewer` | Per-item checks in parallel mode | Read-only |
| `holistic-reviewer` | Cross-cutting checks in parallel mode | Read-only |
| `skill-reviewer` | Skill structure and convention audit | Read-only |

**Architecture hierarchy**: Guides contain all logic; commands and agents are thin wrappers. In parallel mode, item and holistic agents are read-only reporters -- the orchestrator merges findings and is the sole editor.

## Quick Reference

| Resource | Path |
|----------|------|
| Sequential Review Guide | `references/review-doc-guide.md` |
| Parallel Orchestrator Guide | `references/review-doc-run-guide.md` |
| Item Review Guide | `references/review-item-guide.md` |
| Holistic Review Guide | `references/review-holistic-guide.md` |
| Skill Review Guide | `references/skill-review-guide.md` |
| Item Report Template | `assets/templates/item-report.md` |
| Holistic Report Template | `assets/templates/holistic-report.md` |
| Final Report Template | `assets/templates/final-report.md` |
| Skill Review Report Template | `assets/templates/skill-review-report.md` |

## Commands

- `/review-doc <path> [notes]` -- Sequential doc review (main conversation)
- `/review-doc-run <path> [--auto] [notes]` -- Parallel doc review with scatter-gather agents (main conversation)
- `/review-skill <skill-name>` -- Audit a skill for structure and conventions (main conversation)
- `/spawn-doc-reviewer <path> [notes]` -- Sequential doc review (background agent)
- `/spawn-skill-reviewer <skill-name>` -- Skill audit (background agent)

Or use natural language: "Review this document", "Check this plan for issues", "Audit the design skill"

## Capabilities

### Doc Review

Verifies design and implementation documents against templates, checks for:
- Template alignment (correct structure, sections, fields)
- Soundness (coherent approach, no logical flaws)
- Step flow (logical ordering, smooth transitions)
- Dependency chains (producer-consumer tracing, no circular deps)
- Contradictions (within document, with cross-references)
- Clarity and terminology (no vague language, consistent naming)
- Surprises (hidden deps, edge cases, environment assumptions)
- Cross-reference alignment (scope, terminology, requirement coverage)
- Codebase verification (referenced files and functions exist)

Supports all Design docs (vision, architecture, roadmap, milestone-spec, task-spec) and Dev docs (design, plan, results).

### Skill Review

Audits Claude Code skills for quality and consistency across 8 categories:

1. **Structure** -- SKILL.md exists, directories present, naming correct
2. **Command Frontmatter** -- Required YAML fields, spawn command fields
3. **Agent Frontmatter & Structure** -- Required fields, consistent section pattern
4. **Architecture Hierarchy** -- Guide is source of truth, commands/agents are thin wrappers
5. **Cross-Reference Integrity** -- All file references resolve, SKILL.md matches commands
6. **Input/Output Chain** -- Stage outputs match next stage inputs, no dead ends
7. **Terminology & Format** -- Consistent terms, timestamps, status indicators
8. **Convention Compliance** -- No hardcoded values in templates, no stale references
