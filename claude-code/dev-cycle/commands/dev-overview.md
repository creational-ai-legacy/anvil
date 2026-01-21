# /dev-overview

Create a high-level design overview for a feature, bug fix, or PoC.

## What This Does

Stage 1 of dev-cycle: Analyze and plan the work without writing code.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev-cycle/SKILL.md` - See "Stage 1: Overview" section
- `~/.claude/skills/dev-cycle/references/1-overview-guide.md` - Detailed process
- `~/.claude/skills/dev-cycle/assets/templates/overview.md` - Output template

## Input

**First argument (optional):**
- File path to bug report/issue/feature spec (e.g., `docs/bug-123.md`, `github-issue-456.txt`)
- If omitted → Use user notes only for feature/bug description

**User notes (required if no file, otherwise optional):**
```
{{notes}}
```

**Examples:**
```bash
# From bug report file
/dev-overview docs/bug-123.md --notes "Focus on performance impact"

# From GitHub issue file
/dev-overview github-issue-456.txt

# From user description only
/dev-overview --notes "Add caching layer to reduce API calls"
```

**The command will:**
1. Read the file if provided (bug report, issue, feature spec)
2. Combine with user notes
3. Analyze current architecture
4. Create design overview
5. Update `[slug]-poc-design.md` if applicable

## Key Requirements

⛔ **NO CODE** - This is design only (architecture, flows, diagrams)

🔒 **Self-Contained** - Break work into items that work independently

## Process

Follow the guidance in `1-overview-guide.md`:
1. Document current architecture
2. Define target architecture
3. Identify what needs to change
4. Break into self-contained tasks
5. Evaluate approaches
6. Document decisions
7. Update [slug]-poc-design.md (if applicable)

## Output

Create `docs/[milestone-slug]-[task-slug]-overview.md` using the template.

**Examples**:
- `docs/core-poc6-overview.md` (PoC 6 in Core milestone)
- `docs/core-database-abstraction-overview.md` (feature in Core milestone)
- `docs/cloud-fix-auth-bug-overview.md` (bug fix in Cloud milestone)

## After Completion

User will run `/verify-doc` on the overview, fix issues, then request Stage 2 (Planning).
