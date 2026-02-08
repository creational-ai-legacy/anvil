# Python Environment Guide

> **When to read this**: During Stage 2 (Planning) and Stage 3 (Execution) when the project environment is **Python**.

This guide maps the dev workflow's universal principles (OOP, validated data models, strong typing, automated testing) to Python's ecosystem. The core skill is language-agnostic; this guide provides the concrete tooling.

## Quick Reference

| Principle | Python Implementation |
|-----------|----------------------|
| **Test Framework** | pytest |
| **Test Runner** | `uv run pytest` |
| **Data Models** | Pydantic BaseModel |
| **Type System** | Python type hints (PEP 484) |
| **Dependency File** | `pyproject.toml` |
| **Dependency Install** | `uv sync` |
| **Module Structure** | `__init__.py` packages |
| **Inline Verification** | `python -c "..."` |
| **Test File Convention** | `tests/test_[task-slug]_*.py` |

---

## Test Framework: pytest

### Test File Naming

`tests/test_[task-slug]_*.py` — e.g., `test_poc6_core.py`, `test_auth_fix_routes.py`

### Test Class Pattern

```python
class TestClassName:
    """Tests for [component]."""

    def test_scenario_name(self):
        """[Description]."""
        # Arrange
        [setup]

        # Act
        [action]

        # Assert
        [verification]
```

### Running Tests

**Run specific test file:**
```bash
cd [directory] && uv run pytest tests/test_[task-slug]_*.py -v
```

**Run specific test class:**
```bash
cd [directory] && uv run pytest tests/test_[task-slug]_*.py::TestClassName -v
```

**Run affected tests (baseline):**
```bash
cd [directory] && uv run pytest tests/test_[affected1].py tests/test_[affected2].py -v --tb=short
```

**Run full suite (optional, at checkpoints):**
```bash
cd [directory] && uv run pytest tests/ -v --tb=short
```

### Prefer pytest Over Inline Checks

**pytest is always preferred** for verification. Inline Python (`python -c`) is acceptable only for:
- Prerequisites (e.g., "is database connected?", "can we import the module?")
- Step 0 setup verification (e.g., "did the config load correctly?")

**For implementation steps (Step 1+), always use pytest.**

```bash
# ✅ Prerequisites/Step 0 - inline OK for quick checks
python -c "from mymodule import MyClass; print('Import works')"

# ✅ Implementation steps - always pytest
cd [directory] && uv run pytest tests/test_mymodule.py -v
```

---

## Package Manager: uv

### Dependency Management

**Dependency file**: `pyproject.toml`

```toml
dependencies = [
    "existing-dep>=X.Y.Z",
    "new-dep>=X.Y.Z",  # Add for [reason]
]
```

**Install/sync dependencies:**
```bash
cd [directory] && uv sync
```

### Running Commands

All Python commands should be run through uv:
```bash
uv run pytest ...
uv run python script.py
```

---

## Data Models: Pydantic

### Core Principle

Use **Pydantic BaseModel** for all structured data — configs, API payloads, database records, internal data transfer objects.

**Why Pydantic**: Validation, serialization (`.model_dump()`), and self-documentation built-in. Structured data gets a model; ad-hoc lookups stay as dicts.

### Pattern

```python
from pydantic import BaseModel, Field

class ProjectConfig(BaseModel):
    """Configuration for a project."""
    name: str = Field(description="Display name")
    slug: str = Field(description="URL-safe identifier")
    max_retries: int = Field(default=3, ge=1)
```

### When NOT to Use Pydantic

- Simple key-value lookups (use plain dict)
- Throwaway intermediate data in a single function
- When the overhead isn't justified (rare)

---

## Strong Typing

### Type Hints Everywhere

```python
from typing import Optional

def get_user(user_id: str) -> Optional[User]:
    """Fetch user by ID."""
    ...

class UserService:
    """Service for user operations."""

    def __init__(self, db: Database) -> None:
        self.db: Database = db

    def list_active(self) -> list[User]:
        ...
```

### Key Rules

- All function signatures: parameters + return types
- All class attributes
- All method signatures
- Use `Optional[X]` for nullable types

---

## Module Structure

### Package Layout

```
project_root/
├── src/
│   └── package_name/
│       ├── __init__.py       # Package marker + public exports
│       ├── models.py         # Pydantic models
│       ├── service.py        # Business logic classes
│       └── config.py         # Configuration models
├── tests/
│   └── test_[task-slug]_*.py # All tests for task
└── pyproject.toml            # Dependencies
```

### File Extensions

- Source code: `.py`
- Config: `pyproject.toml`
- Tests: `tests/test_*.py`

---

## OOP Design (Python-Specific)

### Classes Over Functions

```python
class TranscriptService:
    """Handles transcript extraction and caching."""

    def __init__(self, cache: CacheService, extractor: Extractor) -> None:
        self.cache = cache
        self.extractor = extractor

    def get_transcript(self, video_id: str) -> Transcript:
        """Get transcript, checking cache first."""
        cached = self.cache.get(video_id)
        if cached:
            return cached
        result = self.extractor.extract(video_id)
        self.cache.store(video_id, result)
        return result
```

**Principles**: Single responsibility per class. Composition over inheritance — inject dependencies via constructor.

---

## Common Pitfalls (Python)

- **Using raw dicts instead of Pydantic models** (loses validation, type safety, documentation)
- **Procedural code instead of OOP** (harder to test, maintain, extend)
- **Missing type hints** (reduces IDE support, increases bugs)
- **Using inline Python for implementation step verification** — use pytest for Steps 1+ (inline OK for prerequisites/Step 0)
- **Separating code and tests into different steps** — tests must be written AND run in the same step as the code
