# dev-cycle - Design Document

## Overview

`/dev-cycle` is a Claude Code skill that guides developers through a complete feature development workflow from high-level design to production-grade implementation. It enforces a structured 3-stage process:

1. **Design** - Problem analysis and solution design (no code)
2. **Planning** - Step-by-step breakdown with code snippets
3. **Execution** - Actual implementation with testing and verification

The skill is designed to reduce confusion, enforce best practices, and maintain production-grade code quality throughout the development process.

## Architecture

### System Diagram

```
User Request
     ↓
┌────────────────────────────────────────┐
│         /dev-cycle Skill               │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  Stage 1: Design                 │ │
│  │  - Problem Analysis (parallel)   │ │
│  │  - Proposed Steps (sequential)   │ │
│  │  - NO CODE allowed               │ │
│  │  Output: design.md               │ │
│  └────────────┬─────────────────────┘ │
│               ↓                        │
│  ┌──────────────────────────────────┐ │
│  │  Stage 2: Planning               │ │
│  │  - List prerequisites            │ │
│  │  - Break into steps              │ │
│  │  - Define verification           │ │
│  │  Output: plan.md                 │ │
│  │          results.md              │ │
│  └────────────┬─────────────────────┘ │
│               ↓                        │
│  ┌──────────────────────────────────┐ │
│  │  Stage 3: Execution              │ │
│  │  - Implement step-by-step        │ │
│  │  - Write tests (pytest)          │ │
│  │  - Verify each step              │ │
│  │  - Document lessons learned      │ │
│  │  Output: implementation files    │ │
│  │          test files              │ │
│  │          updated results.md      │ │
│  └──────────────────────────────────┘ │
└────────────────────────────────────────┘
```

### Components

#### Stage 1: Design
- **Purpose**: Analyze problems and propose solution steps (no code)
- **Inputs**:
  - Feature/issue/bug description from user
  - Current architecture (from codebase)
  - Existing docs ([slug]-poc-design.md, [slug]-architecture.md)
- **Outputs**:
  - `docs/[name]-design.md` - Design document with Problem Analysis + Proposed Steps
  - Updated `[slug]-poc-design.md` - With new PoCs added (if applicable)
- **Dependencies**: Templates (design.md), References (1-design-guide.md)
- **Code Allowed**: NO - Pure design and analysis
- **Command**: `/dev-design <notes>`

#### Stage 2: Planning
- **Purpose**: Break down work into actionable steps
- **Inputs**:
  - Single PoC from poc-design.md OR feature/bug to implement
  - Design document (if from Stage 1)
- **Outputs**:
  - `docs/[name]-plan.md` - Evergreen implementation guide (e.g., poc6-plan.md)
  - `docs/[name]-results.md` - Progress tracking document
- **Dependencies**: Templates (plan.md, results.md), References (2-planning-guide.md)
- **Code Allowed**: YES - Code snippets, configs, examples
- **Command**: `/dev-plan <notes>`

#### Stage 3: Execution
- **Purpose**: Implement the plan one step at a time
- **Inputs**:
  - `docs/[name]-plan.md` - The plan
  - `docs/[name]-results.md` - Progress tracker
  - Current step to work on
- **Outputs**:
  - Implementation code files (in appropriate modules)
  - Test files (`tests/test_[name]_*.py`)
  - Updated `docs/[name]-results.md`
  - Updated `PROJECT_STATE.md` (when complete)
- **Dependencies**: pytest, plan, References (3-execution-guide.md)
- **Code Allowed**: YES - Full implementation
- **Command**: `/dev-execute <notes>`

## Data Flow

### Flow 1: New Feature Request

