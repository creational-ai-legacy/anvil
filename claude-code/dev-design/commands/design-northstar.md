# /design-northstar

Refine an idea into a clear, feasible North Star vision.

## What This Does

Stage 1 of dev-design: Transform rough ideas into structured vision documents.

## Resources

**Read these for guidance**:
- `~/.claude/skills/dev-design/SKILL.md` - See "Stage 1: North Star" section
- `~/.claude/skills/dev-design/references/1-north-star-guide.md` - Detailed process
- `~/.claude/skills/dev-design/assets/templates/north-star.md` - Output template

## Input

**User notes (required for create mode, optional for update):**
```
{{notes}}
```

**Mode Detection:**
- If `docs/[slug]-north-star.md` exists → Update mode (refine existing document based on user notes)
- Otherwise → Create mode (new document from user's idea/notes)

## Key Requirements

⛔ **NO CODE** - This is vision only (concepts, not implementation)

## Process

Follow the guidance in `1-north-star-guide.md`:
1. Understand the core problem being solved
2. Define how it would work (high-level)
3. Identify key components and their relationships
4. Surface assumptions and unknowns

## Output

Create `docs/[slug]-north-star.md` using the template (e.g., `docs/mc-north-star.md`).

## After Completion

User will review the North Star doc, then proceed to Stage 2: Architecture.
