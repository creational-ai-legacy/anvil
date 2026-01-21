# Market Research Guide

Detailed process, search strategies, and examples for thorough market validation.

## Before You Start: Context Extraction

### Priority 1: Mission Control MCP

**Auto-detect**: Try calling `get_project(slug)`. If it returns data, MCP is available.

**If MCP available**, extract these fields:

```
get_project(slug) returns:
├── objective          → Product vision / problem being solved
├── business_value     → Value proposition
├── target_market      → Target customer description
├── revenue_model      → Pricing strategy and tiers
├── monthly_cost       → Cost structure (e.g., "$15/mo | breakdown...")
├── projected_mrr      → Revenue targets (e.g., "$1,000/mo @ 6mo | 100 users × $10")
├── architecture_summary → Technical approach
└── notes              → Additional context
```

**Example extraction from mission-control project**:

| Field | Value | Research Use |
|-------|-------|--------------|
| `objective` | "PostgreSQL-backed project management MCP server for indie developers" | Defines product category and target |
| `target_market` | "Indie developers who want AI-powered strategic planning through conversation" | ICP starting point |
| `revenue_model` | "SaaS subscription: Free ($0, 5 projects), Pro ($10/mo), Team ($25/mo)" | Pricing validation baseline |
| `monthly_cost` | "$15/mo \| App Runner $10 + RDS $0 + Secrets $0.80" | Unit economics calculation |
| `projected_mrr` | "$1,000/mo target @ 6mo \| 100 Pro users × $10/mo" | Revenue assumptions to validate |

**If MCP fields are empty**, note which ones and ask user before proceeding.

### Priority 2: Documents in Context

If MCP not available, look for documents:
- `[slug]-north-star.md` → Vision, problem, value prop
- `[slug]-architecture.md` → Tech approach, cost structure
- `[slug]-milestones-overview.md` → Strategic approach, what gets built
- PRD, pitch deck, or other product docs

### Priority 3: Ask User

If neither MCP nor docs available:

> "Before I begin market research, I need to understand:
> 1. **Product vision**: What problem are you solving, and for whom?
> 2. **Technical approach**: How are you building it? (tech stack, architecture)
> 3. **Target market**: Who specifically is the customer?
> 4. **Pricing thoughts**: Any ideas on pricing model or price point?
> 5. **Cost structure**: What will it cost to serve each user?
>
> Please provide what you have, and I'll note any gaps."

### Extract Key Context

Regardless of source, compile:
- **Problem statement**: What pain are we solving?
- **Target user**: Who has this problem?
- **Value proposition**: Why would they choose us?
- **Technical approach**: How are we solving it?
- **Cost structure**: What does it cost to serve a user?
- **Pricing hypothesis**: What's the initial pricing model/price point?

---

## Phase 1: Market Landscape Research

### Goal
Understand the market size, growth, and trends.

### Search Strategies

**Market size queries**:
```
[category] market size 2024
[category] market size forecast 2025 2030
[category] industry report
[category] TAM SAM
[problem] solutions market size
```

**Trend queries**:
```
[category] industry trends 2024 2025
[category] market growth rate
[category] future outlook
[problem] emerging solutions
```

**Timing queries**:
```
[category] market maturity
[category] adoption rate
[technology] adoption curve
```

### What to Look For

- **Market size numbers**: TAM, SAM with sources (Gartner, Statista, industry reports)
- **Growth rate**: CAGR, YoY growth
- **Key trends**: Technology shifts, regulatory changes, behavioral changes
- **Market stage**: Emerging, growing, mature, declining

### Calculating SOM (Serviceable Obtainable Market)

SOM = realistic first 1-2 years. Calculate as:
```
SOM = SAM × [reachable %] × [winnable %]

Example:
- SAM: 500,000 potential users
- Reachable (our channels can touch): 10% = 50,000
- Winnable (will choose us): 5% = 2,500 users
- SOM: 2,500 users in first 2 years
```

---

## Phase 2: Competitive Analysis

### Goal
Map the competitive landscape and find gaps.

### Finding Competitors

**Direct competitor queries**:
```
[category] software tools
[category] apps
best [category] tools 2024
[problem] solutions
[competitor name] alternatives
```

**Indirect competitor queries**:
```
how to [solve problem] without [category]
[problem] workarounds
[target user] tools stack
```

**Review/comparison queries**:
```
[competitor] review
[competitor] vs [competitor]
[category] comparison
[competitor] pricing
G2 [category]
Capterra [category]
[competitor] reddit
[competitor] complaints
```

### Competitor Deep Dive Process

For each top competitor (3-5):

