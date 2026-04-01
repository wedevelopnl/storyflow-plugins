---
name: refine-briefing
description: "Run multi-agent refinement analysis on all stories within a briefing. Filters stories by status (in_review by default), confirms scope with the user, then refines each story using parallel subagents per engineering perspective. Guidelines are fetched once from the ai-service and reused across all stories."
disable-model-invocation: true
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__get-story, mcp__storyflow__get-refinement-guidelines, mcp__storyflow__refine-story, mcp__storyflow__transition-story, Read, Grep, Glob, Agent
argument-hint: "<briefing-id>"
---

# Refine All Stories in a Briefing

Run multi-agent refinement analysis on all stories within a briefing.

## Arguments

The user provides a briefing ID as argument: `/storyflow:refine-briefing <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` to see available briefings.

## Process

1. **Load project context**: Read `.storyflow/config.json`.
   - If file exists: extract `customer_name`, `asset_name`, `customer_id`, `asset_id` for context.
   - If file does not exist: continue without context. Suggest running `/storyflow:setup` for a better experience.

2. **Fetch briefing**: Call `mcp__storyflow__get-briefing` with the provided ID.

3. **Fetch stories**: Call `mcp__storyflow__get-briefing-stories` with the briefing ID.

4. **Load story details**: For each story returned, call `mcp__storyflow__get-story` to get full details. Run these calls in parallel where possible.

5. **Filter stories**: By default, select stories in `in_review` status. If the user explicitly asked for re-refinement, also include stories that already have refinement data (any status with existing complexity/risk/report).

6. **Confirm scope**: Show the user what will be refined:
   ```
   # Briefing: [title]
   Stories to refine: [count]

   | # | Story | Status | Existing Refinement |
   |---|-------|--------|-------------------|
   | 1 | [title] | [status] | [yes/no] |
   | 2 | [title] | [status] | [yes/no] |

   Proceed with refinement? (yes/no)
   ```

   If no stories match the filter, inform the user and suggest alternatives.

7. **Fetch refinement guidelines** (once): Call `mcp__storyflow__get-refinement-guidelines`. This returns the complete refinement context: output format, scoring approach, and all agent perspectives. These are the same prompts used by the in-app refinement system. Reuse this response for all stories.

8. **Refine each story**: For each story, follow the refinement process from the `refine-story` skill (Steps 3-6): triage perspectives, dispatch parallel Explore subagents with agent prompts from the guidelines, synthesize, and save via MCP. Show progress: "Refining story [n]/[total]: [title]..."

9. **Show summary table**: After all stories are refined:
   ```
   # Refinement Summary: [briefing title]

   | Story | Complexity | Risk | SP | Concerns |
   |-------|-----------|------|----|----------|
   | [title] | [complexity] | [risk] | [points] | [count] |

   Total: [count] stories refined
   Critical concerns: [count across all stories]
   ```

10. **Suggest next steps**:
    - For each refined story, fetch its available transitions via `get-story` and suggest the appropriate next action
    - Fetch the briefing again to check if new transitions are available after refinement, and suggest the next briefing-level action
