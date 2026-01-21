---
name: agent-market-research
description: "Run market research as a background agent"
---

# Agent: Market Research

Use the **market-research-agent** subagent to conduct market validation research.

## Input

Provide:
1. Project slug or product context
2. Any specific focus areas or notes

## What the Agent Does

1. Extracts context (MCP → docs → asks user)
2. Conducts 20-30+ web searches
3. Analyzes market, competitors, positioning
4. Produces Go/Pivot/Kill recommendation
5. Creates `docs/[slug]-market-research.md`

## Example

```
/agent-market-research mission-control

Focus on: indie developer market, MCP server ecosystem
```
