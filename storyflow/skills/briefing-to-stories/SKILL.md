---
name: Convert Briefing to Stories
description: "Generate user stories from an accepted briefing. Uses codebase-analyzer agent for analysis, MCP guidelines for format, and creates stories in epics or standalone groups. Includes a two-phase review (story plan, then full stories) before saving."
disable-model-invocation: true
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__create-briefing-stories, mcp__storyflow__transition-briefing, mcp__storyflow__get-story-guidelines, mcp__storyflow__get-briefing-to-stories-guidelines, Read, Glob, Grep, Bash, Agent
argument-hint: "<briefing-id>"
---

# Briefing to Stories

Generate user stories from an accepted briefing.

## Guidelines

Before creating the story plan in step 4, fetch both sets of guidelines:
1. Call `mcp__storyflow__get-briefing-to-stories-guidelines` for the conversion methodology (analysis, grouping, epic organization, review criteria).
2. Call `mcp__storyflow__get-story-guidelines` for individual story format (language guardrails, acceptance criteria, complexity sizing, priority).

Follow both sets of guidelines strictly throughout the process.

## Arguments

The user provides a briefing ID as argument: `/storyflow:briefing-to-stories <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` to see available briefings.

## Process

### 0. Load project context

Read `.storyflow/config.json` to get `customer_name`, `asset_name`, `customer_id`, `asset_id`.
- If the file does not exist: tell the user to run `/storyflow:setup` first. Do not proceed without config.

### 1. Load briefing

Call `mcp__storyflow__get-briefing` with the provided ID.

**Validate eligibility**: Check the briefing's available transitions (included in the response). The `create-briefing-stories` MCP tool requires the briefing to be in a status that allows story creation. If this is not possible, inform the user of the current status and the available transitions instead. Stop here if story creation is not available.

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

Apply the briefing-to-stories guidelines (fetched in the Guidelines step) for grouping, epic organization, count guidance, and priority distribution.

Iterate until the architect approves the plan.

### 5. Write stories (phase 2 review)

For each story in the approved plan, write the full description following the story writing guidelines (fetched in the Guidelines step):
- User story (As a / I want / So that)
- Business context
- Acceptance criteria (Given/When/Then scenarios)

Present ALL stories as a set for review:

```
## Stories for: [briefing title]

### Epic: [epic title]

#### 1. [Story title] (Complexity: M, Priority: medium)

**As a** [persona]
**I want to** [action]
**So that** [value]

**Business context:**
[context]

**Acceptance Criteria:**
[scenarios]

---

#### 2. [Story title] ...

---

### Standalone Stories

#### 3. [Story title] ...

---

Ready to save these stories to StoryFlow? You can:
- Request changes to specific stories (e.g., "story 3 needs better acceptance criteria")
- Say "save" to create all stories
```

Iterate until the architect approves.

### 6. Save stories

Call `mcp__storyflow__create-briefing-stories` with the briefing ID and a JSON `data` string containing the approved stories structured as:

```json
{
  "epics": [
    {
      "title": "Epic title",
      "description": "Optional epic description",
      "stories": [
        { "title": "Story title", "description": "Full markdown description", "complexity": "M", "priority": "medium" }
      ]
    }
  ],
  "standaloneStories": [
    { "title": "Story title", "description": "Full markdown description", "complexity": "L", "priority": "high" }
  ]
}
```

This creates all stories and epics in one call, preserving the epic grouping.

### 7. Transition briefing

After stories are created, fetch the briefing again to check its available transitions. Apply the appropriate transition to advance the briefing to the next status (the MCP response will indicate which transition is available after story creation).

### 8. Report results

```
Stories created:

Epic: [epic title]
  - [KEY]-ST-1: [title]
  - [KEY]-ST-2: [title]

Standalone:
  - [KEY]-ST-3: [title]

[if any failed: "Failed: [title] - [error message]"]

Total: [X] stories created for briefing [key].
Briefing transitioned to [new status].

Next steps:
[Show available transitions from the briefing's current state]
- Use `/storyflow:briefing <id>` to review the briefing with its new stories
```
