# Skill Review Guide

Comprehensive validation rules for auditing a Claude Code skill.

**Template**: `assets/templates/skill-review-report.md`

---

## Architecture Hierarchy

Every skill should follow this layered architecture. The reviewer enforces it.

| Layer | Role | Contains |
|-------|------|----------|
| **Guide** (reference) | Source of truth | All logic, instructions, process, rules |
| **Template** (asset) | Output formatting | Document structure for generated output (only when command produces a doc) |
| **Command** | Thin wrapper | Points to guide, says "read the guide, follow it exactly" |
| **Agent** | Thin wrapper of command | Loads the guide, follows it. No duplicated logic. |

---

## Process

1. Resolve skill path (`claude-code/[skill-name]/`)
2. Read ALL files: SKILL.md, all commands, all agents, all references, all templates
3. Run checks 1-8 in order
4. For each check: PASS or list specific issues with `file:line` references
5. Classify issues by severity
6. Generate report using the template

---

## Severity Definitions

| Level | Meaning | Examples |
|-------|---------|---------|
| **HIGH** | Breaks functionality or missing required fields | Missing frontmatter, broken file references, missing SKILL.md |
| **MEDIUM** | Inconsistency or misleading content | Duplicated logic between agent and guide, contradictory descriptions |
| **LOW** | Style or cosmetic | Minor formatting differences, structural inconsistency between agents |

---

## The 8 Checks

### Check 1: Structure Validation

Does the skill have the required files and directories?

**Rules:**
- `SKILL.md` exists in skill root
- First line of `SKILL.md` is `# [skill-name]` (must match directory name)
- `commands/` directory exists if skill has slash commands
- `agents/` directory exists if skill has subagents
- `references/` directory exists if skill has guides
- `assets/templates/` directory exists if skill has templates

**How to check:** Use Glob to list all files under `claude-code/[skill-name]/`. Verify required structure.

