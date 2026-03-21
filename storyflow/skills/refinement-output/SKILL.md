---
name: Refinement Output Format
description: "Defines the exact output structure for story refinement analysis. Use when producing refinement results via the refine-story MCP tool, when assessing complexity or risk levels, when formatting a refinement report, or when structuring concerns for a story."
---

# Refinement Output Format

This skill defines the output structure that the refinement lead agent must produce and save via the `mcp__storyflow__refine-story` MCP tool.

## MCP Tool Call

```
mcp__storyflow__refine-story(storyId, complexity, risk, report, concerns)
```

Parameters:
- `storyId` (string, required): The story UUID
- `complexity` (string, required): One of `low`, `medium`, `high`, `very_high`
- `risk` (string, required): One of `low`, `medium`, `high`
- `report` (string, required): Markdown-formatted analysis report
- `concerns` (string, optional): JSON array of concern objects

After saving, use `mcp__storyflow__transition-story` with action `complete-refinement` to move the story from `in_review` to `refined`.

## Field Definitions

### Complexity

Measures the scope and difficulty of implementing the story.

| Value | Criteria |
|-------|----------|
| `low` | Single layer affected, straightforward change, well-established patterns exist in the codebase, minimal new code |
| `medium` | 2-3 layers affected, requires new components or moderate changes to existing ones, patterns exist but need adaptation |
| `high` | Multiple layers affected, new domain concepts or significant architectural changes, cross-cutting concerns (auth, multi-tenancy, i18n) |
| `very_high` | Affects most layers, requires new infrastructure or major refactoring, introduces new patterns not yet in the codebase, high coordination cost |

When in doubt between two levels, choose the higher one.

### Risk

Measures the likelihood of unexpected problems during implementation.

| Value | Criteria |
|-------|----------|
| `low` | Well-understood domain, good test coverage in affected area, isolated changes with clear boundaries |
| `medium` | Some unknowns, moderate test coverage, changes touch shared code or integration points |
| `high` | Significant unknowns, poor test coverage in affected area, changes to critical paths (auth, billing, data integrity), external dependencies |

### Report

A markdown-formatted analysis with the following structure:

```markdown
## Analysis

[What this story requires, what areas of the codebase are affected, and how the changes relate to existing functionality.]

## Implementation Considerations

[Key technical decisions, patterns to follow, potential approaches, and trade-offs. Reference specific files or patterns found in the codebase.]

## Dependencies

[Other stories, external services, or prerequisites that affect implementation. Note any ordering constraints.]
```

Keep the report concise and actionable. Focus on what the implementing developer needs to know.

### Concerns

A JSON array of objects, each representing a potential issue or risk. Pass as a JSON string to the MCP tool.

```json
[
  {
    "severity": "critical",
    "theme": "Data Migration",
    "description": "Existing records need backfilling for the new required field. A migration strategy is needed before this can go live."
  },
  {
    "severity": "warning",
    "theme": "Performance",
    "description": "The proposed approach requires an additional database query per item in the list view. Consider eager loading."
  }
]
```

Each concern object has three fields:

| Field | Type | Description |
|-------|------|-------------|
| `severity` | `critical`, `warning`, or `info` | How urgent the concern is |
| `theme` | string | Short category label (e.g., "Security", "Performance", "Data Integrity") |
| `description` | string | Explanation of the concern and suggested mitigation |

**Severity guide:**

- `critical`: Blocks implementation or could cause data loss, security issues, or breaking changes. Must be resolved before starting work.
- `warning`: Could cause problems if not addressed. Should be considered during implementation planning.
- `info`: Noteworthy observation. Good to be aware of but does not block progress.

Aim for 0-5 concerns per story. Not every story has concerns. Do not invent concerns for the sake of completeness.

## Example

```
mcp__storyflow__refine-story(
  storyId: "abc-123",
  complexity: "medium",
  risk: "low",
  report: "## Analysis\n\nThis story adds email notification preferences to user profiles. The backend needs a new value object for notification settings and a command handler to update them. The frontend requires a new section on the profile page.\n\n## Implementation Considerations\n\nFollow the existing `UserProfile` update pattern in `Application/User/Command/`. The frontend profile page at `features/profile/` already has a tabbed layout that can accommodate a new notifications tab. Use the existing `MailerService` for sending test notifications.\n\n## Dependencies\n\nNo dependencies on other stories. The mailer infrastructure is already in place.",
  concerns: "[{\"severity\": \"info\", \"theme\": \"Email Deliverability\", \"description\": \"Consider adding email verification before enabling notifications to avoid bounced emails.\"}]"
)
```
