---
name: storyflow-briefing-to-stories
description: Generate user stories from an accepted briefing. Uses the codebase-analyzer agent for analysis, write-story skill for guidelines, and create-story MCP tool for saving.
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__create-story, Read, Glob, Grep, Bash, Agent
---

# Briefing to Stories

Generate user stories from an accepted briefing.

## Skills

Load the `write-story` skill before writing stories in step 5. Follow its guidelines strictly for story format, language guardrails, complexity sizing, priority assessment, and acceptance criteria.

## Arguments

The user provides a briefing ID as argument: `/storyflow:briefing-to-stories <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` to see available briefings.

## Process

### 0. Load project context

Read `.storyflow/config.json`.
- If file exists: extract `customer_name`, `asset_name`, `customer_id`, `asset_id` for context.
- If file does not exist: suggest running `/storyflow:setup` for a better experience. Continue without context.

### 1. Load briefing

Call `mcp__storyflow__get-briefing` with the provided ID.

**Validate status**: The briefing MUST be in **Accepted** status. If not, inform the user:
- Current status and what needs to happen to reach Accepted
- Suggest `/storyflow:briefings` to find accepted briefings

Stop here if not Accepted.

### 2. Check existing stories

Call `mcp__storyflow__get-briefing-stories` with the briefing ID.

If stories already exist, warn the user:

> This briefing already has [count] stories. Creating new stories will add to the existing set, not replace them. Continue? (yes/no)

Wait for confirmation before proceeding.

### 3. Analyze codebase

Dispatch the `codebase-analyzer` agent with the following prompt:

> Asset: "[asset name]"
> Briefing: "[briefing title]"
>
> [briefing functional document content]
>
> Analyze the codebase in the current working directory to understand what this application currently offers that is relevant to the briefing above.

Wait for the agent to complete. The result is a functional analysis of the existing application.

### 4. Story plan (phase 1 review)

Using the briefing document and codebase analysis, propose a story plan. Present it as:

```
## Story Plan for: [briefing title]

### Epic: [epic title]
| # | Story Title | Complexity | Priority |
|---|-------------|-----------|----------|
| 1 | [title]     | M         | medium   |
| 2 | [title]     | S         | high     |

### Standalone Stories
| # | Story Title | Complexity | Priority |
|---|-------------|-----------|----------|
| 3 | [title]     | L         | medium   |

Total: [X] stories across [Y] epics

Review this plan. You can:
- Add, remove, or merge stories
- Change complexity or priority
- Reorganize epic grouping
- Say "approved" to proceed to writing full stories
```

**Guidelines for the plan:**
- Group by user journeys, not technical components
- Only create an epic if it will contain 3+ related stories
- Target 3-7 stories per epic
- Every story must describe end-user value
- If more than 40% are high priority, reconsider

Iterate until the architect approves the plan.

### 5. Write stories (phase 2 review)

The `write-story` skill should already be loaded (see Skills section above). Follow its guidelines for each story.

For each story in the approved plan, write the full description following the skill's format:
- User story (As a / I want / So that)
- Business context
- Acceptance criteria (Given/When/Then scenarios)

Present ALL stories as a set for review:

```
## Stories for: [briefing title]

### 1. [Story title] (Complexity: M, Priority: medium)

**As a** [persona]
**I want to** [action]
**So that** [value]

**Business context:**
[context]

**Acceptance Criteria:**
[scenarios]

---

### 2. [Story title] ...

---

Ready to save these stories to StoryFlow? You can:
- Request changes to specific stories (e.g., "story 3 needs better acceptance criteria")
- Say "save" to create all stories
```

Iterate until the architect approves.

### 6. Save stories

For each approved story, call `mcp__storyflow__create-story` with:
- `briefingId`: the briefing ID
- `title`: story title
- `description`: full markdown description
- `priority`: low/medium/high

Report each result as it comes back. If a story fails to save, continue with the remaining stories and report the failure at the end.

**Note:** Epic grouping is shown in the plan for context but is not persisted in this version. Complexity is shown for the architect's benefit but is not stored (set during refinement phase).

### 7. Transition briefing to Scoped

After all stories are created, transition the briefing from Accepted to Scoped:

Call `mcp__storyflow__transition-briefing` with:
- `briefingId`: the briefing ID
- `action`: `scope`

This signals that scoping is complete and the briefing is ready for refinement.

### 8. Report results

```
Stories created:

- ACME-ST-1: [title]
- ACME-ST-2: [title]
- ACME-ST-3: [title]
[if any failed: "Failed: [title] - [error message]"]

Total: [X] stories created for briefing [key].
Briefing transitioned to Scoped.

Next steps:
- Use `/storyflow:briefing <id>` to review the briefing with its new stories
- Use `/storyflow:implement-briefing <id>` to generate an implementation plan
```
