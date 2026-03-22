---
name: StoryFlow Workflow
description: "This skill should be used when the user asks about briefing lifecycle, story lifecycle, status transitions, claiming a briefing, completing a story, marking stories as done, which MCP tools to use for briefing or story transitions, what status a briefing or story is in, or how story refinement works. Also relevant when asking about the relationship between briefings and stories, briefing-to-story workflow, refinement analysis, or how Software Architects sequence work on a briefing."
---

# StoryFlow Workflow Knowledge

Provides lifecycle, status, and transition knowledge for StoryFlow's briefing and story domains.

## Terminology

- **Software Architect**: The term for developers within StoryFlow/WeDevelop agencies. Maps to `ROLE_AGENCY_DEVELOPER`.
- **Briefing**: A customer's request for work, containing requirements, documents, and eventually stories.
- **Story**: An individual unit of work derived from a briefing, with its own pricing and implementation lifecycle.
- **Asset**: A customer's application/project linked to a Git repository.
- **Refinement**: Multi-agent technical analysis of a story, producing complexity, risk, report, and concerns.

## Discovering Transitions

Transitions are **self-describing** via MCP responses. You do not need to memorize status flows.

- `mcp__storyflow__get-briefing` and `mcp__storyflow__get-story` responses include an "Available transitions" section listing what you can do next, with labels, target statuses, and required data fields.
- `mcp__storyflow__list-briefings` and `mcp__storyflow__list-stories` show available transition names per item.
- `mcp__storyflow__transition-briefing` and `mcp__storyflow__transition-story` accept a transition name and optional data JSON. On error, the response tells you why it failed and what alternatives are available.

**Example flow:**
1. Call `get-briefing` to see the current status and available transitions
2. Pick a transition from the available list
3. Call `transition-briefing` with the transition name (and required data if listed)
4. On error: read the structured error message for guidance

## Briefing Lifecycle Overview

```
Draft -> Submitted -> Accepted -> Scoped -> Refined -> Priced -> Approved -> InProgress -> Done -> Archived
```

Backward transitions exist (e.g., return-to-draft, return-to-scoped). Cancellation is available from most statuses. Use `get-briefing` to see exactly which transitions are available for a specific briefing.

### Key Actions for Software Architects

- **Claim a briefing**: Use `transition-briefing` with transition `claim` on an Approved briefing. This assigns you and moves the briefing to InProgress.
- **Create stories**: Use `/storyflow:briefing-to-stories` after a briefing is Accepted.
- **Refine stories**: Use `/storyflow:refine-briefing` when stories are in Scoped status.
- **Complete a briefing**: Use `transition-briefing` with transition `complete` when all stories are done.

## Story Lifecycle Overview

Feature stories follow:
```
Draft -> InReview -> Refined -> Quoted -> ToDo -> InProgress -> Done -> Invoiced
```

Incident stories follow a separate lifecycle:
```
Open -> Acknowledged -> Investigating -> InProgress -> Resolved -> Closed -> Invoiced
```

Use `get-story` to see exactly which transitions are available for a specific story.

### Story Refinement

Stories in `InReview` status can be refined using multi-agent analysis:

1. Run `/storyflow:refine-story <id>` for a single story, or `/storyflow:refine-briefing <id>` for all stories
2. The refinement-lead agent explores the codebase and dispatches specialist agents
3. Save refinement data via `mcp__storyflow__refine-story`
4. Transition with `complete-refinement` when satisfied

Refinement data: complexity (`low`/`medium`/`high`/`very_high`), risk (`low`/`medium`/`high`), report (markdown), concerns (structured list with severity/theme/description).

## Briefing-Story Relationship

- A briefing contains one or more stories (1:N)
- A briefing always has exactly one asset (1:1)
- Stories are generated during Accepted->Scoped phase, refined during Scoped->Refined phase
- Each story has its own price, complexity, and implementation details

## MCP Tools Reference

| Tool | Purpose |
|------|---------|
| `mcp__storyflow__list-briefings` | List briefings (filterable by status, customer, asset) |
| `mcp__storyflow__get-briefing` | Get full briefing details with available transitions |
| `mcp__storyflow__get-briefing-stories` | Get stories belonging to a briefing |
| `mcp__storyflow__transition-briefing` | Transition briefing status (includes claim, cancel, archive) |
| `mcp__storyflow__add-briefing-comment` | Add a comment to a briefing |
| `mcp__storyflow__list-stories` | List stories (filterable) with available transitions |
| `mcp__storyflow__get-story` | Get full story details with refinement data and available transitions |
| `mcp__storyflow__refine-story` | Save refinement analysis for a story |
| `mcp__storyflow__transition-story` | Transition story status |
| `mcp__storyflow__add-story-comment` | Add a comment to a story |
| `mcp__storyflow__create-story` | Create a single story linked to a briefing |
| `mcp__storyflow__get-epic` | Get epic details |
| `mcp__storyflow__list-epics` | List epics |

## Commands Reference

| Command | Purpose |
|---------|---------|
| `/storyflow:briefings` | List available briefings |
| `/storyflow:briefing <id>` | Load full briefing context |
| `/storyflow:story <id>` | Load full story context |
| `/storyflow:claim-briefing <id>` | Claim an approved briefing |
| `/storyflow:briefing-to-stories <id>` | Generate stories from a briefing |
| `/storyflow:refine-story <id>` | Refine a single story with multi-agent analysis |
| `/storyflow:refine-briefing <id>` | Refine all stories of a briefing |
| `/storyflow:implement-briefing <id>` | Generate an implementation plan |
| `/storyflow:complete-story <id>` | Mark a story as done |
| `/storyflow:update-docs` | Update asset documentation |

## Value-Based Pricing

StoryFlow sells value, not hours. Customers see what they get and what it costs. Estimated hours exist internally but must never be exposed to customers.

## Workflow Tips

- Load briefing context before starting: `get-briefing` + `get-briefing-stories`
- Load individual story details via `get-story` for refinement data and available transitions
- Use `/storyflow:refine-briefing` after stories are scoped to run refinement on all stories
- Add comments to briefings/stories to track progress and communicate with the team
- When completing a story, add a completion note as an internal comment before transitioning
