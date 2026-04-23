# review

Unified quality assurance skill for document review and skill auditing.

## Overview

This skill consolidates document verification and skill auditing into a single review capability. It checks design and implementation documents for soundness, logical consistency, dependency chains, contradictions, and surprises -- and audits Claude Code skills for structural correctness, frontmatter validity, cross-reference integrity, and convention compliance.

**Doc review** supports two modes:
- **Sequential** (`/review-doc`) -- single-pass review, all checks run in order
- **Parallel** (`/review-doc-run`) -- background spawning with incremental processing for faster reviews of multi-item documents

**Skill review** (`/review-skill`) audits a skill's structure, frontmatter, architecture hierarchy, and cross-references.

**Exam** provides independent critical assessment, deeper than automated review:
- **Review mode** (`/exam`) -- deep-dive examination of a single document, challenging substance and architecture
- **Monitor mode** (`/monitor`) -- real-time observation of plan execution with per-step cross-reference analysis

## Architecture

4 agents, each with a distinct role:

| Agent | Role | Tools |
|-------|------|-------|
| `doc-reviewer` | Sequential doc review (full pass) | Full (can apply fixes) |
| `item-reviewer` | Per-item checks in parallel mode | Read-only |
| `holistic-reviewer` | Cross-cutting checks in parallel mode | Read-only |
| `skill-reviewer` | Skill structure and convention audit | Read-only |

**Architecture hierarchy**: Guides contain all logic; commands and agents are thin wrappers. In parallel mode, item and holistic agents are read-only reporters -- the orchestrator writes findings incrementally and is the sole editor.

**Exam commands** (`/exam`, `/monitor`) run directly in the main conversation with no subagents. The examiner reloads its guide on each invocation to prevent instruction drift in long sessions.

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
| Review Tracking Template | `assets/templates/review-tracking.md` |
| Skill Review Report Template | `assets/templates/skill-review-report.md` |
| Exam Guide | `references/exam-guide.md` |
| Monitor Status Template | `assets/templates/monitor-status.md` |
| Loop Guide | `references/review-loop-guide.md` |

## Commands

- `/review-doc <doc-path> [--auto] [notes]` -- Sequential doc review (main conversation)
- `/review-doc-run <doc-path> [--auto] [notes]` -- Parallel doc review with background agents (main conversation)
- `/review-doc-loop <doc-path> [N] [--first | --follow] [notes]` -- long-running tick-driven loop coordinating with `/exam-loop` via the shared review doc; main conversation only. `N` defaults to 1
- `/review-skill <skill-name>` -- Audit a skill for structure and conventions (main conversation)
- `/exam <doc-path> [--auto] [notes]` -- Independent critical examination of a document (main conversation)
- `/exam-loop <doc-path> [N] [--first | --follow] [notes]` -- long-running tick-driven loop coordinating with `/review-doc-loop` via the shared review doc; main conversation only. `N` defaults to 2
- `/monitor <task-slug>` -- Monitor execution progress with periodic status reports (main conversation)
- `/spawn-doc-reviewer <doc-path> [--auto] [notes]` -- Sequential doc review (background agent)
- `/spawn-skill-reviewer <skill-name>` -- Skill audit (background agent)

Or use natural language: "Review this document", "Check this plan for issues", "Audit the design skill", "Exam the plan", "Monitor the execution"

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
- Review tracking: persists full review history to -review.md alongside reviewed documents

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

### Exam

Independent critical assessment, deeper than automated review:

- **Review mode** (`/exam`): Deep-dive examination of a single document. Reads the automated review doc first, then challenges substance, architectural decisions, unvalidated assumptions, and cross-document contradictions. Reports findings conversationally with a numbered table ranked by severity.
- **Monitor mode** (`/monitor`): Real-time observation of plan execution. Periodically reads the results doc and performs per-step analysis as steps complete — cross-referencing against plan spec, plan review findings, design items, and expectations doc. The examiner adds judgment the mechanical reviewer cannot: was the concern substantive? Did the fix resolve the real risk?

### Loop Coordination

`/review-doc-loop` and `/exam-loop` are paired, long-running tick-driven loop commands that coordinate two independent Claude Code sessions via a shared review doc to run a staggered review cycle with no manual hand-off. By default `/exam-loop` leads (runs E1 immediately, N=2) and `/review-doc-loop` follows (waits for E1 before running R1, N=1) -- the default cadence is the critic-sandwich `E1 → R1 → E2`. The `--first` and `--follow` flags flip this default for review-first workflows, but they must be paired across both sessions (`--first` on one side AND `--follow` on the other) — missing either flag silently degrades the coordination. For full semantics (argument parsing, role assignment, gate formulas, state encoding, termination rules, tuning constants), see `references/review-loop-guide.md`.
