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

### 4. Document Milestone Order

Milestones are sequential. Simply note the order:

1. Core (always first)
2. [Next milestone] - why it comes second
3. [Next milestone] - why it comes third

No complex dependencies. Complete one, start the next.

### 5. Add Notes

**Risks**: Document any risks that could impact milestone completion

## Output

`docs/milestones.md` using `assets/templates/milestones.md`

## Verification Checklist

- [ ] Milestone 1: Core is defined
- [ ] Each milestone has clear focus and proof point
- [ ] Milestone order makes sense (sequential)
- [ ] Run `/verify-doc docs/milestones.md`

## Examples

### Example 1: Clear Path (Mission Control)

```markdown
## Milestone 1: Core MVP (Current)
Focus: Core functionality that proves the product works
Proves: Local project management with MCP tools works end-to-end
Status: Planning

## Milestone 2: Cloud Deployment
Focus: Scale and multi-tenant access
Proves: Multi-tenant SaaS with authentication works
Status: Planning

## Milestone Order
1. Core MVP - Proves local functionality first
2. Cloud Deployment - Scales proven local functionality
```

### Example 2: Unclear Path (Small Project)

```markdown
## Milestone 1: Core (Current)
Focus: Core functionality
Proves: Basic video processing pipeline works
Status: Planning

## Notes
Starting with just Core milestone. Will add Milestone 2 after Core proves viability.
Path unclear - need to validate core concept before planning next steps.
```

## Common Pitfalls

- Planning too many milestones upfront (creates rigidity)
- Not starting with Core (always start with Core)

## Next Stage

→ Stage 5: PoC Design (run once per milestone, starting with Core)