1. **Visit their website**
   - Positioning (how they describe themselves)
   - Target customer (who they show in marketing)
   - Pricing page (model and price points)
   - Features page (what they offer)

2. **Search for reviews**
   - G2, Capterra, TrustRadius
   - Reddit discussions
   - Twitter/X mentions
   - App store reviews (if applicable)

3. **Note patterns**
   - What do users love?
   - What do users hate?
   - What's missing?

### Gap Analysis Framework

After analyzing competitors, identify:

| Gap Type | Question | Opportunity |
|----------|----------|-------------|
| **Segment gap** | Who is underserved? | Niche we can own |
| **Feature gap** | What's missing? | Capability we can build |
| **Experience gap** | What's frustrating? | UX we can improve |
| **Price gap** | Who's priced out? | Tier we can offer |
| **Integration gap** | What doesn't connect? | Integration we can build |

---

## Phase 3: Positioning & Differentiation

### Goal
Define how we're different AND better (not just different).

### Positioning Statement Formula

> For **[target user]** who **[has problem/need]**, 
> **[Product]** is a **[category]** that **[key benefit]**. 
> Unlike **[competitors]**, we **[key differentiator]**.

**Example**:
> For **indie game developers** who **struggle to monetize mobile games**, 
> **AdStack** is a **monetization platform** that **maximizes revenue with minimal integration effort**. 
> Unlike **AdMob and Unity Ads**, we **auto-optimize ad placement using gameplay data**.

### Differentiation Sources

Ask: Where does our edge come from?

| Source | Example | Defensibility |
|--------|---------|---------------|
| **Technical** | Better algorithm, unique architecture | Medium - can be copied |
| **Data** | Proprietary dataset, network effects | High - hard to replicate |
| **Focus** | Niche specialization | Medium - until market grows |
| **Experience** | 10x better UX | Low - can be copied |
| **Price** | Significantly cheaper | Low - race to bottom |
| **Integration** | Works with X where others don't | Medium - until others add it |
| **Trust** | Brand, track record | High - takes time to build |

### Defensibility Assessment

For each potential moat:
- **Do we have it today?** (Yes/No/Partially)
- **Can we build it?** (Yes/No/Maybe)
- **How long to replicate?** (Months/Years/Never)

---

## Phase 4: Customer & Channel Research

### Goal
Identify exactly who the first 200 users are and how to reach them.

### Finding Where Customers Are

**Community queries**:
```
[target user] community
[target user] forum
[target user] discord
[target user] slack group
[problem] subreddit
[industry] professionals community
```

**Content queries**:
```
[target user] podcast
[target user] newsletter
[target user] blog
[target user] youtube channel
[target user] influencers
```

**Event queries**:
```
[industry] conference 2024 2025
[target user] meetup
[category] summit
```

### Channel Assessment Framework

For each potential channel:

| Factor | Questions |
|--------|-----------|
| **Reach** | How many target users can we access? |
| **Fit** | Are they in buying mode here? |
| **Cost** | What does it cost (time/money)? |
| **Speed** | How fast can we see results? |
| **Scalability** | Does it scale or tap out? |

### Path to First 200 Strategy

**Seed (1-20)**: Personal network, direct outreach
- Who do we know?
- Who can introduce us?
- Where can we show up personally?

**Validate (21-50)**: Early community engagement
- Which community is most receptive?
- What content resonates?
- What triggers conversion?

**Scale (51-200)**: Repeatable channels
- Which channel has best unit economics?
- How do we systematize it?
- What's the CAC?

---

## Phase 5: Pricing Research

### Goal
Determine optimal pricing model and price point.

### Competitive Pricing Research

**Pricing queries**:
```
[competitor] pricing
[competitor] cost
[category] pricing comparison
how much does [competitor] cost
[category] pricing models
```

**Check**:
- Pricing pages (often hidden or "contact us")
- Review sites mentioning price
- Reddit/forum discussions about cost
- Comparison articles

### Pricing Model Options

| Model | Best For | Pros | Cons |
|-------|----------|------|------|
| **Subscription** | Ongoing value, SaaS | Predictable revenue | Churn risk |
| **Usage-based** | Variable consumption | Scales with value | Unpredictable revenue |
| **Freemium** | Viral/PLG products | Low friction | Conversion challenge |
| **One-time** | Tools, templates | Simple | No recurring revenue |
| **Tiered** | Diverse segments | Captures more value | Complexity |

### Unit Economics Validation

