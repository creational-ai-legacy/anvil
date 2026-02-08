# Health Guide

Project health check to verify alignment with north star vision.

**Template**: `assets/templates/PROJECT_STATE.md`

## When to Run

| Situation | Frequency |
|-----------|-----------|
| Completing a task | Always |
| End of session | Always |
| After major decision | Always |
| Active development | Every 2-3 steps |
| Feeling uncertain | Immediately |

---

## Files to Review

Scan the project for these artifacts (names may vary):

1. **North Star** - `docs/*north-star*.md` - Vision, milestones, success metrics
2. **Design** - `docs/*design*.md` - Architecture and end goals
3. **Project State** - `PROJECT_STATE.md` - Current status tracking
4. **Results** - `docs/*-results.md` - Completed work

Use Glob and Grep tools to search. If files don't exist, note their absence.

---

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
- Run tests to verify all pass (e.g., `uv run pytest tests/ -v`)
- If no tests exist, document this
- Check test counts match expected totals

---

## Process

### Step 1: Analyze

Review all files above and assess against the 5 criteria.

### Step 2: Update PROJECT_STATE.md

1. If `PROJECT_STATE.md` doesn't exist, create it using template
2. If structure differs from template, realign it
3. Update the `Last Updated` timestamp
4. Replace "Latest Health Check" section with current findings:

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

**Keep only the latest check** - replace entire section with new findings.

### Step 3: Generate Report

After updating PROJECT_STATE.md, report:

```markdown
## Health Check Report

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

---

## Quick Reference

1. **Review** - North star, design, project state, results docs
2. **Assess** - Alignment, production-readiness, gaps, scope, tests
3. **Update** - PROJECT_STATE.md with latest health check
4. **Report** - Wins, concerns, gaps, recommendations, north star alignment
