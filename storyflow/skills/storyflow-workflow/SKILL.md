---
name: StoryFlow Workflow
description: "This skill should be used when the user asks about briefing lifecycle, story lifecycle, status transitions, claiming a briefing, completing a story, marking stories as done, which MCP tools to use for briefing or story transitions, or what status a briefing or story is in. Also relevant when asking about the relationship between briefings and stories, briefing-to-story workflow, or how Software Architects sequence work on a briefing."
---

# StoryFlow Workflow Knowledge

Provides lifecycle, status, and transition knowledge for StoryFlow's briefing and story domains.

## Terminology

- **Software Architect**: The term for developers within StoryFlow/WeDevelop agencies. Maps to `ROLE_AGENCY_DEVELOPER`.
- **Briefing**: A customer's request for work, containing requirements, documents, and eventually stories.
- **Story**: An individual unit of work derived from a briefing, with its own pricing and implementation lifecycle.
- **Asset**: A customer's application/project linked to a Git repository.

## Briefing Lifecycle

```
Draft -> Submitted -> Accepted -> Scoped -> Refined -> Quoted -> QuoteOffered -> Approved -> InProgress -> Done -> Archived
```

| Status | Description | Who acts |
|--------|-------------|----------|
| Draft | Customer is writing the briefing | Customer |
| Submitted | Customer submitted for agency review | Customer |
| Accepted | Agency accepted the briefing for scoping | Agency PO |
| Scoped | AI has analyzed and created draft stories | System |
| Refined | Stories have been refined with details | Agency PO |
| Quoted | Stories have been priced by the agency | Agency PO/Finance |
| QuoteOffered | Quote sent to customer for approval | Agency PO |
| Approved | Customer approved the quote, ready for implementation | Customer |
| InProgress | A Software Architect is implementing the stories | Software Architect |
| Done | All stories completed | System |
| Archived | Briefing archived after completion | Agency |

### Key Transitions for Software Architects

- **Approved -> InProgress**: Claim a briefing via `mcp__storyflow__claim-briefing`. This assigns the architect to the briefing.
- Only **Approved** briefings can be claimed.
- Claiming transitions the briefing to InProgress automatically.

## Story Lifecycle

```
Draft -> Review -> Quoted -> Accepted -> InProgress -> Done -> Invoiced
```

| Status | Description | Who acts |
|--------|-------------|----------|
| Draft | Story created (usually from briefing scoping) | System/Agency PO |
| Review | Story under review by agency | Agency PO |
| Quoted | Story has been priced | Agency PO/Finance |
| Accepted | Customer accepted the story quote | Customer |
| InProgress | Being implemented by a Software Architect | Software Architect |
| Done | Implementation complete | Software Architect |
| Invoiced | Billed to customer | Agency Finance |

### Key Transitions for Software Architects

- **Accepted -> InProgress**: Start working on a story (usually happens when briefing is claimed)
- **InProgress -> Done**: Mark story as complete via `mcp__storyflow__transition-story` with action `complete`

## Briefing-Story Relationship

- A briefing contains one or more stories (1:N relationship)
- A briefing always has exactly one asset (1:1 relationship)
- Stories are generated during the Scoped phase, refined during Refined phase
- Each story has its own price, complexity, and implementation details
- Stories within a briefing can be implemented in any order unless dependencies exist

## MCP Tools Reference

| Tool | Purpose |
|------|---------|
| `mcp__storyflow__list-briefings` | List briefings (filterable by customer) |
| `mcp__storyflow__get-briefing` | Get full briefing details |
| `mcp__storyflow__get-briefing-stories` | Get stories belonging to a briefing |
| `mcp__storyflow__claim-briefing` | Claim an Approved briefing (transitions to InProgress) |
| `mcp__storyflow__transition-briefing` | Transition briefing status |
| `mcp__storyflow__add-briefing-comment` | Add a comment to a briefing |
| `mcp__storyflow__list-stories` | List stories (filterable) |
| `mcp__storyflow__get-story` | Get full story details with refinement data |
| `mcp__storyflow__transition-story` | Transition story status |
| `mcp__storyflow__add-story-comment` | Add a comment to a story |
| `mcp__storyflow__get-epic` | Get epic details (story grouping) |
| `mcp__storyflow__list-epics` | List epics |

## Value-Based Pricing

StoryFlow sells value, not hours. Customers see what they get and what it costs. Estimated hours exist internally but must never be exposed to customers. When creating implementation plans, focus on deliverables and scope, not time estimates.

## Workflow Tips

- Load briefing context before starting implementation: use `mcp__storyflow__get-briefing` + `mcp__storyflow__get-briefing-stories`
- Load individual story details via `mcp__storyflow__get-story` for refinement data (functional requirements, technical notes, acceptance criteria)
- Add comments to briefings/stories to track progress and communicate with the team
- When completing a story, add a completion note as an internal comment before transitioning