```
1. User: "I need to add [feature]"

2. Stage 1 (Design):
   - Problem Analysis (each problem independently)
   - Proposed Steps (synthesized, sequential)
   - Breaks into self-contained PoCs
   - Updates [slug]-poc-design.md
   → Outputs: design.md, updated [slug]-poc-design.md

3. Stage 2 (Planning):
   - Takes NEXT PoC from plan
   - Breaks into ~30min steps
   - Defines verification for each step
   - Creates tracking document
   → Outputs: pocN-plan.md, pocN-results.md

4. Stage 3 (Execution):
   - For each step:
     a. Implement code
     b. Write tests
     c. Run pytest verification
     d. Update results.md
   → Outputs: implementation files, test files, results.md

5. Loop back to Stage 2 for next PoC (if more PoCs exist)
```

### Flow 2: Bug Fix Request

```
1. User: "Fix bug in [component]"

2. Stage 1 (Design):
   - Problem Analysis of bug and root cause
   - Proposed Steps to fix
   - Creates single PoC for fix
   → Outputs: design.md

3. → Continues to Stage 2 & 3 (same as Flow 1)
```

### Flow 3: Resume Existing Work

```
1. User: "Continue working on PoC 3"

2. Skill detects existing pocN-plan.md and pocN-results.md

3. → Jumps directly to Stage 3 (Execution)
   - Reads current step from results.md
   - Continues implementation
```

## Technology Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| Skill Format | Markdown (SKILL.md) | Claude Code native format |
| Templates | Markdown templates | Easy to read/edit, version control friendly |
| Testing | pytest | Industry standard, explicit in Stage 5 |
| Documentation | Markdown | Portable, readable, git-friendly |
| Code Quality | OOP + Pydantic + Type Hints | Production-grade, maintainable code |

## Integration Points

### Parent Skill: dev-design
- **Type**: Nested skill / Command
- **Purpose**: dev-cycle is extracted from dev-design to be self-contained
- **Contract**:
  - Can be used standalone OR as part of dev-design workflow
  - Uses same template patterns
  - Compatible with PROJECT_STATE.md tracking

### Claude Code CLI
- **Type**: Skill loaded into context
- **Purpose**: Skill guides Claude's behavior for feature development requests
- **Contract**:
  - Skill is loaded when user is in project with dev-cycle
  - Detects current state from filesystem (what docs exist?)
  - User makes natural requests: "create design", "implement PoC 3", "continue execution"
  - Skill instructions guide Claude to follow 3-stage process

### Project Documentation
- **Type**: File system integration
- **Purpose**: Reads/writes project docs
- **Contract**:
  - Reads: `[slug]-poc-design.md`, `[slug]-architecture.md`, `PROJECT_STATE.md`
  - Writes: `docs/*-design.md`, `docs/*-plan.md`, `docs/*-results.md`
  - Updates: `[slug]-poc-design.md`, `PROJECT_STATE.md`

## Key Design Decisions

### Decision 1: Single Skill vs Three Commands
- **Context**: Each stage (design, plan, execution) could be a separate command
- **Options Considered**:
  - **Option A**: Three separate commands (`/design`, `/plan`, `/execute`)
  - **Option B**: Single skill with three stages (`/dev-cycle`)
- **Decision**: Option B - Single skill
- **Rationale**:
  - Stages are sequential and dependent (design → plan → execute)
  - Reduces confusion about "which command do I use next?"
  - Single source of truth for all dev-cycle logic
  - Better state management (skill knows where you are)
  - Still flexible (can jump to specific stage if needed)

### Decision 2: Two Documents per Work Item (plan.md + results.md)
- **Context**: Stage 2 creates planning docs, Stage 3 updates them
- **Options Considered**:
  - **Option A**: Single doc with status indicators mixed in
  - **Option B**: Two docs - clean plan guide + live progress tracker
- **Decision**: Option B - Two separate documents
- **Rationale**:
  - Implementation doc stays evergreen (pure "how to do it")
  - Results doc captures execution-specific details (issues, timing, lessons)
  - Cleaner documentation structure
  - Implementation doc can be reused/referenced without execution noise

### Decision 3: Self-Contained PoC Requirement
- **Context**: How to handle breaking changes during PoC implementation
- **Options Considered**:
  - **Option A**: Replace existing code (fast but breaks things)
  - **Option B**: "Add alongside, don't replace" strategy
