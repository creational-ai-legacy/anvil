# /dev-design

Analyze and design solutions for a feature, bug fix, or PoC.

## What This Does

Stage 1 of dev-cycle: Analyze and design solutions without writing code.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev-cycle/SKILL.md` - See "Stage 1: Design" section
- `~/.claude/skills/dev-cycle/references/1-design-guide.md` - Detailed process
- `~/.claude/skills/dev-cycle/assets/templates/1-design.md` - Output template

## Input

**First argument (optional):**
- File path to bug report/issue/feature spec (e.g., `docs/bug-123.md`, `github-issue-456.txt`)
- OR existing design doc path for update mode (e.g., `docs/core-poc6-design.md`)
- If omitted → Use user notes only for feature/bug description

**Second argument (optional):**
- `update` → Re-align existing design doc to current template

**User notes (required if no file, otherwise optional):**
```
{{notes}}
```

**Examples:**
```bash
# From bug report file
/dev-design docs/bug-123.md --notes "Focus on performance impact"

# From GitHub issue file
/dev-design github-issue-456.txt

# From user description only
/dev-design --notes "Add caching layer to reduce API calls"

# Update existing design doc to current template
/dev-design docs/core-poc6-design.md update
```

**The command will:**

**Normal mode (no `update`):**
1. Read the file if provided (bug report, issue, feature spec)
2. Combine with user notes
3. Analyze each item independently (Analysis section)
4. Define proposed sequence with rationale (#1 → #2 → ...)
5. Update `[slug]-poc-design.md` if applicable

**Update mode (`update` as 2nd arg):**
1. Read the existing design doc
2. Read the current template (`1-design.md`)
3. Re-align the document to match current template structure
4. Preserve all content but reorganize into correct sections
5. Ensure Analysis (non-sequential) and Proposed Sequence structure
6. Rename file if needed (e.g., `*-overview.md` → `*-design.md`)

## Key Requirements

**NO CODE** - This is design only (architecture, flows, diagrams, patterns)

**Self-Contained** - Task must work independently

**Two-Section Structure**:
- **Analysis** (non-sequential) - Each item analyzed independently (1, 2, 3...)
- **Proposed Sequence** - Item order with rationale (#1 → #2 → #3)

## Process

Follow the guidance in `1-design-guide.md`:
1. Document current vs target state
2. Analyze each item independently (What/Why/Approach)
3. Define proposed sequence with rationale
4. Document decisions
5. Update [slug]-poc-design.md (if applicable)

## Output

Create `docs/[milestone-slug]-[task-slug]-design.md` using the template.

**Examples**:
- `docs/core-poc6-design.md` (PoC 6 in Core milestone)
- `docs/core-database-abstraction-design.md` (feature in Core milestone)
- `docs/cloud-fix-auth-bug-design.md` (bug fix in Cloud milestone)

## After Completion

User will run `/verify-doc` on the design, fix issues, then request Stage 2 (Planning).
