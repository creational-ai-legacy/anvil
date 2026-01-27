# Stage 4: Milestone Design

## Goal
Expand a single milestone from `[slug]-milestones-overview.md` into a comprehensive, self-contained design document with implementation details.

## Code Allowed
NO - This is pure design planning

## Timeline Estimates
NOT NEEDED - Focus on WHAT and WHY, not WHEN. Avoid timeline estimates (e.g., "Week 1-2", "2 weeks", "3 months"). Design phases don't need schedules.

## Input
- Completed Milestones Overview (`[slug]-milestones-overview.md`) (Stage 3 output)
- Completed Architecture doc (`[slug]-architecture.md`) (Stage 2 output)

**Note**: Run this process once per milestone, starting with Core.

## Process

### 1. Select Your Milestone

Choose which milestone to detail (usually Core first).

From `milestones-overview.md`, you already have:
- Goal (2-3 sentences)
- Architecture Diagram (high-level)
- What Gets Built (phases with deliverables)
- Success Metrics
- Key Outcomes
- Why This Approach

**This detailed doc expands each of these with implementation perspective.**

### 2. Write Executive Summary

**Purpose**: Give readers immediate context before diving into details.

**Include**:
- 2-3 paragraphs describing:
  - What this milestone accomplishes
  - Why it's important
  - How it fits into the overall roadmap
- Pull from the Goal section in milestones-overview.md and expand with context
- Add a **Key Principle**: One sentence capturing the core philosophy

**Example**:
```markdown
## Executive Summary

This milestone builds and validates the core platform on web FIRST. We get AI chat,
forums, and automation working perfectly before adding mobile complexity. This
web-first approach lets us iterate faster, test thoroughly, and prove the core
concept before expanding to mobile platforms.

This milestone establishes the foundation for everything that follows: the adapter
pattern for platform abstraction, the AI-powered chat system, and the community
infrastructure. Every component is production-grade from day one, not prototypes.

**Key Principle**: Validate core functionality on web where iteration is fastest,
then expand to mobile with proven patterns.
```

### 3. Expand the Goal Section

**Copy** the Goal from milestones-overview.md, then **add**:

**What This Milestone Proves**:
- List 3-5 specific proof points
- What capability or assumption gets validated?

**What This Milestone Does NOT Include**:
- Explicitly state what's out of scope
- What comes later
- Common misconceptions to avoid

**Example**:
```markdown
## Goal

Build and validate core platform on web FIRST. Get AI chat, forums, and automation
working perfectly before adding mobile complexity.

**What This Milestone Proves**:
- AI chat can provide valuable, context-aware support
- Discourse forums work for community building
- Email collection captures interested users
- Adapter pattern enables future mobile integration
- Full system runs under $75/month with AWS credits

**What This Milestone Does NOT Include**:
- Mobile integration (comes in later milestone)
- RevenueCat VIP sync (needs mobile users)
- Multi-game support (single game for validation)
- Auto-scaling (manual scaling is fine for MVP)
```

### 4. Expand Architecture Overview

**Copy** the architecture diagram from milestones-overview.md into the High-Level System Diagram section.

**Add three new subsections**:

#### Technology Stack
Break down by layer with purpose:
```markdown
**Frontend**:
- HTML/CSS/JavaScript: Chat widget UI
- Discourse: Forum platform

**Backend**:
- App Runner: Python web server
- Inngest: Workflow orchestration
- Claude API: AI responses

**Infrastructure**:
- RDS PostgreSQL: 20GB gp3, db.t4g.micro - User & chat data
- S3: Standard storage - Email templates, logs
- SES: Email sending - Notifications, reports
```

#### Cost Structure
Detail the financial model:
```markdown
**Cost Structure**:
- AWS services: ~$60/month baseline
- Claude API: ~$15/month (estimated usage)
- AWS credits: $200/month for 2 years
- Net cost: $0/month (covered by credits)
- Post-credits: $75/month
```

### 5. Design Core Components

**This is the most detailed section.** For each major component (3-6 typically):

#### Template for Each Component:
```markdown
### 1. [Component Name]

**Purpose**: [What this component does and why it's needed]

**Features**:
- [Feature 1]
- [Feature 2]
- [Feature 3]

**User Flow** or **System Flow**:
```
[Describe the flow]
Step 1
  ↓
Step 2
  ↓
Step 3
```

**Technical Design**:
- [Design decision 1]
- [Design decision 2]
- [Design decision 3]

**Integration Points**:
- [System/API 1]: [How it integrates]
- [System/API 2]: [How it integrates]
```

**Examples of Components**:
- AI Chat Widget
- Email Collection System
- Discourse Forum Integration
- Admin Dashboard
- Workflow Orchestration

### 6. Detail Implementation Phases

**Copy** the phases from milestones-overview.md, then **expand each**:

