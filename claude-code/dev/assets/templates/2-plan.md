# [Milestone-Slug]-[Task-Slug] Plan

> **Design**: See `docs/[milestone-slug]-[task-slug]-design.md` for analysis and approach.
>
> **Track Progress**: See `docs/[milestone-slug]-[task-slug]-results.md` for implementation status, test results, and issues.

## Overview

| Attribute | Value |
|-----------|-------|
| **Created** | [YYYY-MM-DDTHH:MM:SS±HHMM] |
| **Name** | [Name] |
| **Type** | [PoC / Feature / Issue / Refactor] |
| **Environment** | [Python / Web / Unity / ...] — see `references/[env]-guide.md` |
| **Proves** | [One sentence: what hypothesis this validates] |
| **Production-Grade Because** | [Why this isn't a toy/mock] |
| **Risk Profile** | [Critical / Standard / Exploratory] |
| **Risk Justification** | [One sentence — why this level] |

---

## Deliverables

Concrete capabilities this task delivers:

- [Deliverable 1]
- [Deliverable 2]
- [Deliverable 3]
- [Deliverable 4]

---

## Prerequisites

Complete these BEFORE starting implementation steps.

### 1. Identify Affected Tests

**Why Needed**: Run only affected tests during implementation (not full suite)

**Affected test files**:
- `[test-file-1]` - [What it tests]
- `[test-file-2]` - [What it tests]

**Baseline verification**:
```bash
[run affected tests command from environment guide]
# Expected: All pass (establishes baseline)
```

### 2. [Prerequisite Name]

**Why Needed**: [Why this task requires it]

**Steps**:
1. [Setup step 1]
2. [Setup step 2]
3. [Setup step 3]

**Commands**:
```bash
# [Description]
[actual commands to run]
```

**Verification** (inline OK for prerequisites):
```bash
# Quick check that prerequisite is working
[inline verification command from environment guide]
# Expected: [what success looks like]
```

### 3. [Prerequisite Name]
...

---

## Success Criteria

From Design doc (refined with verification commands):

- [ ] [Criterion 1 - specific, measurable]
- [ ] [Criterion 2 - specific, measurable]
- [ ] [Criterion 3 - specific, measurable]
- [ ] [Criterion 4 - specific, measurable]

---

## Architecture

### File Structure
```
[project-root]/
├── [new-folder]/
│   ├── [file1]               # [Purpose]
│   └── [file2]               # [Purpose]
├── [existing-file]           # Updated
└── [test-directory]/
    └── [test-files]          # All tests (per environment conventions)
```

### Design Principles
1. **OOP Design**: Use classes with single responsibility and clear interfaces
2. **Validated Data Models**: All data structures (configs, payloads, records) use validated models
3. **Strong Typing**: Type annotations on all functions, methods, and class attributes
4. **[Additional Principle]**: [Description if needed]

---

## Implementation Steps

**Approach**: [Brief description of implementation strategy - e.g., "Build bottom-up", "Test each layer independently", etc.]

> This plan is a contract between the executor (builder) and reviewer (validator). Steps specify **what** to build and **how** to verify -- the executor writes the implementation.

### Step 0: [Setup/Infrastructure]

**Goal**: [What this step accomplishes]

- [ ] [Setup item 1]
- [ ] [Setup item 2]
- [ ] [Setup item 3]

**Code**:
```bash
# [Description of what these commands do]
[actual commands to run]
```

**Verification** (inline OK for Step 0):
```bash
# Quick check that setup is working
[inline verification command — see environment guide]
# Expected: [what success looks like]
```

**Output**: [What's created/changed]

---

### Step 1: [Name]

**Goal**: [What this step accomplishes]

- [ ] [Implementation item 1]
- [ ] [Implementation item 2]
- [ ] [Write tests]

**Specification**:
- [What to build: behavior, files to create/modify, patterns to follow, constraints]
- [Interface expectations: function/method signatures (without bodies) if needed to communicate API contract]
- [What tests must verify: critical paths and edge cases to cover]

**Acceptance Criteria**:
- [Specific, measurable outcome 1 the reviewer validates]
- [Specific, measurable outcome 2 the reviewer validates]
- [Specific, measurable outcome 3 the reviewer validates]

**Trade-offs** _(optional -- include when the executor will face non-obvious decisions)_:
- **[Decision point]**: [Preferred direction] because [rationale]. Alternative: [what else could be done].

**Verification**:
```bash
[run step tests command — see environment guide]
```

**Output**: [X]/[X] tests passing

---

### Step 2: [Name]

**Goal**: [What this step accomplishes]

- [ ] [Implementation item 1]
- [ ] [Implementation item 2]
- [ ] [Write tests]

**Specification**:
- [What to build: behavior, files to create/modify, patterns to follow, constraints]
- [Interface expectations: function/method signatures (without bodies) if needed to communicate API contract]
- [What tests must verify: critical paths and edge cases to cover]

**Acceptance Criteria**:
- [Specific, measurable outcome 1 the reviewer validates]
- [Specific, measurable outcome 2 the reviewer validates]
- [Specific, measurable outcome 3 the reviewer validates]

**Trade-offs** _(optional -- include when the executor will face non-obvious decisions)_:
- **[Decision point]**: [Preferred direction] because [rationale]. Alternative: [what else could be done].

**Verification**:
```bash
[run step tests command — see environment guide]
```

**Output**: [X]/[X] tests passing

---

### Step [N]: [Final Integration/Validation]

**Goal**: [What this final step accomplishes]

- [ ] [Integration item 1]
- [ ] [Integration item 2]
- [ ] [Final validation]

**Specification**:
- [What to integrate, validate, or verify end-to-end]
- [What integration tests must verify: cross-component behavior, full-pipeline checks]

**Acceptance Criteria**:
- [Specific, measurable outcome 1 the reviewer validates]
- [Specific, measurable outcome 2 the reviewer validates]

**Verification**:
```bash
# Run affected tests (identified in Prerequisites)
[run affected tests command — see environment guide]
# Expected: All pass

# (Optional) Full suite - only if time permits
# [run full suite command — see environment guide]
```

**Output**: Affected tests passing

---

## Test Summary

### Affected Tests (Run These)

| Test File | Tests | What It Covers |
|-----------|-------|----------------|
| `[test-file-1]` | ~X | [Description] |
| `[test-file-2]` | ~X | [Description] |

**Affected tests: ~X tests**

**Full suite**: ~X tests (optional - only run at checkpoints or if time permits)

---

## What "Done" Looks Like

```bash
# 1. Affected tests pass
[run affected tests command — see environment guide]
# Expected: All pass

# 2. (Optional) Full suite - only if time permits
# [run full suite command — see environment guide]
# Expected: All pass

# 3. [Specific functionality works - via MCP tool, CLI command, or test]
[command to demonstrate]
# Expected: [what success looks like]
```

---

## Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `[path/to/new-file]` | Create | [purpose] |
| `[path/to/existing-file]` | Modify | [what changes] |
| `[test-files]` | Create | All tests |
| `[dependency-file]` | Modify | [dependencies] |

---

## Dependencies

_(Use environment guide for dependency file format and install commands)_

Update `[path/to/dependency-file]`:

```
[dependency declarations — format per environment guide]
```

Then run:
```bash
[dependency install command — see environment guide]
```

---

## Risks & Mitigations

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| [Risk 1] | H/M/L | [Strategy] |
| [Risk 2] | H/M/L | [Strategy] |

---

## Error Codes Reference

_(Optional - only if this task introduces new error codes)_

| Code | Meaning | Used By |
|------|---------|---------|
| `[ERROR_CODE]` | [Description] | [function/tool] |

---

## Next Steps After Completion

1. Verify affected tests pass (~X tests)
2. Verify [specific success criteria]
3. → Proceed to next task: [Next task]
