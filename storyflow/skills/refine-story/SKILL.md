---
name: Refine a Single Story
description: "Run multi-agent refinement analysis on a single story. Dispatches the refinement-lead agent to analyze complexity, risk, acceptance criteria, and potential concerns from multiple specialist perspectives. Saves results via the refine-story MCP tool."
disable-model-invocation: true
allowed-tools: mcp__storyflow__get-story, mcp__storyflow__get-briefing, Read, Grep, Glob, Agent
argument-hint: "<story-id>"
---

# Refine a Single Story

Run multi-agent refinement analysis on a story and save the results.

## Arguments

The user provides a story ID as argument: `/storyflow:refine-story <id>`

If no ID is provided, ask the user for one. Suggest loading a briefing first with `/storyflow:briefing <id>` to see available stories.

## Process

1. **Load project context**: Read `.storyflow/config.json`.
   - If file exists: extract `customer_name`, `asset_name`, `customer_id`, `asset_id` for context.
   - If file does not exist: continue without context. Suggest running `/storyflow:setup` for a better experience.

2. **Fetch story**: Call `mcp__storyflow__get-story` with the provided ID.

3. **Check existing refinement**: If the story already has refinement data (complexity, risk, report, or concerns are present):
   - Show the existing refinement summary: complexity, risk, concern count.
   - Ask the user: "This story already has refinement data. Do you want to re-refine it? The existing data will be overwritten."
   - If the user declines, stop.

4. **Load briefing context**: If the story belongs to a briefing (briefing ID is available in the story data):
   - Call `mcp__storyflow__get-briefing` to get the briefing description and requirements.
   - This gives specialists the broader context of what the customer wants.

5. **Build context payload**: Assemble the full context for the refinement lead agent:
   ```
   ## Project
   Customer: [customer_name]
   Asset: [asset_name]

   ## Story
   Title: [title]
   Key: [key]
   Status: [status]
   Description: [description]

   ## Briefing
   Title: [briefing title]
   Description: [briefing description/requirements]
   ```

6. **Spawn refinement-lead agent**: Launch the `refinement-lead` agent with the assembled context. The lead agent handles specialist triage, dispatch, synthesis, and saving via MCP.

7. **Display results**: After the agent completes, show:
   ```
   # Refinement Complete: [story title]

   Complexity: [complexity]
   Risk: [risk]
   Concerns: [count]

   [Brief summary of key findings]
   ```

8. **Suggest next steps**:
   - Fetch the story again via `get-story` and show the available transitions from the MCP response. Suggest using `transition-story` with the appropriate action.
   - If other stories in the same briefing need refinement: "Use `/storyflow:refine-briefing <briefing-id>` to refine all stories in the briefing."
