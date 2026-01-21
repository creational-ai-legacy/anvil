# /verify-doc

Verify design or implementation documents are sound, logical, consistent, and free of surprises.

**Guide**: `~/.claude/skills/dev-cycle/references/verify-doc-guide.md`

## Usage

```bash
/verify-doc core-architecture.md
/verify-doc docs/core-poc2-implementation.md check dependency chain
```

## Input

- **Argument (required)**: Single document path
- **Notes (optional)**: Additional context or focus areas

## Process

1. Read the guide
2. Identify document type from filename pattern
3. Load cross-reference docs automatically
4. Run type-specific + universal checks
5. Generate report with issues and recommendations
6. Offer to apply fixes

Read the guide. Follow it exactly.
