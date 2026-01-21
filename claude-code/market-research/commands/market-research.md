# /market-research

Thorough market validation with Go/Pivot/Kill recommendation.

**Skill**: `~/.claude/skills/market-research/SKILL.md`
**Guide**: `~/.claude/skills/market-research/references/market-research-guide.md`
**Template**: `~/.claude/skills/market-research/assets/templates/market-research.md`

## Usage

```bash
/market-research mc
/market-research hexar
```

## Input

**Argument (required)**: Project slug

## Process

1. Read the skill and guide
2. Extract context (MCP → docs → ask user)
3. Conduct web research (20-30+ searches)
4. Generate report following template
5. Write to `docs/[slug]-market-research.md`

## Output

Creates `docs/[slug]-market-research.md` with:
- Executive Summary (Go/Pivot/Kill recommendation)
- Market Landscape (TAM/SAM/SOM)
- Competitive Analysis
- Positioning & Edge
- Target Customer Profile
- Go-to-Market Strategy
- Pricing & Unit Economics
- Risks
- Final Recommendation

Read the skill. Follow it exactly.
