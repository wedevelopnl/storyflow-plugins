---
name: storyflow-story
description: Load full context for a specific story, including description, refinement data, and comments.
allowed-tools: mcp__storyflow__get-story
---

# Load Story Context

Fetch and display complete details for a specific story.

## Arguments

The user provides a story ID as argument: `/storyflow:story <id>`

If no ID is provided, ask the user for one. Suggest loading a briefing first with `/storyflow:briefing <id>` to see available stories.

## Process

1. **Fetch story**: Call `mcp__storyflow__get-story` with the provided ID.

2. **Display story details**:
   ```
   # Story: [Title]
   Status: [status] | Briefing: [briefing title] | Priority: [priority]
   Complexity: [complexity]

   ## Description
   [story description]

   ## Refinement Data
   [If available: functional requirements, technical notes, acceptance criteria]

   ## Comments
   [List recent comments with author and date]
   ```

3. **Suggest next steps** based on story status:
   - **Accepted**: "This story is ready for implementation. Start working on it."
   - **InProgress**: "This story is being worked on. Use `/storyflow:complete-story <id>` when done."
   - **Done**: "This story is complete."
   - **Other**: Describe what needs to happen next in the workflow.
