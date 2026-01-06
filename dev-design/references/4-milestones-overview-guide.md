# Stage 4: Milestones Overview

## Goal
Break North Star + Architecture into strategic milestones with clear progression, detailed architecture per milestone, and measurable outcomes.

## Code Allowed
NO - This is pure strategic planning

## Input
- Completed North Star doc (`docs/north-star.md`)
- Completed Architecture doc (`docs/[name]-architecture.md`)
- Optional: Research findings

## Process

### 1. Create Milestone Progression Diagram

**Visual Roadmap**: Start by creating a high-level visual showing how milestones build on each other

**Include**:
- Milestone themes (Web-First, Mobile, Scale, etc.)
- Key components per milestone
- Flow arrows showing progression
- Outcome summaries per milestone

**Purpose**: Give reader immediate understanding of the strategic journey

### 2. Define Milestone 1: Core (Always First)

**Every project starts with Milestone 1: Core**

For each milestone, include:

#### Goal
2-3 sentences describing:
- What this milestone achieves
- Why it comes in this order
- What problem it solves
- What you'll validate

#### Architecture Diagram
- Visual representation specific to THIS milestone
- Show components, data flows, integrations
- Keep it focused on what's relevant for this phase

#### What Gets Built
Break into phases with specific deliverables:
```
Phase 1: [Name] (Week/Sprint Range)
- [Specific deliverable 1]
- [Specific deliverable 2]

Phase 2: [Name]
- [Specific deliverable 1]
- [Specific deliverable 2]
```

**Note**: Timelines are optional - focus on phases and deliverables

#### Success Metrics
Measurable outcomes grouped by category:
```
Platform Functionality:
- Chat Widget: Works on web, responds in <3 seconds
- AI Quality: >80% positive feedback

User Acquisition:
- Sign-Ups: 200+ users
- First Action: >60% take action within 7 days
```

#### Key Outcomes
Checkbox list of what this milestone proves:
```
✅ Core platform works
✅ AI validated
✅ Ready for next milestone
```

#### Why [This Approach/Order]?
Rationale for strategic decisions:
```
- Faster iteration: No app store dependencies
- Lower risk: Validate core before complexity
- Better testing: Manual accounts let you test everything
```

### 3. Assess Path Clarity

**Ask**: Can you see the giant steps to reach the north star?

**Clear Path Visible** (plan multiple milestones upfront):
- You can articulate major phases (e.g., "Web-First → Mobile → Scale → Enterprise")
- Each phase has a clear theme and proof point
- Dependencies between phases are obvious
- Example: Platform with known scaling path
- Plan as many milestones as you can see clearly

**Unclear Path** (start with just Core):
- Small/experimental projects
- Novel/unproven concepts
- High uncertainty about what comes after Core
- Add milestones as clarity emerges through execution

### 4. Design Milestone Progression

**Core Principle**: Each milestone should:
1. **Build** on the previous milestone's validated learnings
2. **Validate** a specific capability or assumption
3. **Progress** meaningfully toward the north star

**Example Progression**:
```
M1: Core → Validates basic functionality works
M2: Mobile → Builds on Core, validates mobile integration
M3: Scale → Builds on Mobile, validates multi-tenant architecture
M4: Enterprise → Builds on Scale, validates B2B features
```

Each milestone unlocks the next. Don't skip steps - the progression should feel natural and logical.

### 5. Define Additional Milestones (If Clear Path)

Use same format as Milestone 1 for each additional milestone:
- Goal
- Architecture Diagram
- What Gets Built
- Success Metrics
- Key Outcomes
- Why [This Approach/Order]?

**Keep each milestone focused** on a single theme or major capability expansion.

**How many milestones?** As many as needed to reach your north star. Common patterns:
- Small projects: 1-2 milestones
- Medium projects: 2-4 milestones
- Large platforms: 4-6+ milestones

The number matters less than the clarity of progression.

### 6. Add Strategic Decisions Section

**Why This Milestone Order?**
Explain the rationale for the sequence:
```
1. Web-First (M1):
   - Validate core features without mobile complexity
   - Faster iteration: No app store dependencies
   - Build adapter pattern from the start

2. Mobile Integration (M2):
   - Iron out mobile bugs with one game first
   - Prove adapter pattern works
   - Smaller user base = lower risk
```

