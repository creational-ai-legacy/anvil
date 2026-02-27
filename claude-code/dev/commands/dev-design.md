---
description: Create a design document for a task (Stage 1, NO CODE). Runs in main conversation.
argument-hint: [source-file] [notes]
disable-model-invocation: true
---

# /dev-design

Create a design document for a task (Stage 1 of dev workflow).

## What This Does

Stage 1 of dev: Analyze a problem and design a solution WITHOUT writing code.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev/SKILL.md` - See "Stage 1: Design" section
- `~/.claude/skills/dev/references/1-design-guide.md` - Detailed process
- `~/.claude/skills/dev/assets/templates/1-design.md` - Design template

## Input

**First argument (recommended):**
- Source material: bug report, feature spec, rough notes, or existing design doc
- If omitted → create from scratch based on notes

**Other input modes:**
- Design doc path + `update` → Reformat to match current template

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Create design from feature spec
/dev-design docs/feature-spec.md

# Create design from notes only
/dev-design --notes "Add caching layer to reduce API calls"

# Update existing design doc to match current template
/dev-design docs/core-poc6-design.md update
```

**The command will:**
1. Read the guide and template
2. Analyze the input (or create from notes)
3. Structure using the template format
4. Write to `docs/[milestone-slug]-[task-slug]-design.md`

**Update mode** (when input is design doc + `update`):
1. Read the current template
2. Read the existing design doc
3. Restructure to match template (preserve content, update structure)
4. Write updated design doc

## Key Requirements

❌ **NO CODE** - This is design only (patterns/signatures OK, not implementations)

📋 **ANALYSIS** - Each item analyzed independently (numbered 1, 2, 3...)

🔗 **PROPOSED SEQUENCE** - Item order with rationale (#1 → #2 → #3)

🔒 **SELF-CONTAINED** - Task works independently, doesn't break existing functionality

⚖️ **RISK PROFILE** - Assign Critical / Standard / Exploratory with one-sentence justification

🚧 **CONSTRAINTS** - Define scope boundaries, must-not-happen rules, and guardrails

## Process

Follow `1-design-guide.md` exactly. It contains the full process for analysis, constraints, sequencing, and decisions.

## Output

Create one document:
- `docs/[milestone-slug]-[task-slug]-design.md`

**Examples**: `docs/core-poc6-design.md`, `docs/cloud-auth-fix-design.md`

## After Completion

User will run `/review-doc` on the design, fix issues, then request Stage 2 (Planning).
