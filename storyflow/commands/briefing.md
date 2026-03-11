---
name: storyflow-briefing
description: Load full context for a specific briefing, including its stories, documents, and conversation.
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__get-story
---

# Load Briefing Context

Fetch and display complete context for a specific briefing.

## Arguments

The user provides a briefing ID as argument: `/storyflow:briefing <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` first to see available briefings.

## Process

1. **Fetch briefing**: Call `mcp__storyflow__get-briefing` with the provided ID.

2. **Fetch stories**: Call `mcp__storyflow__get-briefing-stories` with the briefing ID.

3. **Load story details**: For each story returned, call `mcp__storyflow__get-story` to get full details including refinement data. Run these calls in parallel where possible.

4. **Display briefing overview**:
   ```
   # Briefing: [Title]
   Status: [status] | Customer: [customer] | Asset: [asset]

   ## Description
   [briefing description/requirements]

   ## Documents
   [list any attached documents with types]

   ## Stories ([count])
   For each story:
   - [Story Title] (status) - [brief description]
     Complexity: [complexity] | Priority: [priority]
     [If refinement data exists: show acceptance criteria summary]
   ```

5. **Suggest next steps** based on briefing status:
   - **Approved**: "This briefing is ready to claim. Use `/storyflow:claim-briefing <id>` to claim it, or `/storyflow:implement-briefing <id>` to generate an implementation plan."
   - **InProgress**: "This briefing is being implemented. Use `/storyflow:story <id>` to dive into individual stories, or `/storyflow:implement-briefing <id>` to generate a plan."
   - **Other**: Describe what needs to happen next in the workflow.
