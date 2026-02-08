# Lessons Guide

Extract and consolidate lessons learned from results docs.

**Template**: `assets/templates/lessons-learned.md`

## Input

Path(s) to results doc(s): `docs/[slug]-results.md`

## Pre-Check

**First, check if `## Lessons Learned` section already exists.**

### If NOT exists → Run Process

### If EXISTS → Validate Against Template

Compare existing section against template:

1. **Structure**: Flat list only (NO subcategories like `### Topic`)
2. **Format**: Each bullet matches `- **[Key concept]** - [Explanation].`
   - Uses ` - ` dash separator (NOT `:` colon)
   - Key concept is 2-5 words, bolded
3. **Content**: Meets Keep/Cut criteria below

**Structure/Format violations → Redo**:
- Has subcategories (`###`)
- Uses colon separator (`**Key**:` instead of `**Key** -`)
- Missing bold on key concept

**Content violations → Remove only**:
- Contains lessons that should be cut → remove those bullets, keep the rest

**If valid → Done**: Report "Lessons Learned section validated - no changes needed."

---

## Process

### Step 1: Extract Lessons

Read results doc, locate all per-step "Lessons Learned" subsections, extract bullet points.

### Step 2: Consolidate

- Identify patterns across steps
- Group by theme, remove redundancy
- Keep critical insights, drop trivial observations

### Step 3: Format

Format each bullet per template (`assets/templates/lessons-learned.md`).

### Step 4: Add Section

Add `## Lessons Learned` as the **last section** of the document.

---

## The Cutting Principle

**Ask: "Would someone reading this in 6 months find it valuable?"**

If the answer is no, cut it.

**Keep only lessons that:**
- You couldn't have known without doing this specific work
- Would make someone say "I wish I knew that before I started"
- Explain a non-obvious behavior or gotcha that caused real confusion

**Cut lessons that:**
- Could be found by reading documentation or a quick search
- Any experienced developer in that stack would already know
- Are general best practices not specific to this project
- Describe how a tool/library works as designed

---

## Output

- **No duplicates** - Consolidate lessons appearing in multiple steps
- **Standalone** - Each bullet useful without reading the full doc

## After Completion

Report:
- Document processed
- Number of per-step lessons extracted
- Number of consolidated lessons in final section
- Themes/categories identified

---

## Quick Reference

1. **Check first** - If `## Lessons Learned` exists, validate format; if not, create it
2. **Cut aggressively** - "Would someone in 6 months find this valuable?" If no, cut it
3. **Format exactly** - `- **[Key concept]** - [Explanation].` (dash separator, not colon)
4. **Place last** - Add as final section of the document
