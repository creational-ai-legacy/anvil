# [Milestone-Slug]-[Task-Slug] Plan

> **Track Progress**: See `docs/[milestone-slug]-[task-slug]-results.md` for implementation status, test results, and issues.

## Overview

| Attribute | Value |
|-----------|-------|
| **Created** | [YYYY-MM-DDTHH:MM:SS-TZ] |
| **Name** | [Name] |
| **Type** | [PoC or Feature or Issue or Refactor] |
| **Proves** | [One sentence: what hypothesis this validates] |
| **Production-Grade Because** | [Why this isn't a toy/mock] |

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
- `tests/test_[affected1].py` - [What it tests]
- `tests/test_[affected2].py` - [What it tests]

**Baseline verification**:
```bash
cd [directory] && uv run pytest tests/test_[affected1].py tests/test_[affected2].py -v --tb=short
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
python -c "[quick verification command]"
# Expected: [what success looks like]
```

### 3. [Prerequisite Name]
...

---

## Success Criteria

From `docs/[source-doc].md`:

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
│   ├── __init__.py           # [Purpose]
│   ├── [file1.py]            # [Purpose]
│   └── [file2.py]            # [Purpose]
├── [existing-file.py]        # Updated
└── tests/
    └── test_[task-slug]_*.py # All tests
```

### Design Principles
1. **OOP Design**: Use classes with single responsibility and clear interfaces
2. **Pydantic Models**: All data structures (configs, payloads, records) use Pydantic BaseModel
3. **Strong Typing**: Type hints on all functions, methods, and class attributes
4. **[Additional Principle]**: [Description if needed]

---

## Implementation Steps

**Approach**: [Brief description of implementation strategy - e.g., "Build bottom-up", "Test each layer independently", etc.]

> ⚠️ **Each step includes its tests.** Write code, write tests, run tests, verify all pass—then move on. Never separate code and tests into different steps.

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
python -c "[quick verification command]"
# Expected: [what success looks like]
```

**Output**: [What's created/changed]

---

### Step 1: [Name]

**Goal**: [What this step accomplishes]

- [ ] [Implementation item 1]
- [ ] [Implementation item 2]
- [ ] [Write tests]

**Code** (add to `[file-path]`):
```python
"""[Description]."""

[actual code to write]
```

**Tests** (add to `tests/test_[task-slug]_*.py`):
```python
"""Tests for [what this step does]."""

class Test[ClassName]:
    """Tests for [component]."""

    def test_[what_it_tests](self):
        """[Description]."""
        # Arrange
        [setup]

        # Act
        [action]

        # Assert
        [verification]
```

**Verification**:
```bash
cd [directory] && uv run pytest tests/test_[task-slug]_*.py::Test[ClassName] -v
```

**Output**: [X]/[X] tests passing

---

### Step 2: [Name]

**Goal**: [What this step accomplishes]

- [ ] [Implementation item 1]
- [ ] [Implementation item 2]
- [ ] [Write tests]

**Code** (update `[file-path]`):
```python
[actual code to write]
```

**Tests** (add to `tests/test_[task-slug]_*.py`):
```python
class Test[ClassName]:
    """Tests for [component]."""

    def test_[scenario](self):
        """[Description]."""
        [test code]
```

**Verification**:
```bash
cd [directory] && uv run pytest tests/test_[task-slug]_*.py::Test[ClassName] -v
```

**Output**: [X]/[X] tests passing

---

### Step [N]: [Final Integration/Validation]

**Goal**: [What this final step accomplishes]

- [ ] [Integration item 1]
- [ ] [Integration item 2]
- [ ] [Final validation]

**Tests** (add to `tests/test_[task-slug]_*.py`):
```python
class Test[Integration]:
    """Integration tests for [task name]."""

    def test_[end_to_end_scenario](self):
        """[Description]."""
        [test code]
```

**Verification**:
```bash
# Run affected tests (identified in Prerequisites)
cd [directory] && uv run pytest tests/test_[affected1].py tests/test_[affected2].py -v --tb=short
# Expected: All pass

# (Optional) Full suite - only if time permits (~2+ min)
# cd [directory] && uv run pytest tests/ -v --tb=short
```

**Output**: Affected tests passing

---

## Test Summary

### Affected Tests (Run These)

| Test File | Tests | What It Covers |
|-----------|-------|----------------|
| `tests/test_[affected1].py` | ~X | [Description] |
| `tests/test_[affected2].py` | ~X | [Description] |

**Affected tests: ~X tests**

**Full suite**: ~X tests (optional - only run at checkpoints or if time permits)

---

## Production-Grade Checklist

Before marking task complete, verify:

- [ ] **OOP Design**: Classes with single responsibility and clear interfaces
- [ ] **Pydantic Models**: All data structures use Pydantic (no raw dicts for structured data)
- [ ] **Strong Typing**: Type hints on all functions, methods, and class attributes
- [ ] **No mock data**: All data comes from real sources (DB, API, files)
- [ ] **Real integrations**: External services are actually connected, not stubbed
- [ ] **Error handling**: Failures are handled, not ignored
- [ ] **Scalable patterns**: Code structure would work at 10x scale
- [ ] **Tests in same step**: Each step writes AND runs its tests (never separated)
- [ ] **Config externalized**: No hardcoded secrets or environment-specific values
- [ ] **Clean separation**: Each file has single responsibility
- [ ] **Self-contained**: Works independently; all existing functionality still works; doesn't require future tasks

---

## What "Done" Looks Like

```bash
# 1. Affected tests pass
cd [directory] && uv run pytest tests/test_[affected1].py tests/test_[affected2].py -v --tb=short
# Expected: All pass

# 2. (Optional) Full suite - only if time permits
# cd [directory] && uv run pytest tests/ -v --tb=short
# Expected: All pass

# 3. [Specific functionality works - via MCP tool, CLI command, or pytest]
[command to demonstrate]
# Expected: [what success looks like]
```

---

## Files to Create/Modify

| File | Action | Status |
|------|--------|--------|
| `[path/to/new-file.py]` | Create | Pending: [purpose] |
| `[path/to/existing-file.py]` | Modify | Pending: [what changes] |
| `tests/test_[task-slug]_*.py` | Create | Pending: all tests |
| `pyproject.toml` | Modify | Pending: [dependencies] |

---

## Dependencies

Update `[path/to/pyproject.toml]`:

```toml
dependencies = [
    "[existing-dep]>=X.Y.Z",
    "[new-dep]>=X.Y.Z",  # Add for [reason]
    ...
]
```

Then run:
```bash
cd [directory] && uv sync
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

1. ✅ Verify affected tests pass (~X tests)
2. ✅ Verify [specific success criteria]
3. → Proceed to next task: [Next task]
