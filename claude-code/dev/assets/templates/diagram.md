# Diagram Template

```
┌─────────────────────┐
│     [Task ID]       │
│    [SHORT NAME]     │
│   [Status Emoji]    │
│                     │
│ [Section]           │
│   • [item]          │
│   • [item]          │
│                     │
│ [Section]           │
│   • [item]          │
└─────────────────────┘
```

## Placeholders

| Placeholder | Example |
|-------------|---------|
| `[Task ID]` | PoC 2, Feature |
| `[SHORT NAME]` | EXTRACTORS (1 word, CAPS) |
| `[Status Emoji]` | ✅ Complete, 🔄 In Progress |
| `[Section]` | Data Shapes, MCP Tools, Schema Design |
| `[item]` | Metadata, 12x faster, 14K tokens |

## Content Focus

**Include:**
- Features/capabilities added
- Metrics/achievements
- What was proven/delivered

**Exclude (NEVER include):**
- Files/directories (implementation details)
- Test counts, test results, tests passed

## Box Characters

```
┌ ─ ┐
│   │
└ ─ ┘
```

## Rules

- Tight margins (1 space padding)
- Group items under section headers
- Blank line between sections
- No trailing whitespace

---

## Examples

```
┌─────────────────────┐
│       PoC 0         │
│    EXPLORATION      │
│    ✅ Complete      │
│                     │
│ Data Shapes         │
│   • max 1108 segs   │
│   • 14K tokens      │
│                     │
│ Schema Design       │
│   • JSONB ✓         │
│   • 3 tables        │
└─────────────────────┘
```

```
┌─────────────────────┐
│       PoC 2         │
│     EXTRACTORS      │
│    ✅ Complete      │
│                     │
│ Capabilities        │
│   • Metadata        │
│   • Comments        │
│                     │
│ MCP Tools           │
│   • get_transcript  │
│   • get_metadata    │
│   • get_comments    │
└─────────────────────┘
```

```
┌─────────────────────┐
│       PoC 3         │
│       CACHE         │
│    ✅ Complete      │
│                     │
│ Performance         │
│   • TTL logic       │
│   • 12x faster      │
└─────────────────────┘
```
