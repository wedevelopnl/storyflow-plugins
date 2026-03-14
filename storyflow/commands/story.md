---
name: storyflow-story
description: Load full context for a specific story, including description, refinement data, and comments.
allowed-tools: mcp__storyflow__get-story, Read
---

# Load Story Context

Fetch and display complete details for a specific story.

## Arguments

The user provides a story ID as argument: `/storyflow:story <id>`

If no ID is provided, ask the user for one. Suggest loading a briefing first with `/storyflow:briefing <id>` to see available stories.

## Process

1. **Load project context**: Read `.storyflow/config.json`.
   - If file exists: extract `customer_name`, `asset_name`, `customer_id`, `asset_id` for context.
   - If file does not exist: continue without context. Suggest running `/storyflow:setup` for a better experience.

2. **Fetch story**: Call `mcp__storyflow__get-story` with the provided ID.

3. **Display story details** (if config was loaded, include asset context in the header):
   ```
   # Story: [Title]
   Status: [status] | Briefing: [briefing title] | Asset: [asset_name or from story data] | Priority: [priority]
   Complexity: [complexity]

   ## Description
   [story description]

   ## Refinement Data
   [If available: functional requirements, technical notes, acceptance criteria]

   ## Comments
   [List recent comments with author and date]
   ```

4. **Suggest next steps** based on story status:
   - **Accepted**: "This story is ready for implementation. Start working on it."
   - **InProgress**: "This story is being worked on. Use `/storyflow:complete-story <id>` when done."
   - **Done**: "This story is complete."
   - **Other**: Describe what needs to happen next in the workflow.
