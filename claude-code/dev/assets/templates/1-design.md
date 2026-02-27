# [Milestone-Slug]-[Task-Slug] Design

> **Purpose**: Analyze and design solutions before implementation planning
>
> **Important**: This task must be self-contained (works independently; doesn't break existing functionality and existing tests)

## Executive Summary

| Attribute | Value |
|-----------|-------|
| **Created** | [YYYY-MM-DDTHH:MM:SS±HHMM] |
| **Task** | [Brief description of what needs to be done] |
| **Type** | [PoC / Feature / Issue / Refactor] |
| **Scope** | [What areas/components are affected] |
| **Code** | NO - This is a design document |
| **Risk Profile** | [Critical / Standard / Exploratory] |
| **Risk Justification** | [One sentence -- why this level] |

**Challenge**: [One sentence - what needs to be built/fixed/proven]

**Solution**: [One sentence - the proposed approach]

---

## Context

### Current State

[Describe what exists today - the starting point]

- [Current behavior/implementation 1]
- [Current behavior/implementation 2]
- [Limitations or issues]

### Target State

[Describe the desired end state]

- [Desired behavior 1]
- [Desired behavior 2]
- [Benefits achieved]

Include architecture diagram if helpful:
```
Component A
    ├─→ Subcomponent 1
    └─→ Subcomponent 2 (NEW)
            └─→ Detail
```

---

## Constraints

- **Scope boundaries**: [What is explicitly out of scope]
- **Must NOT happen**: [Changes, behaviors, or side effects that are off-limits]
- **Compatibility**: [Existing interfaces, APIs, or contracts that must not break]
- **Performance**: [Latency, throughput, or resource limits if applicable]
- **Other guardrails**: [Any additional hard constraints]

---

## Analysis

> Each item analyzed independently. No implied order - read in any sequence.

### 1. [Name]

**What**: [Description - what needs to be built/fixed/proven]

**Why**: [Impact and importance - why this matters]

**Approach**:
[How we'll solve it - be detailed about the technical approach]

---

### 2. [Name]

**What**: [Description]

**Why**: [Impact and importance]

**Approach**:
[Detailed technical approach - patterns, files, validation]

---

### N. [Name]

**What**: [Description]

**Why**: [Impact and importance]

**Approach**:
[Detailed technical approach]

---

## Proposed Sequence

> Shows dependencies and recommended order. Planning stage will create actual implementation steps.

**Order**: #1 → #2 → #3 → #4

### #1: [Item Name]

**Depends On**: None

**Rationale**: [Explain why this is first - e.g., "Foundation that all other items depend on"]

**Notes**: [Optional - any special considerations]

---

### #2: [Item Name]

**Depends On**: #1

**Rationale**: [Explain the reasoning - e.g., "Requires async methods from #1 to be in place"]

**Notes**: [Optional - any special considerations]

---

### #N: [Item Name]

**Depends On**: [List prerequisites]

**Rationale**: [Explain the reasoning]

**Notes**: [Optional - any special considerations]

---

## Success Criteria

- [ ] [Criterion 1 - specific, measurable]
- [ ] [Criterion 2 - specific, measurable]
- [ ] [Criterion 3 - specific, measurable]
- [ ] All existing tests pass
- [ ] New functionality works independently

---

## Implementation Options

### Option A: [Name] (Recommended)

[Description of approach]

**Pros**:
- [Advantage 1]
- [Advantage 2]

**Cons**:
- [Disadvantage 1]

### Option B: [Name]

[Description of approach]

**Pros**:
- [Advantage 1]

**Cons**:
- [Disadvantage 1]
- [Disadvantage 2]

### Recommendation

[Option A] because: [rationale]

---

## Files to Modify

> Include this section to give clear scope of changes.

| File | Change | Complexity |
|------|--------|------------|
| `path/to/file.py` | Create - [description] | Low/Med/High |
| `path/to/existing.py` | Modify - [description] | Low/Med/High |

---

## Testing Strategy

> Include this section to outline how changes will be verified.

**Unit Tests**:
- [What to test at unit level]

**Integration Tests**:
- [What to test end-to-end]

**Manual Validation**:
- [Steps to manually verify]

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | HIGH/MED/LOW | HIGH/MED/LOW | [How to mitigate] |
| [Risk 2] | HIGH/MED/LOW | HIGH/MED/LOW | [How to mitigate] |

---

## Open Questions

1. **[Question 1]**: [What needs to be decided and when]
2. **[Question 2]**: [What needs to be decided and when]

---

## Decisions Log

| Decision | Choice | Rationale |
|----------|--------|-----------|
| [Decision 1] | [What was chosen] | [Why] |
| [Decision 2] | [What was chosen] | [Why] |

---

## Next Steps

1. Review this design and confirm approach
2. Run `/review-doc` to check for issues
3. Create implementation plan (`/dev-plan`)
4. Execute implementation (`/dev-execute`)