**Optional Strategic Sections**:
- Financial Projections (if relevant)
- Cost Analysis
- Resource Requirements
- Risk Assessment

### 7. Document Success Criteria

Create checklist for each milestone AND long-term:

```
### Milestone 1
- [ ] Chat widget works
- [ ] AI quality >80%
- [ ] <$75/month cost

### Milestone 2
- [ ] 200+ users
- [ ] VIP sync 100% accurate
- [ ] Revenue $200+ MRR

### Long-Term Platform
- [ ] 1,000+ members
- [ ] Self-sustaining operation
```

### 8. Add Next Steps

Clear call-to-action:
```
Current Status: Design complete, ready to start Milestone 1
Next Action: Begin Milestone 1 implementation

Detailed Plans (to be created):
- Milestone 1: [Name]
- Milestone 2: [Name]
```

## Output

`docs/milestones-overview.md` using `assets/templates/milestones-overview.md`

## Key Principles

### Design-Focused, Not Timeline-Focused
- Focus on WHAT gets built and WHY, not WHEN
- Timelines are optional in phases - use if helpful, skip if uncertain
- Phases should describe logical groupings, not calendar commitments

### Visual-First Communication
- Diagrams show progression and architecture clearly
- Reader should understand strategy from visuals alone
- Text provides detail and rationale

### Measurable Outcomes
- Every milestone has clear success metrics
- Metrics should be specific and achievable
- Mix quantitative (200+ users) and qualitative (works well) metrics

### Strategic Rationale
- Explain WHY this order makes sense
- Document key decisions and trade-offs
- Help reader understand the thinking

## Verification Checklist

- [ ] Milestone Progression diagram shows overall strategy
- [ ] Milestone 1: Core is fully defined with all sections
- [ ] Each milestone has Goal, Architecture, What Gets Built, Metrics, Outcomes, Why
- [ ] Strategic Decisions section explains milestone order
- [ ] Success Criteria defined for each milestone
- [ ] Next Steps clear
- [ ] Run `/verify-doc docs/milestones-overview.md`

## Examples

### Example 1: Clear Path (Multi-Game Platform)

```markdown
## Milestone Progression

[Visual diagram showing: Web-First → Mobile: Game 1 → Mobile: Game 2]

## Milestone 1: Web-First Core Platform

Goal: Build and validate core platform on web FIRST. Get AI chat, forums,
and automation working perfectly before adding mobile complexity.

Architecture Diagram:
[Shows web-only architecture]

What Gets Built:
Phase 1: Infrastructure Setup
- AWS setup: App Runner, RDS, S3, SES
- Discourse deployment
- Email collection

Phase 2: AI Chat Widget
- Build chat widget UI
- AI-powered support

Success Metrics:
Platform Functionality:
- Chat Widget: <3 second response
- AI Quality: >80% positive feedback

Key Outcomes:
✅ Core platform works on web
✅ Email list collection started
✅ Ready for mobile

Why Web-First Wins?
- Faster iteration: No app store reviews
- Lower risk: Validate before mobile complexity
```

### Example 2: Unclear Path (Small Project)

```markdown
## Milestone Progression

[Simple diagram showing just Milestone 1]

## Milestone 1: Core Functionality

Goal: Prove the basic video processing pipeline works with sample data.

What Gets Built:
Phase 1: Pipeline Setup
- Video ingestion
- Processing workflow
- Output storage

Success Metrics:
- Processes 10 sample videos successfully
- Output quality acceptable

Key Outcomes:
✅ Pipeline functional
✅ Ready to determine next steps

## Strategic Decisions

Starting with just Core milestone. Will add Milestone 2 after Core proves
viability. Path unclear - need to validate core concept first.
```

## Common Pitfalls

- **Too timeline-focused**: Avoid rigid month/week commitments - focus on phases and deliverables
- **Not visual enough**: Add diagrams! They communicate strategy faster than text
- **Missing rationale**: Always explain WHY this order makes sense
- **Vague metrics**: "Works well" → "Responds in <3 seconds with >80% positive feedback"
- **Planning too far ahead**: If path is unclear, start with just Core
- **Skipping architecture diagrams**: Each milestone needs its own architecture view

## Next Stage

→ Stage 5: PoC Design (run once per milestone, starting with Core)
