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

## Briefing Lifecycle

```
Draft -> Submitted -> Accepted -> Scoped -> Refined -> Quoted -> QuoteOffered -> Approved -> InProgress -> Done -> Archived
```

| Status | Description | Who acts |
|--------|-------------|----------|
| Draft | Customer is writing the briefing | Customer |
| Submitted | Customer submitted for agency review | Customer |
| Accepted | Agency accepted the briefing for scoping | Agency PO |
| Scoped | Stories created, scoping confirmed by agency | Agency PO |
| Refined | Stories have been refined with technical analysis | Software Architect |
| Quoted | Stories have been priced by the agency | Agency PO/Finance |
| QuoteOffered | Quote sent to customer for approval | Agency PO |
| Approved | Customer approved the quote, ready for implementation | Customer |
| InProgress | A Software Architect is implementing the stories | Software Architect |
| Done | All stories completed | System |
| Archived | Briefing archived after completion | Agency |

### Key Transitions for Software Architects

- **Accepted -> Scoped**: Transition via `mcp__storyflow__transition-briefing` with action `scope`. Requires at least one story. The `/storyflow:briefing-to-stories` command does this automatically after creating stories.
- **Scoped -> Refined**: Transition via `mcp__storyflow__transition-briefing` with action `refine`. Requires all stories to have refinement data. Use `/storyflow:refine-briefing` to refine all stories first.
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
| Review | Story under review, ready for refinement | Agency PO / Software Architect |
| Quoted | Story has been priced | Agency PO/Finance |
| Accepted | Customer accepted the story quote | Customer |
| InProgress | Being implemented by a Software Architect | Software Architect |
| Done | Implementation complete | Software Architect |
| Invoiced | Billed to customer | Agency Finance |

### Key Transitions for Software Architects

- **Draft -> Review**: Story moves to review for refinement analysis
- **Review -> Refined**: After refinement analysis is saved, transition via `mcp__storyflow__transition-story` with action `complete-refinement`
- **Accepted -> InProgress**: Start working on a story (usually happens when briefing is claimed)
- **InProgress -> Done**: Mark story as complete via `mcp__storyflow__transition-story` with action `complete`

### Story Refinement

Stories in `Review` status can be refined using multi-agent analysis. The refinement process:

1. Run `/storyflow:refine-story <id>` for a single story, or `/storyflow:refine-briefing <id>` for all stories in a briefing
2. The refinement-lead agent explores the codebase and dispatches specialist agents (backend, frontend, security, QA, devops)
3. Specialists analyze the story from their perspective and report complexity, risk, and concerns
4. The lead agent synthesizes results and saves via `mcp__storyflow__refine-story`
5. Transition the story with `complete-refinement` when satisfied with the analysis

Refinement data includes:
- **Complexity**: `low`, `medium`, `high`, or `very_high`
- **Risk**: `low`, `medium`, or `high`
- **Report**: Markdown analysis covering implementation considerations and dependencies
- **Concerns**: Structured list of issues with severity (`critical`, `warning`, `info`), theme, and description

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
| `mcp__storyflow__refine-story` | Save refinement analysis for a story (complexity, risk, report, concerns) |
| `mcp__storyflow__transition-story` | Transition story status |
| `mcp__storyflow__add-story-comment` | Add a comment to a story |
| `mcp__storyflow__get-epic` | Get epic details (story grouping) |
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
| `/storyflow:update-docs <id>` | Update asset documentation |

## Value-Based Pricing

StoryFlow sells value, not hours. Customers see what they get and what it costs. Estimated hours exist internally but must never be exposed to customers. When creating implementation plans, focus on deliverables and scope, not time estimates.

## Workflow Tips

- Load briefing context before starting implementation: use `mcp__storyflow__get-briefing` + `mcp__storyflow__get-briefing-stories`
- Load individual story details via `mcp__storyflow__get-story` for refinement data (complexity, risk, report, concerns)
- Use `/storyflow:refine-briefing` after stories are scoped to run refinement on all stories at once
- Add comments to briefings/stories to track progress and communicate with the team
- When completing a story, add a completion note as an internal comment before transitioning
