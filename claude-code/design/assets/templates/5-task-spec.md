# [Milestone Name] Task Spec

## Milestone Overview
[What does completing this Milestone prove? What capability does it unlock?]

## Project
[Parent project name - link to [slug]-vision.md]

## Task Dependency Diagram

```
┌──────────────────────┐              ┌──────────────────────┐
│  Task: [Name]        │              │  Task: [Name]        │
│  [Description]       │              │  [Description]       │
└──────────┬───────────┘              └──────────┬───────────┘
           │                                     │
           └─────────────────┬───────────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  Task: [Name]        │
                  │  [Description]       │
                  └──────────┬───────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
      ┌──────────────────────┐   ┌──────────────────────┐
      │  Task: [Name]        │   │  Task: [Name]        │
      │  [Description]       │   │  [Description]       │
      └──────────┬───────────┘   └──────────┬───────────┘
                 │                           │
                 └───────────┬───────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  Task: [Name]        │
                  │  [Description]       │
                  └──────────────────────┘
```

**Parallel tracks**: [Describe which tasks can run in parallel]

## Tasks

### Task: [Name]
- **Type**: [PoC / Feature / Issue / Refactor]
- **Validates**: [What this task proves/delivers/fixes]
- **Unlocks**: [Which tasks depend on this]
- **Success Criteria**: [Measurable outcome]

### Task: [Name]
- **Type**: [PoC / Feature / Issue / Refactor]
- **Validates**: [What this task proves/delivers/fixes]
- **Unlocks**: [Which tasks depend on this]
- **Success Criteria**: [Measurable outcome]

### Task: [Name]
...

## Execution Order
1. Task: [Name] (no dependencies)
2. Task: [Name] (no dependencies)
3. Task: [Name] (requires [Name])
4. ...

## Integration Points
[How will these tasks eventually connect?]

## Risk Assessment
| Task | Risk Level | Mitigation |
|------|------------|------------|
| Task: [Name] | [HIGH/MED/LOW] | [Strategy] |

## Feedback Loops

### If a Task Fails

**A failed task is valuable information, not wasted effort.**

When a task doesn't meet success criteria:

1. **Document what we learned** — What specifically failed? Why?
2. **Assess impact** — Does this invalidate the milestone approach? Or just this task?
3. **Decide next action**:
   - **Retry with different approach** — Update task design and re-attempt
   - **Pivot the milestone** — Revisit milestone spec with new constraints
   - **Revisit architecture** — If fundamental assumption was wrong
   - **Kill the milestone** — If the capability isn't achievable/valuable

### Checkpoint Questions

After each task, ask:
- Did we learn something that changes our assumptions?
- Should we update subsequent task designs based on this learning?
- Is the milestone still viable and valuable?
