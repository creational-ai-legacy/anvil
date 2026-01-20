# /dev-finalize

Wrap up a completed task by running all finalization steps.

## Usage

```bash
/dev-finalize core-poc2
```

## Steps

**ALL 3 STEPS ARE REQUIRED. Do not stop early.**

1. **Timestamp** - Check Completed field in results doc. If missing or wrong format, update to ISO 8601 with local timezone (e.g., `2024-01-08T22:45:00-08:00`)

2. **Lessons** - Run `/dev-lessons docs/[slug]-results.md`

3. **Diagram** - Run `/dev-diagram [slug]`

**Confirm all 3 steps completed before finishing.**

## Input

**Argument (required):** Task slug (e.g., `core-poc2`, `cloud-auth-fix`)

The slug is used to:
- Find results doc: `docs/[slug]-results.md`
- Generate diagram for the task
