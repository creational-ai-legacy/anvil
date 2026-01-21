# [Name] Architecture

## Overview
[Brief description of what this system does]

## Architecture

### System Diagram

    [ASCII diagram or description of components]

### Components

#### [Component 1]
- **Purpose**: [What it does]
- **Inputs**: [What it receives]
- **Outputs**: [What it produces]
- **Dependencies**: [What it needs]

#### [Component 2]
...

## Data Model

### Core Entities
| Entity | Purpose | Key Fields |
|--------|---------|------------|
| [Entity 1] | [What it represents] | [Important fields] |
| [Entity 2] | [What it represents] | [Important fields] |

### Relationships
[Brief description of how entities relate - e.g., "User has many Orders"]

**Note**: Keep it simple for first 200 users. Optimize schema later if needed.

## Data Flow

### [Flow 1: e.g., "User Request Flow"]

    [Step-by-step data flow description]
    1. User sends X
    2. Component A receives and transforms to Y
    3. Component B processes Y...

## Technology Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| [Layer] | [Tech] | [Why this choice] |

## Integration Points

### [External System 1]
- **Type**: [API/SDK/Protocol]
- **Purpose**: [Why we integrate]
- **Contract**: [High-level interface description]
- **Fallback**: [What happens if it's unavailable]

## Security Considerations

**Philosophy**: Production-grade from day one, but sized for first 200 users. Dedicated security milestone comes after product-market fit.

### Authentication & Authorization
- [How users authenticate]
- [How permissions are managed]

### Data Protection
- [Sensitive data identified]
- [Encryption approach - at rest, in transit]

### Known Risks (Acceptable for MVP)
- [Risk 1 - acceptable because...]
- [Risk 2 - will address in scale milestone]

## Observability

**Philosophy**: Just enough to debug issues and understand usage. Expand when scaling.

### Logging
- [What gets logged]
- [Where logs go]

### Monitoring
- [Key health metrics]
- [Alerting approach]

### Analytics
- [Key usage metrics to track]

## Key Design Decisions

### Decision 1: [Title]
- **Context**: [Situation]
- **Options Considered**: [List]
- **Decision**: [What we chose]
- **Rationale**: [Why]

## Constraints & Assumptions
- [Constraint/Assumption 1]
- [Constraint/Assumption 2]

## Future Considerations
[Things we might need later but aren't building now - e.g., "Dedicated security hardening milestone after 200+ users"]
