---
name: storyflow-update-docs
description: Generate or update asset documentation (functional/technical) from the current codebase and save it to StoryFlow.
allowed-tools: mcp__storyflow__get-asset-documentation, mcp__storyflow__save-asset-documentation, mcp__storyflow__get-documentation-prompt, mcp__storyflow__list-assets, Read, Glob, Grep, Bash, Agent, AskUserQuestion
---

# Update Asset Documentation

Generate or update asset documentation from the current codebase via Claude Code, then save it to StoryFlow. This avoids ai-service token costs for developers with a Claude Code Max subscription.

## Arguments

Optional argument specifying documentation type: `functional`, `technical`, or `both` (default: `both`).

Examples:
- `/storyflow:update-docs` (generates both types)
- `/storyflow:update-docs functional`
- `/storyflow:update-docs technical`

## Process

1. **Read config**: Read `.storyflow/config.json` to get the `asset_id`.
   - If the file does not exist or has no `asset_id`, tell the user to run `/storyflow:setup` first and stop.
   - Extract `asset_id` and `asset_name` from `project.asset_id` and `project.asset_name` in the JSON config.

2. **Get commit hash**: Run `git rev-parse HEAD` via Bash to get the current commit hash.

3. **Parse argument**: Determine which types to generate from the user's argument. Default to `both` if no argument provided.

4. **For each documentation type** (functional, technical, or both):

   a. **Check existing docs**: Call `mcp__storyflow__get-asset-documentation` with the asset ID and type.
      - Note the existing content and last commit hash (if any) for context.

   b. **Get generation prompt**: Call `mcp__storyflow__get-documentation-prompt` with the type.
      - This returns the same prompt instructions the ai-service uses internally.

   c. **Generate documentation**: Using the prompt instructions from step (b), analyze the codebase thoroughly:
      - Use Glob and Grep to explore the project structure
      - Read key files (README, config files, main entry points, route definitions, etc.)
      - Use an Agent (subagent_type: "Explore") for deeper codebase exploration if needed
      - Follow the prompt instructions to produce comprehensive markdown documentation
      - If existing documentation was found in step (a), use it as a reference for what to update/improve

   d. **Save documentation**: Call `mcp__storyflow__save-asset-documentation` with:
      - `assetId`: from the config
      - `type`: the documentation type
      - `content`: the generated markdown
      - `lastCommitHash`: from step 2

5. **Report results**: Show the user:
   - Which documentation types were generated/updated
   - The commit hash it was generated from
   - That the documentation is now visible in StoryFlow's asset documentation view
