---
name: market-research
description: "Thorough market validation for product ideas. Use when you have a product concept (north star, architecture, PRD, or pitch) and need to validate market opportunity, analyze competitors, define positioning, and determine go-to-market strategy. Produces a decision-ready report with Go/Pivot/Kill recommendation. Requires web search capability."
---

# market-research

Thorough market validation to answer: **"Is this worth pursuing, and how do we win?"**

**Version**: 1.1.0

## When to Use

- When you have enough product context to validate (vision, target market, approach)
- Before committing significant resources to a product idea
- When evaluating a new market opportunity
- When pivoting and need to validate new direction

---

## 🔌 Context Sources (Priority Order)

### 1. Mission Control MCP (Primary — Most Current Truth)

If mission-control MCP is available, **use it first**. It contains the most up-to-date project information.

**Auto-detect**: Try `get_project(slug)` — if it works, MCP is available.

**Extract from MCP**:

| MCP Field | Research Context |
|-----------|------------------|
| `objective` | Product vision / problem being solved |
| `business_value` | Value proposition |
| `target_market` | Target customer description |
| `revenue_model` | Pricing strategy and tiers |
| `monthly_cost` | Cost structure for unit economics |
| `projected_mrr` | Revenue targets and assumptions |
| `architecture_summary` | Technical approach |
| `notes` | Additional context |

**If MCP fields are empty**: Ask user to fill critical gaps before proceeding.

### 2. Documents in Context

If MCP not available, check for documents:
- North Star doc (`[slug]-north-star.md`)
- Architecture doc (`[slug]-architecture.md`)
- Milestones Overview doc (`[slug]-milestones-overview.md`)
- PRD, pitch deck, or other product docs

### 3. Ask User

If neither MCP nor docs available, ask user to provide:
- Product vision (what problem, for whom, how solved)
- Technical approach (tech stack, architecture)
- Target market (who is the customer)
- Pricing thoughts (if any)
- Cost structure (if known)

---

## Prerequisites

**Required capability**: Web search enabled

**Context** (in priority order):
1. Mission Control MCP project data (preferred)
2. Product docs in context
3. User-provided information

---

## Core Questions Answered

1. **Market Validation** — Is this a real problem worth solving?
2. **Competitive Landscape** — Who else is solving this? What are the gaps?
3. **Positioning & Edge** — How do we differentiate? Can we defend it?
4. **Target Customer** — Who are the first 200 users? Where are they?
5. **Go-to-Market** — How do we reach them?
6. **Pricing & Economics** — What can we charge? Does it work financially?
7. **Recommendation** — Go / Pivot / Kill?

---

## ⛔ CRITICAL: RESEARCH RULES

### Web Search Required

This skill requires active web research. Do NOT rely solely on training knowledge for:
- Market size data
- Competitor information
- Pricing data
- Current trends

**Search thoroughly** — expect 20-30+ searches for comprehensive analysis.

### Evidence-Based

Every claim needs backing:
- Market size → cite source
- Competitor info → cite source
- Trends → cite source
- If data unavailable → explicitly state "not found" rather than guess

### Decision-Ready Output

The output must enable a clear Go/Pivot/Kill decision. Avoid:
- Wishy-washy conclusions
- "It depends" without specifics
- Missing recommendation

---

## 🎯 Philosophy: First 200 Users

Align with the 200-users-first mindset:
- Focus on **reachable** market (SOM), not just total market (TAM)
- Identify **specific** channels to reach first 200 paying users
- Validate pricing that works for **early adopters**, not mass market
- Assess if we can **win a niche** before expanding

---

## Research Process

**Phase 1: Context Extraction**
1. Check for Mission Control MCP → call `get_project(slug)`
2. If MCP available → extract all fields, note empty ones
3. If MCP not available → check for docs in context
4. If no docs → ask user for required information
5. Identify gaps → ask user before proceeding with research

**Phase 2: Market Landscape**
- Search for market size, trends, growth data
- Identify market category and adjacent spaces

**Phase 3: Competitive Deep Dive**
- Find direct and indirect competitors
- Analyze top 3-5: pricing, features, positioning, weaknesses
- Identify market gaps

**Phase 4: Positioning & Differentiation**
- Define unique angle based on findings
- Assess defensibility
- Craft positioning statement

**Phase 5: Customer & Channel Research**
- Identify where target users congregate
- Research how competitors acquire customers
- Prioritize channels for first 200 users

**Phase 6: Pricing & Economics**
- Research competitive pricing
- Validate against cost structure (from MCP `monthly_cost` or docs)
- Assess unit economics viability

**Phase 7: Synthesis & Recommendation**
- Compile findings
- Assess risks
- Make Go/Pivot/Kill recommendation

→ See `references/market-research-guide.md` for detailed process and search strategies

---

## Output

**Template**: `assets/templates/market-research.md`
**Output**: `[slug]-market-research.md` artifact

### Key Sections

| Section | Purpose |
|---------|---------|
| Executive Summary | Go/Pivot/Kill recommendation with confidence level |
| Market Landscape | TAM/SAM/SOM, trends, timing |
| Competitive Analysis | Landscape map, gap analysis |
| Positioning | Our edge, positioning statement, defensibility |
| Target Customer | ICP for first 200, where they are |
| Go-to-Market | Channel prioritization, path to first 200 |
| Pricing Strategy | Competitive pricing, recommended model, unit economics |
| Risks | Risk table with severity and mitigation |
| Recommendation | Final verdict with reasoning |

---

## Verification Checklist

- [ ] Context extracted (MCP → docs → user, in priority order)
- [ ] All critical fields populated (asked user if gaps)
- [ ] Web search used extensively (20-30+ searches)
- [ ] Market size estimated with cited sources
- [ ] Top 3-5 competitors analyzed in depth
- [ ] Positioning statement defined
- [ ] Clear competitive edge articulated
- [ ] Target customer profile specific (not generic)
- [ ] GTM strategy with prioritized channels
- [ ] Pricing recommendation with unit economics check
- [ ] Risks identified with severity
- [ ] Clear Go/Pivot/Kill recommendation with reasoning
- [ ] Template structure followed exactly

---

## Reference Guide

| When to Read | Reference File |
|--------------|----------------|
| Starting research or need search strategies | `references/market-research-guide.md` |
