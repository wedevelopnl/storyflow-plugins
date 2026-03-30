---
name: load-story
description: "Fetch and display complete details for a specific story: description, acceptance criteria, refinement data (complexity, risk, report, concerns), comments, and status-aware next steps. Use when the user asks about a specific story or wants to see story details."
allowed-tools: mcp__storyflow__get-story, mcp__storyflow__add-story-comment, Read
argument-hint: "<story-id>"
---

# Load Story Context

Fetch and display complete details for a specific story.

## Arguments

The user provides a story ID as argument: `/storyflow:story <id>`

If no ID is provided, ask the user for one. Suggest loading a briefing first with `/storyflow:briefing <id>` to see available stories.

## Process

1. **Load project context** (required): Read `.storyflow/config.json` to get `customer_name`, `asset_name`, `customer_id`, `asset_id`.
   - If the file does not exist: tell the user to run `/storyflow:setup` first. Do not proceed without config.

2. **Fetch story**: Call `mcp__storyflow__get-story` with the provided ID.

3. **Display story dashboard**:

   If the story's asset does not match `asset_name` from config, show a warning.

   ```
   # Story: [Key] - [Title]
   Status: [status] | Priority: [priority] | Price: [price or "not priced"]
   Asset: [asset] | Project: [project] | Briefing: [briefing key]
   Created: [date] | Updated: [date]

   ## Description
   [Full user story with acceptance criteria as returned by get-story]

   ## Refinement
   Complexity: [complexity] | Risk: [risk]

   ### Analysis
   [The refinement report - this is a detailed implementation analysis,
    not a list of acceptance criteria]

   ### Concerns
   [List concerns with their severity level: WARNING or INFO]
   ```

   If no refinement data exists, show: "This story has not been refined yet."

4. **Available transitions and next steps**:

   The `get-story` MCP response includes an "Available transitions" section listing what actions can be taken next, with transition names, labels, target statuses, and required data fields. Display these transitions as the next steps.

   For each available transition, suggest the corresponding action:
   - If a transition maps to a plugin skill (e.g., refinement, pricing), suggest the `/storyflow:` skill
   - Otherwise, suggest using the `transition-story` MCP tool with the transition name

   If no transitions are available, the story is in a terminal state (Done, Invoiced, Cancelled).

   Always end with: "Use `/storyflow:briefing <key>` to see the full briefing context for this story."
