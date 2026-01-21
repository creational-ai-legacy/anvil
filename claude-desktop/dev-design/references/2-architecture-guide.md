# Stage 2: Architecture

## Goal
Create technical architecture and integration plan.

## Code Allowed
NO

## Timeline Estimates
NOT NEEDED - Focus on WHAT and WHY, not WHEN. Avoid timeline estimates (e.g., "Week 1-2", "2 weeks", "3 months"). Design phases don't need schedules.

## Input
- North Star doc from Stage 1 (`[slug]-north-star.md`)

## Process
1. Define system architecture
2. Identify technology stack
3. Map data flows
4. Design component interactions
5. Identify integration points

## Output
`[slug]-architecture.md` artifact using `assets/templates/architecture.md`

Example: `mc-architecture.md`

## Verification Checklist
- [ ] Template read from `assets/templates/architecture.md`
- [ ] Artifact follows template structure exactly
- [ ] Architecture diagram complete
- [ ] Tech stack justified
- [ ] Data flows documented
- [ ] Data model documented (entities, relationships)
- [ ] Security considerations addressed
- [ ] Observability approach defined
- [ ] Integration points identified
- [ ] No code written (only diagrams and descriptions)

## What IS Allowed
- High-level architecture diagrams (ASCII or descriptions)
- Data flow descriptions
- Technology stack decisions with rationale
- API contract descriptions (endpoints, payloads)
- Component interaction descriptions

## What is NOT Allowed
- Actual implementation code
- Function definitions
- Class implementations
- Code snippets that could be copy-pasted

## Key Deliverables
1. **System Architecture**: How components relate
2. **Technology Stack**: What tools/frameworks and why
3. **Data Flow**: How information moves through the system
4. **Integration Points**: External systems and how we connect

## Common Pitfalls
- Over-engineering at design stage
- Choosing tech based on hype vs. fit
- Ignoring operational concerns (deployment, monitoring)
- Not considering failure modes

## Next Stage
→ Stage 3: Milestones Overview
