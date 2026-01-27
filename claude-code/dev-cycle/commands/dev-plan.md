# /dev-plan

Create a detailed implementation plan for a single task.

## What This Does

Stage 2 of dev-cycle: Break down one task into bite-sized, production-grade steps.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev-cycle/SKILL.md` - See "Stage 2: Planning" section
- `~/.claude/skills/dev-cycle/references/2-planning-guide.md` - Detailed process
- `~/.claude/skills/dev-cycle/assets/templates/2-plan.md` - Plan template

## Input

**First argument (required):**
- PoC identifier (e.g., `PoC 6`, `poc6`) → Reads from `[slug]-poc-design.md`
- File path to design doc (e.g., `docs/feature-x-design.md`)
- File path to poc-design doc (e.g., `core-poc-design.md`) with PoC identifier in notes
- File path to plan doc + `update` → Updates to match current template

**User notes (optional):**
```
{{notes}}
```

**Examples:**
```bash
# Plan a specific PoC from poc-design.md
/dev-plan "PoC 6" --notes "Focus on error handling"

# Plan from design document
/dev-plan docs/feature-x-design.md

# Specify PoC and poc-design file explicitly
/dev-plan core-poc-design.md --notes "Plan PoC 6"

# Update existing plan doc to match current template
/dev-plan docs/core-poc6-plan.md update
```

**The command will:**
1. Read PoC definition from poc-design.md if PoC identifier provided
2. Read design doc if file path provided
3. Combine with user notes
4. Create implementation plan

**Update mode** (when input is plan doc + `update`):
1. Read the current template
2. Read the existing plan doc
3. Restructure to match template (preserve content, update structure)
4. Write updated plan doc

## Key Requirements

✅ **CODE ALLOWED** - Use concrete code snippets, configs, commands

⚠️ **ONE TASK AT A TIME** - Only plan the next logical task

🏗️ **PRODUCTION-GRADE** - OOP, Pydantic models, type hints, real data

🔒 **SELF-CONTAINED** - Add alongside, don't replace; works independently

🧪 **TESTS IN SAME STEP** - Each step includes writing AND running tests for that step's code (never separate)

## Process

Follow the guidance in `2-planning-guide.md`:
1. List prerequisites
2. Break into bite-sized steps
3. Define verification for each step
4. Include specific code snippets
5. Ensure production-grade (OOP, Pydantic, typing)
6. Ensure self-contained

## Output

Create one document:
- `docs/[milestone-slug]-[task-slug]-plan.md` - Evergreen "how to" guide (NO status)

**Examples**: `docs/core-poc6-plan.md`, `docs/cloud-auth-fix-plan.md`

## After Completion

User will run `/verify-doc` on the plan, fix issues, then request Stage 3 (Execution).
