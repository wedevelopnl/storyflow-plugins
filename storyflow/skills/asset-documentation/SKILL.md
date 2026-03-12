---
name: Asset Documentation
description: "This skill should be used when the user asks to generate, update, or refresh asset documentation (functional or technical) for a project linked to StoryFlow. Also relevant when asking about documenting an application, creating a functional overview, generating a technical landscape, or updating docs in StoryFlow."
---

# Asset Documentation via Claude Code

Generate or update asset documentation directly from the current codebase, without ai-service token costs.

## When This Applies

- User asks to generate or update documentation for the current project
- User mentions functional documentation, technical documentation, or technical landscape
- User wants to refresh documentation after code changes

## What To Do

Direct the user to the `/storyflow:update-docs` command:

- `/storyflow:update-docs` to generate both functional and technical documentation
- `/storyflow:update-docs functional` for functional documentation only
- `/storyflow:update-docs technical` for technical documentation only

## Prerequisites

The project must be linked to a StoryFlow asset via `/storyflow:setup` (which creates `.storyflow/config.json` with the `asset_id`).

## How It Works

1. The command reads the asset ID from `.storyflow/config.json`
2. It fetches the generation prompt from the ai-service (same prompts used by the web UI)
3. Claude Code analyzes the codebase locally (no repo clone needed)
4. The generated documentation is saved to StoryFlow via MCP tools
5. Documentation becomes visible in StoryFlow's asset documentation view