#### For Each Phase:
```markdown
### Phase 1: [Phase Name]

**Objective**: [What this phase achieves - one sentence]

**Deliverables**:
- [Specific deliverable 1 with technical details]
- [Specific deliverable 2 with technical details]
- [Specific deliverable 3 with technical details]

**Configuration** (if applicable):
- [Config item 1: specific values/settings]
- [Config item 2: specific values/settings]

**Success Criteria**:
- ✅ [Criterion 1 - measurable]
- ✅ [Criterion 2 - measurable]
- ✅ [Criterion 3 - measurable]
```

**For the final phase**, add:
```markdown
**Production Launch**:
- [Launch step 1]
- [Launch step 2]
- [Launch step 3]
```

**Example**:
```markdown
### Phase 1: Infrastructure Setup

**Objective**: Establish AWS foundation for the entire platform

**Deliverables**:
- AWS App Runner service configured with Python 3.11 runtime
- RDS PostgreSQL database (db.t4g.micro, 20GB gp3)
- S3 buckets for templates, logs, backups
- SES configured and verified for mochibits.com domain
- CloudFront distribution (if needed)

**Configuration**:
- App Runner: 1 vCPU, 2GB RAM, auto-scaling 1-3 instances
- RDS: PostgreSQL 15, automated backups, encryption at rest
- S3: Standard storage class, lifecycle policies for logs

**Success Criteria**:
- ✅ App Runner deploys successfully and responds to health checks
- ✅ RDS accessible from App Runner with test connection
- ✅ SES sends test email successfully
```

### 7. Expand Success Metrics

**Copy** metrics from milestones-overview.md, then **add detail**:

For each metric, include:
- Target from overview
- How it's measured
- Why this metric matters

**Example**:
```markdown
### Platform Functionality

**Chat Widget Response Time**:
- Target: <3 seconds from user message to AI response
- Measured: Server logs tracking Claude API latency + processing time
- Why: Fast responses feel conversational, slow responses frustrate users

**AI Quality Score**:
- Target: >80% positive feedback on AI responses
- Measured: Thumbs up/down widget in chat, weekly surveys
- Why: Validates AI provides genuine value, not just noise
```

### 8. Add Testing Strategy

**Philosophy**: Production-grade quality from day one, but sized for first 200 users.

**Include**:
- **Test Coverage Approach**: What gets unit tested, integration tested, E2E tested
- **Quality Gates**: What must pass before deployment
- **What We're NOT Testing (Yet)**: Tests deferred until scale milestone

**Example**:
```markdown
## Testing Strategy

### Test Coverage Approach
- **Unit Tests**: Core business logic, data transformations, validation rules
- **Integration Tests**: API endpoints, database operations, external service calls
- **E2E Tests**: User registration flow, core purchase flow, AI chat conversation

### Quality Gates
- All tests pass before merge
- Manual smoke test on staging before production deploy

### What We're NOT Testing (Yet)
- Load testing (deferred until 200+ users)
- Penetration testing (deferred until security milestone)
- Performance benchmarks (deferred until scale milestone)
```

### 9. Add Key Outcomes

**Copy** from milestones-overview.md. Optionally **expand** with sub-bullets if helpful:

```markdown
✅ **Core platform works on web**
   - All components deployed and functional
   - No critical bugs blocking user experience

✅ **AI chat validated with real users**
   - Users find responses helpful
   - Response quality meets >80% positive feedback target
```

### 10. Add "Why This Approach?" Section

If milestones-overview.md has a "Why [X]?" section, **copy and optionally expand**.

If not, **create** based on strategic decisions in the architecture:

```markdown
## Why Web-First Wins?

**Faster Iteration**:
- No app store review delays (instant deploys)
- Easier debugging (browser dev tools)
- Rapid testing with real users

**Lower Technical Risk**:
- Validate core features before mobile complexity
- Build adapter pattern from the start
- Iron out AI prompts and workflows

**Better Testing**:
- Manual user accounts let you test everything
- Easier to observe user behavior
- Simpler to gather feedback
```

### 11. Document Design Decisions & Rationale

For each major technology or approach choice, explain:
- Why this was chosen
- What benefits it provides
- What alternative was considered (and why rejected)

**Template**:
```markdown
### Why [Technology/Approach]?

- **[Benefit 1]**: [Explanation]
- **[Benefit 2]**: [Explanation]
- **[Benefit 3]**: [Explanation]

**Alternative Considered**: [What was considered] (rejected due to [reason])
```

**Example**:
```markdown
### Why Inngest for Workflows?

- **Reliability**: Built-in retries, idempotency, observability
- **Simplicity**: No infrastructure to manage, visual debugging
- **Cost-Effective**: Generous free tier covers MVP needs

**Alternative Considered**: AWS Step Functions (rejected due to complexity
and vendor lock-in vs. Inngest's developer experience)
```

### 12. Identify Risks & Mitigation

For each significant risk:

```markdown
### Risk: [Risk Name]

**Impact**: [High/Medium/Low] - [What happens if this occurs]
**Probability**: [High/Medium/Low] - [Likelihood assessment]
**Mitigation**:
- [Mitigation strategy 1]
- [Mitigation strategy 2]
- [Fallback plan if mitigation fails]
```

