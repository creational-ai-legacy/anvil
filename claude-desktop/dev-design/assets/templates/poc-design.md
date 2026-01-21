# [Milestone Name] PoC Design

## Milestone Overview
[What does completing this Milestone prove? What capability does it unlock?]

## Project
[Parent project name - link to [slug]-north-star.md]

## PoC Dependency Diagram

```
┌──────────────────────┐              ┌──────────────────────┐
│  PoC 1: [Name]       │              │  PoC 2: [Name]       │
│  [Description]       │              │  [Description]       │
└──────────┬───────────┘              └──────────┬───────────┘
           │                                     │
           └─────────────────┬───────────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  PoC 3: [Name]       │
                  │  [Description]       │
                  └──────────┬───────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
      ┌──────────────────────┐   ┌──────────────────────┐
      │  PoC 4: [Name]       │   │  PoC 5: [Name]       │
      │  [Description]       │   │  [Description]       │
      └──────────┬───────────┘   └──────────┬───────────┘
                 │                           │
                 └───────────┬───────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  PoC 6: [Name]       │
                  │  [Description]       │
                  └──────────────────────┘
```

**Parallel tracks**: [Describe which PoCs can run in parallel]

**Note**: This is a plan - NO status indicators (✅ ⬜) in diagram.

## PoCs

### PoC 1: [Name]
- **Proves**: [Specific thing this validates]
- **Unlocks**: [Which PoCs depend on this]
- **Success Criteria**: [Measurable outcome]

### PoC 2: [Name]
- **Proves**: [Specific thing this validates]
- **Unlocks**: [Which PoCs depend on this]
- **Success Criteria**: [Measurable outcome]

### PoC 3: [Name]
...

## Execution Order
1. PoC 1 - [Name] (no dependencies)
2. PoC 2 - [Name] (no dependencies)
3. PoC 3 - [Name] (requires PoC 1)
4. ...

## Integration Points
[How will these PoCs eventually connect?]

## Risk Assessment
| PoC | Risk Level | Mitigation |
|-----|------------|------------|
| PoC 1 | [H/M/L] | [Strategy] |

## Feedback Loops

### If a PoC Fails

**A failed PoC is valuable information, not wasted effort.**

When a PoC doesn't meet success criteria:

1. **Document what we learned** — What specifically failed? Why?
2. **Assess impact** — Does this invalidate the milestone approach? Or just this PoC?
3. **Decide next action**:
   - **Retry with different approach** — Update PoC design and re-attempt
   - **Pivot the milestone** — Revisit milestone-design with new constraints
   - **Revisit architecture** — If fundamental assumption was wrong
   - **Kill the milestone** — If the capability isn't achievable/valuable

### Checkpoint Questions

After each PoC, ask:
- Did we learn something that changes our assumptions?
- Should we update subsequent PoC designs based on this learning?
- Is the milestone still viable and valuable?
