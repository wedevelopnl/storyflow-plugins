---
name: storyflow-implement
description: Generate an implementation plan from a StoryFlow briefing. Loads briefing context, explores the codebase, and creates a structured plan document.
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__get-story, mcp__storyflow__add-briefing-comment, Read, Glob, Grep, Bash, Write, Agent
---

# Implement Briefing

Generate a comprehensive implementation plan from a StoryFlow briefing. This is the flagship workflow command.

## Arguments

The user provides a briefing ID as argument: `/storyflow:implement-briefing <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` to see available briefings.

## Process

1. **Load project context** (required): Read `.storyflow/config.json` to get `customer_name`, `asset_name`, `customer_id`, `asset_id`.
   - If the file does not exist: tell the user to run `/storyflow:setup` first. Do not proceed without config.

2. **Load briefing and stories list in parallel**:
   - Call `mcp__storyflow__get-briefing` with the provided ID.
   - Call `mcp__storyflow__get-briefing-stories` with the briefing ID.

3. **Load full story details**: For each story, call `mcp__storyflow__get-story` to get the complete description (user story + acceptance criteria) and refinement data (report + concerns). Run these calls in parallel.

   Why: `get-briefing-stories` only returns titles, status, price, and complexity/risk. The briefing-planner agent needs the full descriptions and acceptance criteria to generate a good plan.

4. **Prepare agent prompt**: Compile all briefing and story data into a structured prompt for the briefing-planner agent. Include:
   - Briefing title, status, customer, asset
   - Full briefing document (functional specification from Virtual PO chat)
   - Full story list with titles, descriptions, acceptance criteria, refinement reports, concerns, complexity, priority
   - `asset_id` and `asset_name` from config so the agent can focus its codebase exploration

5. **Launch briefing-planner agent**: Use the Agent tool with `subagent_type: "storyflow:briefing-planner"` to generate the implementation plan. Pass the compiled briefing+story data as the prompt. The agent will independently explore the codebase and generate the plan.

6. **Save plan**: Write the generated plan to `docs/plans/` with the naming convention:
   ```
   docs/plans/YYYY-MM-DD-briefing-<slug>.md
   ```
   Where `<slug>` is a kebab-case version of the briefing title (first 5-6 words).
   Create the `docs/plans/` directory if it doesn't exist.

7. **Post comment**: Call `mcp__storyflow__add-briefing-comment` to add a comment on the briefing noting that an implementation plan has been generated. Include the plan file path.

8. **Present results**: Show the user:
   - Summary of the generated plan (phases, story coverage)
   - Location of the saved plan file
   - Next steps:
     - "Review the plan at `docs/plans/<filename>.md`"
     - "Use `/implement-plan` to execute the plan phase by phase"
     - "To mark stories as done, use the `transition-story` MCP tool with transition `complete`"
