# Small Win Check

Perform a project health check to verify alignment with north star vision.

## Files to Review

Scan the project for these artifacts (names may vary):

Use Glob and Grep tools to search for these files. If files don't exist or aren't in expected locations, note their absence in the report.

1. **North Star** - `docs/*north-star*.md` - Vision, milestones, success metrics
2. **PoC Plan** - `docs/*poc-plan*.md` - PoC definitions and success criteria
3. **Design** - `docs/*design*.md` - Architecture and end goals
4. **Project State** - `PROJECT_STATE.md` - Current status tracking
5. **PoC Results** - `docs/poc*-results.md` - Completed work

## Assessment Criteria

### 1. Alignment Check
- Are completed PoCs aligned with the North Star vision?
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
**Before generating the report**, replace the "Latest Health Check" section in `PROJECT_STATE.md` with the current findings (create the section if it doesn't exist):

```markdown
## Latest Health Check

### [Date] - [Session/Milestone Name]
**Status**: ✅ On Track / ⚠️ Minor Concerns / ❌ Needs Attention

**Context**:
[What prompted this health check? What milestone/work item just completed?]

**Findings**:
- [Summary of alignment, gaps, concerns]

**Challenges** (if any):
- [What difficulties were encountered]
- [How they were resolved]

**Results**:
- ✅ [What was accomplished]
- ✅ [Key outcomes]

**Lessons Learned**:
- [What worked well]
- [What to do differently]
- [Insights gained]

**Next**: [What to focus on next]
```

**Instructions**: Replace the entire section with new findings. Keep only the latest check - follow the template structure exactly.

### Step 3: Generate Final Report

After updating PROJECT_STATE.md, provide this report:

```markdown
## Small Win Check Report

**Date**: [Date]
**Current Stage**: [Stage]
**Current PoC**: [PoC name]

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
| Completing a PoC | Always |