- **Decision**: Option B - Add alongside
- **Rationale**:
  - Each PoC must work independently (can pause at any PoC boundary)
  - System remains functional between PoCs
  - Prevents cascading failures
  - Migration happens in dedicated future PoC, not mixed in

### Decision 4: Code Quality Standards (OOP + Pydantic)
- **Context**: What code quality standards to enforce in Stage 2 & 3
- **Options Considered**:
  - **Option A**: No specific guidance (developer choice)
  - **Option B**: Enforce OOP, Pydantic models, type hints
- **Decision**: Option B - Explicit standards
- **Rationale**:
  - Production-grade from the start (no "we'll clean it up later")
  - Pydantic provides validation, serialization, docs built-in
  - Type hints improve IDE support and catch bugs early
  - OOP enables better testing and composition

### Decision 5: Every Step Requires pytest Verification
- **Context**: When should tests be written during execution?
- **Options Considered**:
  - **Option A**: Write tests at end of PoC
  - **Option B**: Every step requires passing tests
- **Decision**: Option B - Per-step testing
- **Rationale**:
  - Catches issues early (easier to debug)
  - Ensures step is truly complete before moving on
  - Prevents technical debt accumulation
  - Steps are small (~30min), so testing overhead is minimal

### Decision 6: Stage 1 Updates poc-design.md (When Applicable)
- **Context**: Where should new PoCs from design be tracked?
- **Options Considered**:
  - **Option A**: Keep in design.md only
  - **Option B**: Update central poc-design.md
- **Decision**: Option B - Update poc-design.md when work involves PoCs
- **Rationale**:
  - Single source of truth for all PoCs
  - Easier to track dependencies across features
  - Prevents PoC numbering conflicts
  - Central plan stays up-to-date
  - Note: For simple bugs/features, poc-design.md update may not be needed

### Decision 7: Commands on Top of Skill
- **Context**: Should we provide command shortcuts for each stage?
- **Options Considered**:
  - **Option A**: Skill only (natural language requests)
  - **Option B**: Add optional commands (/dev-design, /dev-plan, /dev-execute)
- **Decision**: Option B - Provide both skill and commands
- **Rationale**:
  - Commands provide explicit stage invocation when desired
  - Skill still works for natural language requests
  - Commands can pass notes for context
  - Flexibility: users choose their preferred workflow

## Constraints & Assumptions

### Constraints
- **One PoC at a time**: Stage 2 only plans one PoC (learnings change future plans)
- **One step at a time**: Stage 3 executes sequentially (no parallel steps)
- **pytest required**: Stage 3 requires pytest for verification
- **Self-contained PoCs**: Each PoC must work independently

### Assumptions
- User has basic familiarity with git, testing, project structure
- Project uses pytest (or willing to adopt it)
- User wants production-grade code (not prototypes)
- Documentation is tracked in `docs/` folder
- Tests are tracked in `tests/` folder

## User Experience Flow

### Scenario 1: Starting New Feature

```
User: "I need to add database abstraction layer"

Claude: [Following dev-cycle skill instructions]
  "I'll create a design document for this feature:

   Stage 1: Design
   - Problem Analysis (each problem independently)...
   - Proposed Steps (synthesized sequence)...
   - Breaking into PoCs...

   Created: docs/database-abstraction-design.md
   Updated: [slug]-poc-design.md (added PoC 6, 7, 8)"

User: [Reviews docs, runs /verify-doc, fixes issues]

User: "Create the plan for PoC 6"

Claude: [Following dev-cycle skill instructions]
  "Stage 2: Planning (PoC 6)

   Creating step-by-step plan...

   Created: docs/poc6-plan.md
   Created: docs/poc6-results.md"

User: [Reviews plan, verifies it's sound]

User: "Let's execute PoC 6"

Claude: [Following dev-cycle skill instructions]
  "Stage 3: Execution (PoC 6, Step 1)

   Implementing: Create database protocol interface...
   [writes code]

   Writing tests...
   [writes tests]

   Running verification: uv run pytest tests/test_poc6_protocol.py -v
   ✅ All tests passed

   Updated: docs/poc6-results.md

   Step 1 complete."
```

