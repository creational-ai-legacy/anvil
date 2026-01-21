# Small Win Check

Perform a project health check to verify alignment with north star vision.

## Files to Review

Scan the project for these artifacts (names may vary):

Use Glob and Grep tools to search for these files. If files don't exist or aren't in expected locations, note their absence in the report.

1. **North Star** - `docs/*north-star*.md` - Vision, milestones, success metrics
2. **Design** - `docs/*design*.md` - Architecture and end goals
3. **Project State** - `PROJECT_STATE.md` - Current status tracking
4. **Results** - `docs/*-results.md` - Completed work

## Assessment Criteria

### 1. Alignment Check
- Are completed tasks aligned with the North Star vision?
- Does the work support the target architecture?
- Are we on track for current milestone?

### 2. Production Integration
- Are interfaces production-ready or still experimental?
- Are we using real integrations (not mocks)?
- Would this scale?

### 3. Gap Analysis
- Are there missing tests or edge cases?
- Are there integration points not yet validated?
- Any ambiguity that should be resolved before proceeding?

### 4. Scope Guard
- Has any work drifted from original intent?
- Are we adding complexity beyond what's needed?

### 5. Test Coverage
- Automatically run tests to verify all pass (e.g., `uv run pytest tests/ -v`)
- If pytest is not available or no tests exist, document this in the report
- Check test counts match expected totals

## Process

### Step 1: Analyze
Review all files above and assess against the 5 criteria.

### Step 2: Update PROJECT_STATE.md

**Template**: `~/.claude/skills/dev-cycle/assets/templates/PROJECT_STATE.md`
- If `PROJECT_STATE.md` doesn't exist, create it using the template
- If `PROJECT_STATE.md` exists but structure differs significantly from template, realign it

**Before generating the report**:
1. Update the `Last Updated` timestamp at the top of `PROJECT_STATE.md`
2. Replace the "Latest Health Check" section with the current findings (create if it doesn't exist):

```markdown
## Latest Health Check

### [YYYY-MM-DD] - [Session/Task Name]
**Status**: ✅ On Track / ⚠️ Minor Concerns / ❌ Needs Attention

**Context**:
[What prompted this health check? What work just completed?]

**Findings**:
- ✅ [Key finding 1]
- ✅ [Key finding 2]

**Challenges**:
- [What difficulty was encountered]
- [How it was resolved]

**Results**:
- ✅ [What was accomplished]
- ✅ [Key outcome]

**Lessons Learned**:
- [Insight 1]
- [Insight 2]

**Next**: [What to focus on next]
```

**Instructions**: Replace the entire "Latest Health Check" section with new findings. Keep only the latest check.

### Step 3: Generate Final Report

After updating PROJECT_STATE.md, provide this report:

```markdown
## Small Win Check Report

**Date**: [YYYY-MM-DDTHH:MM:SS-TZ]
**Current Milestone**: [Milestone name]
**Recent Work**: [Task name]

### ✅ Wins
- [What's going well]
- [Progress made]

### ⚠️ Concerns
- [Potential issues]
- [Drift detected]

### 🔍 Gaps
- [Missing tests]
- [Undocumented decisions]

### 📋 Recommendations
1. [Action item]
2. [Action item]

### 🎯 North Star Check
[Still aligned? / Drifting? / Need to revisit?]
```

## When to Run

| Situation | Frequency |
|-----------|-----------|
| Active development | Every 2-3 steps |
| End of session | Always |
| Feeling uncertain | Immediately |
| After major decision | Always |
| Completing a task | Always |