**Not a flag:** Missing optional directories (e.g., no `agents/` is fine if the skill doesn't use agents).

---

### Check 2: Command Frontmatter

Do all commands have valid YAML frontmatter?

**Rules for regular commands** (`commands/[name].md` where name does NOT start with `agent-`):
- Has YAML frontmatter between `---` delimiters
- Has `description` field (non-empty string)
- Has `argument-hint` if the command takes arguments (look for examples with args in the body)
- Has `disable-model-invocation: true`

**Rules for agent commands** (`commands/agent-[name].md`):
- All regular command rules above, PLUS:
- Has `context: fork`
- Has `agent: [agent-name]` that matches a file in `agents/`

**How to check:** Read each command file. Parse the frontmatter block. Verify required fields.

**Not a flag:** Missing `argument-hint` on commands that take no arguments.

---

### Check 3: Agent Frontmatter & Structure

Do all agents have valid frontmatter and follow a consistent structure?

**Frontmatter rules** — each agent must have:
- `name` field (matches filename without `.md`)
- `description` field (non-empty, describes when to use this agent)
- `tools` field (comma-separated list of allowed tools), OR intentionally omitted with `<!-- no-tools: inherits all -->` comment to inherit all tools including MCP
- `model` field (`opus`, `sonnet`, or `haiku`)

**Structural consistency** — all agents within the same skill should follow the same section pattern:

| Section | Required | Description |
|---------|----------|-------------|
| Role statement | Yes | "You are a [Role] specialist for the [skill] workflow." |
| Load Instructions | Yes | "First: Load Your Instructions" — lists guide + template to read |
| Input | Yes | What the agent receives |
| Process | Yes | High-level steps (defers to guide for details) |
| Constraints / Critical Rules | Recommended | What the agent must NOT do |
| Output | Yes | What files/artifacts the agent produces |
| Completion Report | Yes | Report format (inline or "see guide") |

**How to check:** Read each agent. Verify frontmatter fields. Scan for section headings. Compare structure across all agents in the skill.

**Not a flag:** Minor section name variations (e.g., "Constraints" vs "Critical Rules"). Extra sections unique to one agent (e.g., "Key Concept" in a design agent).

---

### Check 4: Architecture Hierarchy

Does the skill follow the 4-layer architecture?

This is the most important conceptual check. It ensures logic lives in the right place.

#### Guide = Source of truth

- All process logic, rules, decision criteria, and detailed instructions live in `references/*.md`
- Guides contain: the full process, checklists, output formats, decision tables, examples
- If a command or agent contains detailed logic that belongs in a guide, flag it

**Flag examples:**
- Agent has inline verdict logic (decision table) that also exists in the guide
- Command contains 20+ lines of process steps that duplicate the guide
- Agent has a full output format specification that the guide already defines

**Not a flag:** Brief process summaries in commands/agents that reference the guide for details.

#### Template = Output formatting only

- Templates contain document structure and placeholders
- Templates do NOT contain instructional content, process logic, or rules
- Templates are only needed when the command produces a document/report
- Not every command needs a template

**Flag examples:**
- Template contains instructions like "Follow these steps..."
- Template has conditional logic or decision rules

**Not a flag:** Templates with example content that demonstrates the format.

#### Command = Thin wrapper

- Command says "Read the guide. Follow it exactly." (or equivalent)
- Command describes WHAT it does and its inputs/outputs
- Command does NOT contain the full process — it references the guide
- Command may have a brief high-level process list that defers to the guide

**Flag examples:**
- Command has > ~15 lines of process logic that duplicates a guide that already covers the same logic
- Command contains decision tables or output formats that the guide defines

**Not a flag:**
- Commands with "Key Requirements" bullets, brief process lists, or input/output descriptions
- **Orchestrator commands** that coordinate multiple stages/commands (e.g., a "run all steps" command). The orchestration logic IS the command — it doesn't need a separate guide because no other file needs to share that logic.
- **Aggregate commands** that bundle multiple simple steps into one workflow. If the command has no corresponding guide AND no agent duplicates its logic, it can serve as its own source of truth.
- Commands without a guide where no agent references the command as a guide substitute.

#### Agent = Thin wrapper of the command

- Agent says "Load the guide and follow it" (or equivalent)
- Agent provides: role, load instructions, input, brief process, constraints, output
- Agent does NOT duplicate logic from the guide
- Agent's Process section is high-level and references the guide for details

**Flag examples:**
- Agent has inline verdict logic, decision tables, or output formats that exist in the guide
- Agent's Process section is longer than 15 lines and contains guide-level detail
- Agent has its own "Completion Report" format that duplicates the guide's format

**Not a flag:**
- Agent's Completion Report says "report using the format in the guide" (a reference, not duplication)
- Agent references a command (instead of a guide) when the command IS the source of truth (orchestrator or aggregate command with no separate guide).

---

### Check 5: Cross-Reference Integrity

Do all internal file references resolve?

**Rules:**
- Every `agent: [name]` in an agent command frontmatter has a matching `agents/[name].md` file
- Every template path referenced in a guide (e.g., `assets/templates/foo.md`) exists
- Every guide path referenced in an agent (e.g., `~/.claude/skills/[skill]/references/foo.md`) exists
- SKILL.md lists all commands that exist in `commands/` (and doesn't list commands that don't exist)
- `CLAUDE.md` (project root) lists the skill's user-facing commands correctly

**How to check:** Extract all file path references from all files (look for backtick-quoted paths, `agent:` fields). Verify each path resolves to an actual file.

**Not a flag:** References to files in other skills (cross-skill references are valid). References to user-created docs (e.g., `docs/[slug]-design.md` — these are generated at runtime).

---

### Check 6: Input/Output Chain

Do stage outputs match next stage inputs?

**Rules:**
- If the skill has sequential stages (like dev's Design → Plan → Execute), each stage's output should match the next stage's expected input
- File naming patterns should be consistent across stages (e.g., `docs/[slug]-design.md` → `docs/[slug]-plan.md`)
- Template placeholders should be consistent (same placeholder format everywhere)
- No dead-end outputs (a stage produces something that no subsequent stage consumes)

**How to check:** Read each command/guide's Input and Output sections. Trace the chain: does Stage 1's output file match Stage 2's input specification?

**Not a flag:** Terminal outputs (e.g., the final stage's output doesn't feed into anything — that's expected). Optional stages that can be skipped.

---

### Check 7: Terminology & Format Consistency

Are the same terms and formats used everywhere?

**Rules:**
- Same concept uses the same term across all files (e.g., don't call it "step" in one place and "item" in another for the same concept)
- Timestamp format is consistent (same placeholder format, same example format)
- Status indicators are consistent (same emoji + label patterns everywhere)
- Risk/severity levels use same definitions across files

**How to check:** Grep for key terms across all files in the skill. Check for variations. Compare timestamp examples and placeholders.

**Not a flag:** Intentional terminology differences between different concepts (e.g., "item" in design vs "step" in planning — these are different things by design).

---

### Check 8: Convention Compliance

Does the skill follow general conventions?

**Rules:**
- Templates have no hardcoded values — all content should be placeholders
- No stale references to deleted or renamed files
- Severity/priority definitions are consistent if used in multiple places
- No orphaned files (files that exist but aren't referenced by anything)

**How to check:** Read templates for hardcoded values. Search for file references that don't resolve. Check for files in the skill directory that aren't referenced by any other file.

**Not a flag:** Example values in templates that demonstrate the format (e.g., `2024-01-08T22:45:00-0800` as a timestamp example).

---

## Report Format

Use the template (`assets/templates/skill-review-report.md`) to generate the report.

Fill in:
- `[skill-name]` — the skill being reviewed
- `[timestamp]` — current time (`date "+%Y-%m-%dT%H:%M:%S%z"`)
- `[count]` — number of files scanned
- Each check row — ✅ if all rules pass, ⚠️ with issue count if any fail
- Issues section — list each issue with `file:line` reference, grouped by severity
- Verdict — ✅ Clean if zero issues, ⚠️ [N] issues found otherwise

---

## Quick Reference

1. **Resolve** — Find `claude-code/[skill-name]/`, read all files
2. **Structure** — SKILL.md exists, directories present
3. **Command frontmatter** — description, argument-hint, disable-model-invocation
4. **Agent frontmatter & structure** — name, description, tools, model + consistent sections
5. **Architecture** — Guide = logic, Template = formatting, Command = wrapper, Agent = wrapper
6. **Cross-refs** — All file references resolve
7. **Input/Output** — Stage chain is connected
8. **Terminology** — Same terms and formats everywhere
9. **Conventions** — No hardcoded values, no stale references
10. **Report** — Generate using template, classify by severity
