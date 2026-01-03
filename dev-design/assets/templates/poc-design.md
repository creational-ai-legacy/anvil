# [Milestone Name] PoC Design

## Milestone Overview
[What does completing this Milestone prove? What capability does it unlock?]

## Project
[Parent project name - link to docs/north-star.md]

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

**Note**: This is a plan - NO status indicators (✅ ⬜) in diagram. Status belongs in PROJECT_STATE.md.

## PoCs

### PoC 1: [Name]
- **Proves**: [Specific thing this validates]
- **Unlocks**: [Which PoCs depend on this]
- **Success Criteria**: [Measurable outcome]
- **Estimated Effort**: [T-shirt size: S/M/L]

### PoC 2: [Name]
- **Proves**: [Specific thing this validates]
- **Unlocks**: [Which PoCs depend on this]
- **Success Criteria**: [Measurable outcome]
- **Estimated Effort**: [T-shirt size: S/M/L]

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