**Calculate**:
```
Revenue per user: $[ARPU]/mo
- Infrastructure cost: $[X]/mo (from Architecture)
- Support cost: $[X]/mo (estimate)
= Gross margin: $[X]/mo ([Y]%)

Lifetime value (LTV): ARPU × Average lifetime (months)
Customer acquisition cost (CAC): Total acquisition spend ÷ customers acquired

LTV:CAC ratio target: 3:1 or higher
```

**Red flags**:
- Gross margin < 50% (hard to scale)
- LTV:CAC < 3:1 (unsustainable)
- Payback period > 12 months (cash flow problem)

---

## Phase 6: Risk Assessment

### Risk Categories

**Market risk**:
- Is the market real?
- Is it big enough?
- Is it growing?

**Competition risk**:
- Can incumbents crush us?
- Is the market winner-take-all?
- How fast can competitors copy us?

**Technical risk**:
- Is our approach proven?
- Are there technical unknowns?
- Can we actually build this?

**Distribution risk**:
- Can we reach customers?
- Is CAC sustainable?
- Do we have unfair distribution advantage?

**Timing risk**:
- Too early (market not ready)?
- Too late (market saturated)?
- External dependencies (regulations, platforms)?

### Risk Severity Framework

| Severity | Definition |
|----------|------------|
| **High** | Could kill the business if it materializes |
| **Medium** | Significant setback, but recoverable |
| **Low** | Minor issue, manageable |

| Likelihood | Definition |
|------------|------------|
| **High** | More likely than not (>50%) |
| **Medium** | Possible (20-50%) |
| **Low** | Unlikely (<20%) |

**Priority**: High/High risks need mitigation plan before GO decision.

---

## Phase 7: Making the Recommendation

### GO Criteria

Recommend **GO** when:
- ✅ Market is real and big enough
- ✅ Clear gap exists that we can fill
- ✅ We have defensible differentiation
- ✅ Path to first 200 users is clear
- ✅ Unit economics work (or clear path to working)
- ✅ No High/High unmitigated risks

### PIVOT Criteria

Recommend **PIVOT** when:
- ⚠️ Core insight is valid BUT
- ❌ Target market too small
- ❌ Competition too strong in current positioning
- ❌ Unit economics don't work at current price
- ❌ Distribution channels not accessible

**Pivot directions**:
- Different target customer (same problem)
- Different problem (same customer)
- Different positioning (same product)
- Different price point (same product)

### KILL Criteria

Recommend **KILL** when:
- ❌ Market is not real or too small
- ❌ No differentiation possible
- ❌ Unit economics fundamentally broken
- ❌ Multiple High/High risks with no mitigation
- ❌ Better opportunities exist for same effort

---

## Common Pitfalls

- **Confirmation bias**: Searching for evidence that supports the idea vs. evidence that challenges it
- **TAM fantasy**: Citing huge TAM without realistic SOM
- **Ignoring indirect competitors**: Status quo and workarounds are competitors
- **Surface-level competitor analysis**: Just listing features vs. understanding positioning
- **Vague differentiation**: "Better UX" without specifics
- **Generic ICP**: "Small businesses" instead of specific persona
- **Ignoring unit economics**: Assuming pricing will "work out"
- **Optimistic risk assessment**: Downplaying real threats

---

## Search Query Cheatsheet

### Market Size
```
[category] market size 2024 2025
[category] industry report
[category] TAM
[category] growth forecast
```

### Competitors
```
[category] tools comparison 2024
best [category] software
[competitor] alternatives
[competitor] vs
[competitor] review reddit
```

### Pricing
```
[competitor] pricing
[category] pricing models
how much does [competitor] cost
```

### Customers
```
[target user] community forum
[target user] subreddit
[problem] discussion
where do [target users] hang out
```

### Trends
```
[category] trends 2024 2025
[category] future
[technology] adoption
[industry] outlook
```

---

## Verification Checklist

- [ ] Context source identified (MCP → docs → user)
- [ ] If MCP: `get_project(slug)` called and fields extracted
- [ ] If MCP fields empty: user asked to fill gaps
- [ ] All key context compiled (problem, target, value prop, tech, costs, pricing)
- [ ] Web search used extensively (20-30+ searches)
- [ ] Market size estimated with cited sources
- [ ] Top 3-5 competitors analyzed in depth
- [ ] Positioning statement defined
- [ ] Clear competitive edge articulated
- [ ] Target customer profile specific (not generic)
- [ ] GTM strategy with prioritized channels
- [ ] Pricing recommendation with unit economics check
- [ ] Risks identified with severity and likelihood
- [ ] Clear Go/Pivot/Kill recommendation with reasoning
- [ ] Template structure followed exactly
- [ ] Sources cited
