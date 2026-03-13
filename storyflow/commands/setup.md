---
name: storyflow-setup
description: Configure StoryFlow plugin for the current project. Links this project to a specific customer and asset in StoryFlow.
allowed-tools: mcp__storyflow__get-current-user, mcp__storyflow__find-asset-by-repository-url, mcp__storyflow__list-assets, Read, Write, Glob, AskUserQuestion, Bash(git remote get-url origin)
---

# StoryFlow Setup

Configure the StoryFlow plugin for this project by linking it to a customer and asset.

## Process

1. **Verify connection**: Call `get-current-user` to verify MCP connection and authentication. If it fails, guide the user:

   **a)** Check that `STORYFLOW_PAT` is set as an environment variable. They need to:
   - Log in to https://app.storyflowhq.com/profile
   - Create a Personal Access Token under "Access Tokens"
   - Add `export STORYFLOW_PAT="sf_pat_..."` to their shell profile (`~/.zshrc` or `~/.bashrc`)
   - Restart their terminal and Claude Code session

   **b)** If the env var is set but connection still fails, check that the plugin's MCP server is loaded. Run `/mcp` to verify the "storyflow" server appears.

   On success, greet the user by name (from the response) and confirm the connection works.

2. **Auto-detect asset**: Run `git remote get-url origin` to get the repository URL. Then call `find-asset-by-repository-url` with that URL.

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
