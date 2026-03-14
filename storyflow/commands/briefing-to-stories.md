---
name: storyflow-briefing-to-stories
description: Generate user stories from an accepted briefing. Analyzes the codebase, generates stories following StoryFlow guidelines, and submits them via MCP after architect approval.
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__create-briefing-stories, Read, Glob, Grep, Bash, Agent
---

# Briefing to Stories

Generate user stories from an accepted briefing by analyzing the codebase and briefing context.

## Arguments

The user provides a briefing ID as argument: `/storyflow:briefing-to-stories <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` to see available briefings.

## Skills

Load the `generate-stories` skill before generating stories. Follow its guidelines strictly for story format, language guardrails, complexity sizing, priority assessment, epic grouping, and acceptance criteria.

## Process

### 0. Load project context

Read `.storyflow/config.json`.
- If file exists: extract `customer_name`, `asset_name`, `customer_id`, `asset_id` for context. Use the asset context to focus codebase analysis in step 3.
- If file does not exist: continue without context. Suggest running `/storyflow:setup` for a better experience.

### 1. Load briefing context

Call `mcp__storyflow__get-briefing` with the provided ID.

**Validate status**: The briefing MUST be in **Accepted** status. If not, inform the user:
- Current status and what needs to happen to reach Accepted
- Suggest `/storyflow:briefings` to find accepted briefings

### 2. Check existing stories

Call `mcp__storyflow__get-briefing-stories` with the briefing ID.

If stories already exist, warn the user:
```
This briefing already has [count] stories:
[list story keys and titles]

Creating new stories will add to the existing set, not replace them.
Continue anyway? (yes/no)
```

Wait for confirmation before proceeding.

### 3. Analyze the codebase

Based on the briefing's asset and description, explore the relevant parts of the codebase:

- Use `Glob` and `Grep` to find files related to the briefing's domain
- Use `Read` to understand existing patterns, data models, and UI structures
- Focus on areas the briefing touches: existing features being extended, related modules, shared components

This analysis informs accurate complexity estimates and helps identify stories that align with existing architecture.

### 4. Generate stories

Following the `generate-stories` skill guidelines:

- Analyze all briefing documents (functional requirements, technical requirements, user stories document)
- Generate stories grouped into epics where appropriate
- Ensure every story describes end-user value (no infrastructure stories)
- Use business language, not technical jargon
- Rate complexity based on scope of new functionality, informed by codebase analysis
- Assign priority based on importance to the client's goals

### 5. Present for review

Present the generated stories as a summary table:

```
## Generated Stories

### Epic: [epic title]
| # | Title | Complexity | Priority |
|---|-------|-----------|----------|
| 1 | [title] | M | medium |
| 2 | [title] | S | high |

### Standalone Stories
| # | Title | Complexity | Priority |
|---|-------|-----------|----------|
| 3 | [title] | L | medium |

Total: [X] stories across [Y] epics

Ready to submit these stories to StoryFlow? You can:
- Ask me to adjust specific stories (change title, complexity, priority, description)
- Ask me to add, remove, or reorganize stories
- Say "submit" to create all stories
```

### 6. Iterate on feedback

If the architect requests changes:
- Apply requested modifications
- Re-present the updated table
- Repeat until the architect approves

### 7. Submit stories

When the architect says "submit" or confirms:

Call `mcp__storyflow__create-briefing-stories` with:
- `briefingId`: the briefing ID
- `data`: JSON string with the `epics` and `standaloneStories` arrays

### 8. Report results

Show the created stories with their assigned keys:

```
Stories created successfully:

[Epic: title]
  - ACME-42: Story title
  - ACME-43: Story title

[Standalone]
  - ACME-44: Story title

Total: [X] stories created.

Next steps:
- Use `/storyflow:briefing <id>` to review the briefing with its new stories
- Use `/storyflow:implement-briefing <id>` to generate an implementation plan
```
