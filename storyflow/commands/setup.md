---
name: storyflow-setup
description: Configure StoryFlow plugin for the current project. Links this project to a specific customer and asset in StoryFlow.
allowed-tools: mcp__storyflow__get-current-user, mcp__storyflow__get-asset-by-url, mcp__storyflow__list-assets, Read, Write, Glob, AskUserQuestion, Bash(git remote get-url origin)
---

# StoryFlow Setup

Configure the StoryFlow plugin for this project by linking it to a customer and asset.

## Process

1. **Verify connection**: Call `get-current-user` to verify MCP connection and authentication. If it fails, guide the user:

   **a)** They need to authenticate first. Run:
   ```
   claude mcp auth storyflow
   ```
   This opens their browser to sign in to StoryFlow. Once approved, credentials are stored automatically.

   **b)** If connection still fails, check that the plugin's MCP server is loaded. Run `/mcp` to verify the "storyflow" server appears.

   On success, greet the user by name (from the response) and confirm the connection works.

2. **Auto-detect asset**: Run `git remote get-url origin` to get the repository URL. Then call `get-asset-by-url` with that URL.

   - **If a match is found**: Show the asset name, customer, and type. Ask the user to confirm this is correct.
   - **If no match**: Fall back to step 3.

3. **Manual asset selection** (only if auto-detect failed or user rejected the match): Call `list-assets` and present the available assets. Ask the user which asset this codebase represents. If none match, suggest they add the asset in StoryFlow first with the correct repository URL.

4. **Create config file**: Create the `.storyflow/` directory if it doesn't exist, then write `.storyflow/config.json`:

```json
{
  "version": 1,
  "project": {
    "customer_id": "<customer-uuid>",
    "customer_name": "<customer-name>",
    "asset_id": "<asset-uuid>",
    "asset_name": "<asset-name>"
  }
}
```

5. **Verify .gitignore**: Read the project's `.gitignore` and check that `.storyflow/` is listed. If not, suggest adding it (the config contains project-specific IDs that should not be committed).

6. **Confirm**: Tell the user setup is complete. Suggest starting a new session to see the SessionStart context, and using `/storyflow:briefings` to see available work.
