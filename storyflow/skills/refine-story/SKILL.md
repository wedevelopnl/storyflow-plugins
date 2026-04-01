---
name: refine-story
description: "Run multi-agent refinement analysis on a single story. Fetches refinement guidelines (agent perspectives, scoring, synthesis approach) from the ai-service, dispatches parallel subagents per perspective, synthesizes results, and saves via MCP."
disable-model-invocation: true
allowed-tools: mcp__storyflow__get-story, mcp__storyflow__get-briefing, mcp__storyflow__get-refinement-guidelines, mcp__storyflow__refine-story, mcp__storyflow__transition-story, Read, Grep, Glob, Agent
argument-hint: "<story-id>"
---

# Refine a Single Story

Run multi-agent refinement analysis on a story and save the results.

## Arguments

The user provides a story ID as argument: `/storyflow:refine-story <id>`

If no ID is provided, ask the user for one. Suggest loading a briefing first with `/storyflow:briefing <id>` to see available stories.

## Process

### Step 1: Setup

1. **Load project context**: Read `.storyflow/config.json`.
   - If file exists: extract `customer_name`, `asset_name`, `customer_id`, `asset_id`.
   - If file does not exist: continue without. Suggest `/storyflow:setup`.

2. **Fetch story**: Call `mcp__storyflow__get-story` with the provided ID.

3. **Check existing refinement**: If the story already has refinement data:
   - Show existing summary (complexity, risk, concern count, story points).
   - Ask: "This story already has refinement data. Re-refine? Existing data will be overwritten."
   - If user declines, stop.

4. **Load briefing context**: If the story belongs to a briefing, call `mcp__storyflow__get-briefing` for broader context.

### Step 2: Fetch Refinement Guidelines

Call `mcp__storyflow__get-refinement-guidelines`. This returns the complete refinement context:
- **Output Format**: MCP tool parameters and structure
- **Scoring & Synthesis Approach**: How to assess complexity, risk, story points, and how to synthesize agent results (from the Tech Lead prompt)
- **Agent Perspectives**: The actual prompts for Backend Engineer, Frontend Engineer, Security Expert, QA Engineer, and DevOps Engineer

These guidelines are the single source of truth: the same prompts used by the in-app refinement system.

### Step 3: Triage

Based on the story description, determine which agent perspectives to use:

| Perspective | When to include |
|-------------|----------------|
| Backend Engineer | API changes, domain logic, data model changes, backend processing |
| Frontend Engineer | UI changes, new pages, forms, user interactions |
| Security Expert | Authorization, data access, user roles, sensitive data |
| QA Engineer | Always include |
| DevOps Engineer | Database migrations, configuration changes, infrastructure |

Typical selections:
- Pure backend: Backend + Security + QA + DevOps
- Pure frontend: Frontend + QA
- Full-stack: all five
- Simple UI change: Frontend + QA

### Step 4: Dispatch Subagents

Launch **parallel Explore subagents**, one per selected perspective. Each subagent receives:

1. The agent perspective prompt (extracted from the guidelines response)
2. The story and briefing context
3. Instructions to explore the codebase

Use this prompt template for each subagent:

```
You are analyzing a story from a specific engineering perspective.

## Your Perspective

{agent perspective prompt from guidelines}

## Story Context

{story title, description, acceptance criteria, briefing context}

## Instructions

1. Explore the codebase to understand the current architecture and patterns
2. Analyze the story from your perspective
3. Return your analysis in this format:
   - complexity: low | medium | high | very_high
   - risk: low | medium | high
   - concerns: list of {severity, theme, description}
   - summary: 2-3 sentence summary of key findings
```

### Step 5: Synthesize

Follow the **Scoring & Synthesis Approach** from the guidelines to combine all subagent results:

1. **Complexity**: Use the median rating. If disagreement, lean lower unless concrete justification.
2. **Risk**: Take the highest (risk is asymmetric).
3. **Story Points**: Follow the baseline-3 deflationary model from the guidelines.
4. **Report**: Write unified report following the report structure from the guidelines.
5. **Concerns**: Merge and deduplicate. Sort by severity (critical first).

### Step 6: Save & Report

1. Call `mcp__storyflow__refine-story` with the synthesized results.

2. Display results:
   ```
   # Refinement Complete: [story title]

   Complexity: [complexity] | Risk: [risk] | Story Points: [points]
   Concerns: [count] ([critical] critical, [warning] warning, [info] info)

   [Brief summary of key findings]
   ```

3. Fetch the story again via `get-story` and suggest available transitions.
