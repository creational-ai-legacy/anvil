# Verify Document Guide

Verify design or implementation documents are sound, logical, consistent, and free of surprises.

## Input

- **Document**: Single file path
- **Notes**: Optional user context

## Document Type Recognition

Identify document type from filename pattern:

### Design Docs (dev-design)

| Pattern | Type | Cross-Reference |
|---------|------|-----------------|
| `*-north-star.md` | North Star | None (root document) |
| `*-architecture.md` | Architecture | north-star |
| `*-milestones-overview.md` | Milestones Overview | architecture, north-star |
| `[milestone]-milestone.md` | Milestone Design | milestones-overview, architecture |
| `[milestone]-poc-design.md` | PoC Design | milestone design |

### Dev Docs (dev-cycle)

| Pattern | Type | Cross-Reference |
|---------|------|-----------------|
| `docs/[slug]-overview.md` | Task Overview | poc-design or milestone design |
| `docs/[slug]-implementation.md` | Implementation Plan | overview for same slug |
| `docs/[slug]-results.md` | Results | implementation (rarely verified) |
| `docs/[milestone]-milestone-details.md` | Milestone Details | all task results for milestone |

## Verification Process

### 1. Identify Document Type

Match filename against patterns above to determine:
- Document type
- Which supporting docs to read

### 2. Load Supporting Docs

Read cross-reference documents based on type. These provide context for verification.

### 3. Template Alignment

Each doc type has a template. Verify the document follows its template structure:

| Doc Type | Template Location |
|----------|-------------------|
| North Star | `~/.claude/skills/dev-design/assets/templates/north-star.md` |
| Architecture | `~/.claude/skills/dev-design/assets/templates/architecture.md` |
| Milestones Overview | `~/.claude/skills/dev-design/assets/templates/milestones-overview.md` |
| Milestone Design | `~/.claude/skills/dev-design/assets/templates/milestone-design.md` |
| PoC Design | `~/.claude/skills/dev-design/assets/templates/poc-design.md` |
| Task Overview | `~/.claude/skills/dev-cycle/assets/templates/overview.md` |
| Implementation Plan | `~/.claude/skills/dev-cycle/assets/templates/implementation-plan.md` |
| Results | `~/.claude/skills/dev-cycle/assets/templates/implementation-results.md` |

Check:
- Required sections present
- Section order matches template
- No missing fields

### 4. Type-Specific Checks

**Design Docs** (north-star, architecture, milestones-overview, milestone, poc-design):
- Vision alignment with parent docs
- Scope consistency
- Terminology consistency
- Feasibility of proposed approach

**Task Overview** (NO CODE - design only):
- Alignment with poc-design or milestone design
- Clear problem statement
- Defined success criteria
- Reasonable scope
- **Approach is sound** - makes technical sense
- **Approach is incremental** - builds on existing code, doesn't require big-bang rewrites
- **No code in document** - this is design phase only

**Implementation Plan**:
- Steps match overview goals
- Dependency chain complete (each step sets up the next)
- Self-contained steps (code + tests together)
- No missing prerequisites

**Milestone Details** (rarely verified):
- Accurate status for each task
- Consistent with individual results docs
- Complete coverage of all tasks

### 5. Universal Checks

Apply to all document types:

**Soundness**
- Overall approach coherent and feasible
- No logical flaws or contradictions
- Realistic scope
- Assumptions clearly stated

**Step Flow** (for docs with steps/phases)
- Logical ordering
- Smooth transitions
- Complete before moving on

**Dependency Chain**
- Each step produces what next step needs
- No circular dependencies
- No unused outputs
- Flag: step uses something not yet created
- Flag: step creates something never used

**Contradictions**
- Within document: conflicting statements
- With cross-referenced docs: misaligned definitions
- Inconsistent terminology (same concept, different names)
- Success criteria that contradict implementation approach

**Clarity**
- No vague language ("should probably", "might need")
- Specific examples where needed
- Consistent terminology
- No missing context (assumes knowledge not stated)

**Hunt for Surprises**
- Hidden dependencies: assumes something exists that isn't explicitly created
- External dependencies: APIs, services, credentials that might not be available
- Environment assumptions: tools, versions, permissions assumed but not checked
- Edge cases: what could go wrong that isn't addressed
- Missing error handling: what if a step fails

### 6. Codebase Verification

Use Glob, Grep, Read to verify:
- Referenced files/functions exist
- Proposed structure compatible with existing patterns
- Dependencies already configured
- PoC code matches what's described

### 7. External Sources (if needed)

Use WebSearch only if document makes claims about:
- External library APIs or behavior
- Version compatibility
- Third-party service configurations
- Best practices that might have changed

### 8. Generate Report

Output verification report:

```
## Verification Report: [Document Name]

**Document**: [path]
**Type**: [identified type]
**Status**: ✅ Sound | ⚠️ Issues Found | ❌ Needs Revision

**Notes**: [user-provided notes if any]

---

### Document Analysis

#### Soundness
[Is the overall approach coherent and feasible?]

#### Step Flow
[Are steps logical and smooth? Any ordering issues?]

#### Dependency Chain
| Step | Produces | Next Step Needs | Status |
|------|----------|-----------------|--------|
| Step 1 | X, Y | Y, Z | ✅ OK / ⚠️ Gap |

#### Potential Surprises
- **[High/Med/Low]**: [Description of gotcha or hidden assumption]

#### Cross-Reference Check
- [x] Aligned with [parent doc]
- [ ] Conflict found: [description]

---

### Issues Found

#### Contradictions
| Location | Contradiction | Impact |
|----------|---------------|--------|
| Section X | [What conflicts] | High/Med/Low |

#### Unclear or Ambiguous
| Location | Issue | Suggested Fix |
|----------|-------|---------------|
| Line X | Vague: "might need" | Change to: "Must..." |

---

### Summary

| Issue | Location | Impact | Fix |
|-------|----------|--------|-----|
| [Type] | [section] | High/Med/Low | [How to fix] |

### Recommendations
1. **[High/Med/Low]** - [Specific actionable fix]
```

### 9. Offer Fixes

If issues found, ask user:
- Apply all fixes
- Let user pick which to apply
- Just the report

---

## Key Questions

By the end of verification, answer:

1. **Is it sound?** Does the overall plan make sense?
2. **Is it logical?** Are steps in the right order?
3. **Is it smooth?** Do steps flow naturally into each other?
4. **Does each step set up the next?** Is the dependency chain complete?
5. **Any surprises?** What could go wrong that we haven't thought of?
6. **Any contradictions?** Do any statements conflict with each other?
7. **Is it clear?** Are instructions unambiguous and complete?
8. **Aligned with parent docs?** Consistent with cross-referenced documents?

---

## Quick Reference

1. **Identify** - Match filename to doc type
2. **Load** - Read cross-reference docs for context
3. **Template** - Check doc follows its template structure
4. **Type-specific** - Checks per doc type (overview = NO CODE, sound, incremental)
5. **Universal** - Soundness, flow, dependencies, contradictions, clarity, surprises
6. **Codebase** - Verify against existing code
7. **External** - WebSearch if needed for APIs/versions
8. **Report** - Issues and recommendations
9. **Fix** - Offer to apply changes
