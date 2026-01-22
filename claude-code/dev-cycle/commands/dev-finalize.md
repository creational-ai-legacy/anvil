# /dev-finalize

Wrap up a completed task by running all finalization steps.

## Usage

```bash
/dev-finalize core-poc2
```

## Input

**Argument (required):** Task slug (e.g., `core-poc2`, `cloud-auth-fix`)

The slug is used to find: `docs/[slug]-results.md`

---

## Steps

**ALL 4 STEPS ARE REQUIRED. DO NOT STOP EARLY.**

### Step 1: Timestamp

1. Read `docs/[slug]-results.md`
2. Find the `**Completed**:` field in the header
3. If empty or wrong format:
   - Run `date "+%Y-%m-%dT%H:%M:%S%z"` to get current timestamp
   - Update field to ISO 8601 format: `YYYY-MM-DDTHH:MM:SS±HHMM`
   - Example: `2024-01-08T22:45:00-0800`

### Step 2: Lessons Learned

1. Read the guide: `~/.claude/skills/dev-cycle/references/lessons-guide.md`
2. Read the template: `~/.claude/skills/dev-cycle/assets/templates/lessons-learned.md`
3. Extract lessons from ALL step sections in the results doc
4. Consolidate into `## Lessons Learned` section
5. Update the results doc

### Step 3: Diagram

1. Read the guide: `~/.claude/skills/dev-cycle/references/diagram-guide.md`
2. Read the template: `~/.claude/skills/dev-cycle/assets/templates/diagram.md`
3. Generate ASCII box diagram summarizing what was built
4. Insert/update `## Diagram` section in results doc

### Step 4: Health Check

1. Read the guide: `~/.claude/skills/dev-cycle/references/health-guide.md`
2. Read the template: `~/.claude/skills/dev-cycle/assets/templates/PROJECT_STATE.md`
3. Run the 5-point health assessment
4. Update `PROJECT_STATE.md` with findings

---

## Verification

After completing all 4 steps, verify:

- [ ] `**Completed**:` has ISO 8601 timestamp with timezone
- [ ] `## Lessons Learned` section exists with consolidated lessons
- [ ] `## Diagram` section exists with ASCII box diagram
- [ ] `PROJECT_STATE.md` updated with health check results

**Only report done after all 4 are verified.**

## Output

- Updated `docs/[slug]-results.md` with timestamp, lessons, and diagram
- Updated `PROJECT_STATE.md` with health check
