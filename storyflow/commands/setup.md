---
name: storyflow-setup
description: Configure StoryFlow plugin for the current project. Links this project to a specific customer and asset in StoryFlow.
allowed-tools: mcp__storyflow__list-briefings, mcp__storyflow__list-stories, Read, Write, Glob, AskUserQuestion, Bash
---

# StoryFlow Setup

Configure the StoryFlow plugin for this project by linking it to a customer and asset.

## Process

1. **Test MCP connection**: Call `mcp__storyflow__list-briefings` to verify the StoryFlow MCP server is reachable. If it fails, guide the user through these steps:

   **a)** Check that `STORYFLOW_PAT` is set as an environment variable. They need to:
   - Log in to https://app.storyflowhq.com/profile
   - Create a Personal Access Token under "Access Tokens"
   - Add `export STORYFLOW_PAT="sf_pat_..."` to their shell profile (`~/.zshrc` or `~/.bashrc`)
   - Restart their terminal and Claude Code session

   **b)** If the env var is set but connection still fails, check that the plugin's MCP server is loaded. Run `/mcp` to verify the "storyflow" server appears.

2. **Identify customer**: From the briefings response, extract the available customers. Ask the user which customer this project belongs to. Show customer names and IDs.

3. **Identify asset**: Ask the user which asset (application/project) this codebase represents. If unsure, suggest they check StoryFlow's asset management.

4. **Create config file**: Create the `.storyflow/` directory if it doesn't exist, then write `.storyflow/config.json`:

```json
{
  "version": 1,
  "project": {
    "customer_id": "<selected-customer-uuid>",
    "customer_name": "<selected-customer-name>",
    "asset_id": "<selected-asset-uuid>",
    "asset_name": "<selected-asset-name>"
  }
}
```

5. **Verify .gitignore**: Read the project's `.gitignore` and check that `.storyflow/` is listed. If not, suggest adding it (the config contains project-specific IDs that should not be committed).

6. **Confirm**: Tell the user setup is complete. Suggest starting a new session to see the SessionStart context, and using `/storyflow:briefings` to see available work.
