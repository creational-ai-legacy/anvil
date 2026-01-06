# Stage 5: PoC Design

## Goal
Define what needs to be proven and in what order — with PRODUCTION-GRADE thin slices.

## Code Allowed
NO

## Timeline Estimates
NOT NEEDED - Focus on WHAT and WHY, not WHEN. Avoid timeline estimates (e.g., "Week 1-2", "2 weeks", "3 months"). Design phases don't need schedules.

## Input
- Milestone design from `docs/milestone-[number]-[slug].md` (Stage 4 output)
- Milestones overview from `docs/milestones-overview.md` (Stage 3 output)
- Architecture doc (`docs/[name]-architecture.md`) (Stage 2 output)

**Note**: Run this stage once per milestone, starting with Milestone 1 (Core).

## Process
1. Refine architecture with implementation perspective
2. Identify atomic things to prove (PoCs)
3. Map dependencies between PoCs
4. Create PoC diagram
5. Define success criteria for each PoC

## Output
`docs/[milestone-name]-poc-design.md` using `assets/templates/poc-design.md`

Example: `docs/core-poc-design.md`, `docs/cloud-deployment-poc-design.md`

## Verification Checklist
- [ ] Each PoC proves one specific thing
- [ ] Dependencies mapped (which PoCs unlock others)
- [ ] Success criteria measurable
- [ ] Order of execution clear

## What Makes a Good PoC

### A PoC Should:
- Prove ONE specific technical or business assumption
- Be small enough to complete in 1-3 sessions
- Have clear, measurable success criteria
- Build toward the final MVP

### A PoC Should NOT:
- Try to prove multiple things at once
- Be so large it feels like a project itself
- Have vague "it works" success criteria
- Be disconnected from the end goal

## PoC Requirements

Each PoC must be:
- **Atomic**: Proves one specific thing (one capability/assumption, NOT one task - may include multiple related tasks)
- **Measurable**: Clear success criteria
- **Self-contained**: Works independently; doesn't break existing functionality and existing tests

**Why self-contained matters:**
- Each PoC is complete within its scope (doesn't need non-dependent PoCs to work)
- System remains functional between PoCs (no breaking changes to existing functionality/tests)
- Prevents cascading failures
- Clearly shows what it proves and what capabilities it opens up for dependent PoCs
- Safe to pause work at any PoC boundary

**⚠️ CRITICAL: Minimize the Number of PoCs**

**Golden Rule**: One feature = One PoC (unless it spans the entire stack)

**When to use ONE PoC:**
- Feature is contained in one layer (frontend OR backend OR database)
- Related tasks that test the same capability together
- CRUD operations for a single entity (Create + Read + Update + Delete users)
- All tasks validate the same technical assumption

**When to split into multiple PoCs:**
- Feature spans entire stack (database + API + frontend) and each layer needs independent testing
- Clear dependency boundaries (PoC B literally cannot start until PoC A is proven)
- Different technical risks that should be validated separately
- **BUT STILL MINIMIZE** - If you can test 2 layers together, do it

**GOOD - Minimized PoCs:**
```
✅ PoC 3: User Management (One PoC)
   - Database schema for users
   - CRUD API endpoints
   - Authentication logic
   - Tests for all operations
   - Proves: "We can manage users end-to-end"
```

**BAD - Too many micro-PoCs:**
```
❌ PoC 3: User Database Schema
❌ PoC 4: Create User API
❌ PoC 5: Read User API
❌ PoC 6: Update User API
❌ PoC 7: Delete User API
❌ PoC 8: User Authentication
```

**When forced to split (e.g., full-stack feature):**
```
✅ PoC 3: User Management Backend
   - Database + API + Auth (grouped)
   - Proves: "Backend handles users correctly"

✅ PoC 4: User Management Frontend
   - UI components + forms + state
   - Proves: "Frontend integrates with user API"
```

**Remember**: Every additional PoC adds overhead. Group related work aggressively.

## PoC Dependency Mapping

Create a diagram showing:
- Which PoCs can run in parallel (no dependencies)
- Which PoCs depend on others
- The critical path to MVP

**Format**: Use boxes for each PoC with clear names. No status indicators (this is a plan, not status tracking).

Example:
```
┌──────────────────────┐              ┌──────────────────────┐
│  PoC 1: Database     │              │  PoC 2: API Server   │
│  Schema              │              │  Basic               │
└──────────┬───────────┘              └──────────┬───────────┘
           │                                     │
           └─────────────────┬───────────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  PoC 3: CRUD         │
                  │  Operations          │
                  └──────────┬───────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
      ┌──────────────────────┐   ┌──────────────────────┐
      │  PoC 4: Analytics    │   │  PoC 5: Reports      │
      └──────────┬───────────┘   └──────────┬───────────┘
                 │                           │
                 └───────────┬───────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │  PoC 6: E2E          │
                  │  Integration         │
                  └──────────────────────┘
```

**Key Points**:
- Each PoC gets a box with its name and brief description
- Use vertical flow (top to bottom) for main dependency path
- Show parallel PoCs side by side at the same level
- Use arrows (│ ▼ ─ └ ┌) to show dependencies
- Keep it clean - NO status indicators (✅ ⬜) in the plan diagram


## Production-Grade Reminder

Even at planning stage, think production:
- Real databases, not mock data
- Real APIs, not stubs
- Real error handling, not happy-path only
- Patterns that scale

## Common Pitfalls
- Planning too many PoCs
- PoCs that are too large
- Missing critical dependencies
- Vague success criteria

## Next Stage
→ PoC Implementation Planning (ONE PoC at a time) via dev-cycle
