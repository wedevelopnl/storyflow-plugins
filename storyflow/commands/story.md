---
name: storyflow-story
description: Load full context for a specific story, including description, refinement data, and comments.
allowed-tools: mcp__storyflow__get-story, mcp__storyflow__add-story-comment, Read
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

4. **Status-aware next steps**:

   - **Draft**: "This story is in draft. It needs to go through review and refinement."

   - **InReview**: "This story is being reviewed."

   - **NeedsClarification**: "This story needs clarification before it can proceed."

   - **Refined**: "This story has been refined. Next step is pricing (quoting)."

   - **Quoted**: "This story has been priced. It will move to todo when the briefing is claimed."

   - **ToDo**: "This story is ready for implementation. Start working on it."

   - **InProgress**: "This story is being worked on. Use the `transition-story` MCP tool with transition `complete` when done."

   - **Done**: "This story has been completed."

   - **Invoiced**: "This story has been invoiced."

   - **Cancelled**: "This story has been cancelled."
