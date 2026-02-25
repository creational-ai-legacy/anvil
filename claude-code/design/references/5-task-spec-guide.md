# Stage 5: Task Spec

## Goal
Define atomic tasks with dependencies and success criteria -- with PRODUCTION-GRADE thin slices.

## Code Allowed
NO

## Timeline Estimates
NOT NEEDED - Focus on WHAT and WHY, not WHEN. Avoid timeline estimates (e.g., "Week 1-2", "2 weeks", "3 months"). Design phases don't need schedules.

## Input
- Milestone Spec from `docs/[slug]-milestone-spec.md` (Stage 4 output)
- Roadmap from `docs/[slug]-roadmap.md` (Stage 3 output)
- Architecture doc (`docs/[slug]-architecture.md`) (Stage 2 output)

**Note**: Run this stage once per milestone, starting with Core.

## Process
1. Refine architecture with implementation perspective
2. Identify atomic tasks
3. Map dependencies between tasks
4. Create task diagram
5. Define success criteria for each task

## Output
`docs/[slug]-task-spec.md` using `assets/templates/5-task-spec.md`

Example: `docs/core-task-spec.md`, `docs/cloud-deployment-task-spec.md`

## Verification Checklist
- [ ] Template read from `assets/templates/5-task-spec.md`
- [ ] Output follows template structure exactly
- [ ] Each task validates one specific thing
- [ ] Dependencies mapped (which tasks unlock others)
- [ ] Success criteria measurable
- [ ] Order of execution clear
- [ ] Feedback loop guidance included
- [ ] Run `/verify-doc docs/[slug]-task-spec.md`

## What Makes a Good Task

### A Task Should:
- Validate ONE specific technical or business assumption
- Be small enough to complete in 1-3 sessions
- Have clear, measurable success criteria
- Build toward the final MVP

### A Task Should NOT:
- Try to validate multiple things at once
- Be so large it feels like a project itself
- Have vague "it works" success criteria
- Be disconnected from the end goal

## Task Requirements

Each task must be:
- **Atomic**: Validates one specific thing (one capability/assumption, NOT one sub-task - may include multiple related sub-tasks)
- **Measurable**: Clear success criteria
- **Self-contained**: Works independently; doesn't break existing functionality and existing tests

**Why self-contained matters:**
- Each task is complete within its scope (doesn't need non-dependent tasks to work)
- System remains functional between tasks (no breaking changes to existing functionality/tests)
- Prevents cascading failures
- Clearly shows what it validates and what capabilities it opens up for dependent tasks
- Safe to pause work at any task boundary

## Task Types

Each task has a Type that determines its framing:

| Type | Purpose | Validates |
|------|---------|-----------|
| **PoC** | Validate technical approach or assumption | "Can we do X?" |
| **Feature** | Deliver new capability | "X works end-to-end" |
| **Issue** | Fix a bug | "X no longer occurs" |
| **Refactor** | Improve code structure | "X works the same but better" |

**New projects** typically start with PoC-type tasks (proving technical feasibility).
**Established projects** mix Feature, Issue, and Refactor tasks.
**A single task spec can contain mixed types** -- e.g., Database Schema (PoC), User Management (Feature).

**CRITICAL: Minimize the Number of Tasks**

**Golden Rule**: One capability = One task (unless it spans the entire stack)

**When to use ONE task:**
- Feature is contained in one layer (frontend OR backend OR database)
- Related sub-tasks that test the same capability together
- CRUD operations for a single entity (Create + Read + Update + Delete users)
- All sub-tasks validate the same technical assumption

**When to split into multiple tasks:**
- Feature spans entire stack (database + API + frontend) and each layer needs independent testing
- Clear dependency boundaries (Task B literally cannot start until Task A is validated)
- Different technical risks that should be validated separately
- **BUT STILL MINIMIZE** - If you can test 2 layers together, do it

**GOOD - Minimized tasks:**
```
Task: User Management (One task)
   - Database schema for users
   - CRUD API endpoints
   - Authentication logic
   - Tests for all operations
   - Validates: "We can manage users end-to-end"
```

**BAD - Too many micro-tasks:**
```
Task: User Database Schema
Task: Create User API
Task: Read User API
Task: Update User API
Task: Delete User API
Task: User Authentication
```

**When forced to split (e.g., full-stack feature):**
```
Task: User Management Backend
   - Database + API + Auth (grouped)
   - Validates: "Backend handles users correctly"

Task: User Management Frontend
   - UI components + forms + state
   - Validates: "Frontend integrates with user API"
```

**Remember**: Every additional task adds overhead. Group related work aggressively.

## Task Dependency Mapping

Create a diagram showing:
- Which tasks can run in parallel (no dependencies)
- Which tasks depend on others
- The critical path to MVP

**Format**: Use boxes for each task with clear names. No status indicators (this is a plan, not status tracking).

Example:
```
+-----------------------------+              +-----------------------------+
|  Task: Database Schema      |              |  Task: API Server Basic     |
+-------------+---------------+              +-------------+---------------+
              |                                            |
              +--------------------+-----------------------+
                                   |
                                   v
                     +-----------------------------+
                     |  Task: CRUD Operations      |
                     +-------------+---------------+
                                   |
                      +------------+------------+
                      |                         |
                      v                         v
        +-----------------------------+   +-----------------------------+
        |  Task: Analytics            |   |  Task: Reports              |
        +-------------+---------------+   +-------------+---------------+
                      |                                 |
                      +------------+------------+-------+
                                   |
                                   v
                     +-----------------------------+
                     |  Task: E2E Integration      |
                     +-----------------------------+
```

**Key Points**:
- Each task gets a box with its name and brief description
- Use vertical flow (top to bottom) for main dependency path
- Show parallel tasks side by side at the same level
- Use arrows to show dependencies
- Keep it clean - NO status indicators in the plan diagram


## Production-Grade Reminder

Even at planning stage, think production:
- Real databases, not mock data
- Real APIs, not stubs
- Real error handling, not happy-path only
- Patterns that scale

## Feedback Loops: When Tasks Fail

**A failed task is valuable information, not wasted effort.**

When a task doesn't meet success criteria:

1. **Document what we learned** -- What specifically failed? Why?
2. **Assess impact** -- Does this invalidate the milestone approach? Or just this task?
3. **Decide next action**:
   - **Retry with different approach** -- Update task design and re-attempt
   - **Pivot the milestone** -- Revisit milestone-spec with new constraints
   - **Revisit architecture** -- If fundamental assumption was wrong
   - **Kill the milestone** -- If the capability isn't achievable/valuable

**Checkpoint Questions** (after each task):
- Did we learn something that changes our assumptions?
- Should we update subsequent task designs based on this learning?
- Is the milestone still viable and valuable?

## Common Pitfalls
- Planning too many tasks
- Tasks that are too large
- Missing critical dependencies
- Vague success criteria

## Next Stage
-> Hand off to dev skill for implementation
