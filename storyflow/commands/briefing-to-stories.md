---
name: storyflow-briefing-to-stories
description: Generate user stories from an accepted briefing. Uses the codebase-analyzer agent for analysis, write-story skill for guidelines, and create-briefing-stories MCP tool for saving.
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__create-briefing-stories, mcp__storyflow__transition-briefing, Read, Glob, Grep, Bash, Agent
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

Read `.storyflow/config.json` to get `customer_name`, `asset_name`, `customer_id`, `asset_id`.
- If the file does not exist: tell the user to run `/storyflow:setup` first. Do not proceed without config.

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

### 7. Transition briefing to Scoped

After stories are created, transition the briefing from Accepted to Scoped:

Call `mcp__storyflow__transition-briefing` with:
- `briefingId`: the briefing ID
- `transition`: `scope`

This signals that scoping is complete and the briefing is ready for refinement.

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
Briefing transitioned to Scoped.

Next steps:
- Use `/storyflow:refine-briefing <id>` to run multi-agent refinement on all stories
- Use `/storyflow:briefing <id>` to review the briefing with its new stories
```