**Example**:
```markdown
### Risk: AWS Credits Run Out Early

**Impact**: High - Would need to pay $75/month before revenue covers costs
**Probability**: Medium - Usage could spike unexpectedly
**Mitigation**:
- Set up CloudWatch billing alarms at $40, $60, $70
- Monitor daily costs in AWS Cost Explorer
- Optimize instance sizes if approaching limit
- Fallback: Downgrade to smaller instances or pause non-critical services
```

### 13. Document Open Questions

Group related questions by category (Infrastructure, Features, Technical, etc.):

```markdown
### [Category - Infrastructure/Features/Technical]

- **[Question]**: [Details]
  - Decision: [How you'll resolve this or current thinking]

- **[Question]**: [Details]
  - Decision: [Resolution approach]
```

**Example**:
```markdown
### Infrastructure

- **Should we use CloudFront for App Runner?**: Adds complexity, may not be needed for MVP
  - Decision: Skip for now, add if latency becomes an issue

- **RDS backup retention period?**: AWS default is 7 days
  - Decision: Start with 7 days, extend to 14 days once stable
```

### 14. Define Next Steps

Break into three time horizons:

```markdown
**Immediate** (Start Here):
1. [First action to take]
2. [Second action to take]
3. [Third action to take]

**After [Previous Section]**:
1. [Next action]
2. [Next action]

**Before Milestone Complete**:
1. [Final validation]
2. [Testing]
3. [Documentation]
```

**Example**:
```markdown
**Immediate** (Start Here):
1. Set up AWS account and apply credits
2. Create RDS PostgreSQL instance
3. Deploy basic App Runner service with health check

**After Infrastructure Setup**:
1. Install and configure Discourse
2. Set up Inngest account and first workflow
3. Build email collection landing page

**Before Milestone Complete**:
1. Test all components end-to-end with real data
2. Validate AI responses meet quality targets
3. Document learnings for next milestone
```

### 15. Add Document Metadata

At the top:
```markdown
**Status**: Planning | In Progress | Complete
**Parent Document**: [Milestones Overview]([slug]-milestones-overview.md)
**Architecture Reference**: [Architecture Doc]([slug]-architecture.md)
```

At the bottom:
```markdown
*Document Status*: Design Complete - Ready for Implementation
*Last Updated*: [Month Year]
```

## Output

`[slug]-milestone.md` artifact using `assets/templates/milestone-design.md`

Example: `web-core-milestone.md`

## Key Principles

### Self-Contained Focus
- This document focuses ONLY on this milestone
- Do NOT reference other milestones by number - use descriptive names instead
- Use generic terms: "mobile integration", "future phases", "later milestones"
- Forward references break the self-contained principle

### Design-Focused, Not Timeline-Focused
- Focus on WHAT gets built and WHY, not rigid WHEN
- Phases describe logical groupings, not calendar commitments
- Avoid saying "Week 1-2" unless absolutely necessary
- Use "Phase 1", "After X", "Before launch" instead

### Implementation Perspective
- Think production-grade, not prototypes
- Real databases, not mock data
- Real APIs, not stubs
- Real error handling, not happy-path only

### Visual Communication
- Diagrams show architecture and flows clearly
- ASCII diagrams for flows work well
- Reader should grasp design from visuals + section headers

## Verification Checklist

- [ ] Template read from `assets/templates/milestone-design.md`
- [ ] Artifact follows template structure exactly
- [ ] Executive Summary provides clear context
- [ ] Goal section includes what it proves AND what it doesn't
- [ ] Architecture has all three subsections (Diagram, Stack, Cost)
- [ ] Core Components (3-6) each have all five subsections
- [ ] Implementation Phases expanded from overview with details
- [ ] Success Metrics have measurement details and rationale
- [ ] Testing Strategy defines coverage approach and quality gates
- [ ] Design Decisions explain why this approach
- [ ] Risks identified with mitigation strategies
- [ ] Open Questions grouped by category
- [ ] Next Steps have three time horizons
- [ ] NO forward references to other milestones (use descriptive names, not numbered references)
- [ ] Related Documents section links back to overview and architecture

## Common Pitfalls

- **Forward references**: Don't use numbered milestone references - use descriptive names like "mobile integration", "later phases"
- **Not detailed enough**: Core Components should have substantial technical detail
- **Missing rationale**: Always explain WHY decisions were made
- **Timeline focus**: Avoid rigid week/month commitments - focus on phases and deliverables
- **Vague success criteria**: "Works well" → "Responds in <3 seconds with >80% satisfaction"
- **Missing integration points**: Show how each component connects to others

## Example Workflow

1. Open `[slug]-milestones-overview.md`
2. Find the milestone section to detail
3. Use `assets/templates/milestone-design.md` template → save as `web-core-milestone.md`
4. Work through sections 1-15 above, expanding each area
5. Review architecture doc for technical details to include
6. Add implementation perspective (how things connect, error handling, configuration)
7. Remove any forward references to other milestones
8. Verify checklist
9. Update status and last updated date

## Next Stage

After completing the detailed milestone design doc, proceed to:
→ Stage 5: PoC Design (break milestone into atomic proof-of-concepts)
