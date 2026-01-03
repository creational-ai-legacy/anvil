# Stage 4: Milestone Design

## Goal
Break North Star + Architecture into strategic milestones that group related PoCs.

## Code Allowed
NO - This is pure strategic planning

## Input
- Completed North Star doc (`docs/north-star.md`)
- Completed Architecture doc (`docs/[name]-architecture.md`)
- Optional: Research findings

## Process

### 1. Start with Milestone 1: Core

**Every project starts with Milestone 1: Core**
- Focus: Core functionality that proves the product works
- Size: 10-20 PoCs typically
- Status: Planning (at this stage)

### 2. Assess Path Clarity

**Ask**: Can you see the giant steps to reach the north star?

**Clear Path Visible** (plan 2-3 milestones upfront):
- You can articulate major phases (e.g., "Core → Mobile Support → Enterprise Features")
- Each phase has a clear theme and proof point
- Dependencies between phases are obvious
- Example: Building a SaaS product with known scaling requirements

**Unclear Path** (start with just Core):
- Small/experimental projects
- Novel/unproven concepts
- High uncertainty about what comes after Core
- Example: Proof-of-concept for a new idea

### 3. Define Each Milestone

For each milestone (starting with Core):

**Focus**: What is the theme of this milestone?
- Core: Fundamental product functionality
- Others: A major capability or expansion (mobile, enterprise, scale, etc.)

**Proves**: What does completing this milestone validate?
- Core: "The product works and solves the problem"
- Others: "We can scale to 10K users", "Mobile experience is solid", etc.

**Size**: Expected PoC count (typically 10-20 per milestone)

**Dependencies**: Which milestones must complete first?

### 4. Document Milestone Order

Explain the sequence:
1. Why Core comes first
2. Why Milestone 2 comes next (if applicable)
3. Why Milestone 3 follows (if applicable)

Include:
- Dependencies between milestones
- What each milestone unlocks
- Rationale for the order

### 5. Add Notes

**Organic Growth Note**: Always include reminder that milestones grow organically
- Document starts minimal
- Add more as project evolves
- Path becomes clearer with progress

**Dependencies & Risks**: Document any technical constraints or risks

## Output

`docs/milestones.md` using `assets/templates/milestones.md`

## Verification Checklist

- [ ] Milestone 1: Core is defined
- [ ] Each milestone has clear focus and proof point
- [ ] Milestone order makes sense (dependencies clear)
- [ ] Size estimates reasonable (10-20 PoCs each)
- [ ] Organic growth note included
- [ ] Clear vs unclear path decision documented
- [ ] Run `/verify-doc docs/milestones.md`

## Examples

### Example 1: Clear Path (Mission Control)

```markdown
## Milestone 1: Core MVP (Current)
Focus: Core functionality that proves the product works
Proves: Local project management with MCP tools works end-to-end
Size: 14 PoCs

## Milestone 2: Cloud Deployment
Focus: Scale and multi-tenant access
Proves: Multi-tenant SaaS with authentication works
Size: 8 PoCs

## Milestone Order
1. Core MVP - Proves local functionality first
2. Cloud Deployment - Scales proven local functionality
```

### Example 2: Unclear Path (Small Project)

```markdown
## Milestone 1: Core (Current)
Focus: Core functionality
Proves: Basic video processing pipeline works
Size: 6 PoCs

## Notes
Starting with just Core milestone. Will add Milestone 2 after Core proves viability.
Path unclear - need to validate core concept before planning next steps.
```

## Common Pitfalls

- Planning too many milestones upfront (creates rigidity)
- Making milestones too small (should group 10-20 PoCs)
- Not starting with Core (always start with Core)
- Forgetting organic growth note (users need to know doc grows)

## Next Stage

→ Stage 5: PoC Design (run once per milestone, starting with Core)
