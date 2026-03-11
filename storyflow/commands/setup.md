---
name: storyflow-setup
description: Configure StoryFlow plugin for the current project. Links this project to a specific customer and asset in StoryFlow.
allowed-tools: mcp__storyflow__list-briefings, mcp__storyflow__list-stories, Read, Write, Glob, AskUserQuestion
---

# StoryFlow Setup

Configure the StoryFlow plugin for this project by linking it to a customer and asset.

## Process

1. **Test MCP connection**: Call `mcp__storyflow__list-briefings` to verify the StoryFlow MCP server is reachable. If it fails, inform the user they need to:
   - Ensure StoryFlow is running
   - Set `STORYFLOW_PAT` environment variable with a valid Personal Access Token
   - Check that `.mcp.json` has the storyflow server configured

2. **Identify customer**: From the briefings response, extract the available customers. Ask the user which customer this project belongs to. Show customer names and IDs.

3. **Identify asset**: Ask the user which asset (application/project) this codebase represents. If unsure, suggest they check StoryFlow's asset management.

4. **Create config file**: Write `.claude/storyflow.local.md` with the following format:

```markdown
---
customer_id: "<selected-customer-uuid>"
customer_name: "<selected-customer-name>"
asset_id: "<selected-asset-uuid>"
asset_name: "<selected-asset-name>"
---

# StoryFlow Context
This project is linked to <customer_name>'s <asset_name> asset in StoryFlow.
When browsing briefings, filter by this customer. When creating plans, use this asset context.
```

5. **Verify .gitignore**: Read the project's `.gitignore` and check that `.claude/*.local.md` is listed. If not, append it.

6. **Confirm**: Tell the user setup is complete. Suggest starting a new session to see the SessionStart context, and using `/storyflow:briefings` to see available work.