### Scenario 2: Resuming Work

```
User: "Continue working on PoC 6"

Claude: [Following dev-cycle skill instructions]
  "Detected existing work in progress:

   Current PoC: PoC 6 - Database Abstraction Layer
   Current Stage: Execution
   Current Step: Step 3 of 5

   Resuming Step 3: Implement PostgreSQL adapter..."
```

## Future Considerations

### Potential Enhancements

1. **Parallel Step Execution**: If steps have no dependencies, allow parallel work
2. **Multi-language Support**: Currently Python-centric (pytest, Pydantic), could generalize
3. **CI/CD Integration**: Auto-run tests on commit, update results.md
4. **Progress Dashboard**: Visual representation of PoC progress
5. **Stage Skip Detection**: "You're jumping ahead, did you mean to skip Stage 1?"
6. **Template Customization**: Allow projects to override default templates
7. **Rollback Support**: "Undo Step 3" functionality
8. **Stage Arguments**: `/dev-cycle --stage execution --step 2` for precise control

### Known Limitations

- **No automatic state detection** (v1): User must tell Claude where they are
- **No branching/merging**: Assumes linear PoC progression
- **Python-specific examples**: OOP/Pydantic guidance tailored to Python
- **File-based state**: No database tracking (relies on filesystem)

## Success Metrics

The dev-cycle skill is successful if:

1. **Reduces confusion**: Developer always knows what stage they're in
2. **Enforces quality**: Code is production-grade from start (OOP, types, tests)
3. **Maintains self-containment**: Every PoC works independently
4. **Clear documentation**: Implementation guides are evergreen and reusable
5. **Fast iteration**: ~30min steps enable quick progress and verification
6. **Easy to resume**: Can pick up where you left off without context loss

## File Structure

```
dev-cycle/
├── SKILL.md                           # Main skill definition
├── README.md                          # Public docs
├── docs/
│   └── design.md                      # This document
├── assets/templates/
│   ├── design.md                      # Stage 1 output template
│   ├── plan.md                        # Stage 2 output template
│   └── results.md                     # Stage 3 tracking template
├── references/                        # Detailed guides
│   ├── 1-design-guide.md              # Stage 1 guidance
│   ├── 2-planning-guide.md            # Stage 2 guidance
│   └── 3-execution-guide.md           # Stage 3 guidance
└── commands/                          # Optional commands
    ├── dev-design.md                  # /dev-design command
    ├── dev-plan.md                    # /dev-plan command
    └── dev-execute.md                 # /dev-execute command
```

## Template and Command Naming

### Templates (in assets/templates/)
- `design.md` - Stage 1 output (Problem Analysis + Proposed Steps, NO CODE)
- `plan.md` - Stage 2 output
- `results.md` - Stage 3 tracking

### References (in references/)
- `1-design-guide.md` - Stage 1 detailed guidance
- `2-planning-guide.md` - Stage 2 detailed guidance
- `3-execution-guide.md` - Stage 3 detailed guidance

### Commands (in commands/)
- `/dev-design <notes>` - Create design document (Problem Analysis + Proposed Steps)
- `/dev-plan <notes>` - Create plan
- `/dev-execute <notes>` - Execute the plan step-by-step

### User Output Files
- `docs/[name]-design.md` - e.g., database-abstraction-design.md, fix-auth-bug-design.md, poc6-design.md
- `docs/[name]-plan.md` - e.g., poc6-plan.md
- `docs/[name]-results.md` - e.g., poc6-results.md

## Next Steps

1. Create SKILL.md with stage definitions
2. Create templates (design.md, plan.md, results.md)
3. Create references (1-design-guide.md, 2-planning-guide.md, 3-execution-guide.md)
4. Create commands (dev-design.md, dev-plan.md, dev-execute.md)
5. Test with real feature implementation
6. Deploy to ~/.claude/skills/dev-cycle/
