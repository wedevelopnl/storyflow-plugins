---
name: list-briefings
description: "Shows briefings for the configured asset, grouped by status. Highlights briefings ready to claim (Accepted). Use when the user asks to see available work, list briefings, or check what needs attention."
allowed-tools: mcp__storyflow__list-briefings, Read
argument-hint: ""
---

# List StoryFlow Briefings

Show briefings for the configured asset, highlighting what needs attention.

## Process

1. **Load config** (required): Read `.storyflow/config.json` to get `customer_id`, `customer_name`, `asset_id`, and `asset_name`.
   - If the file does not exist: tell the user to run `/storyflow:setup` first. Do not proceed without config, since you need to know which customer and asset you are working on.

2. **Fetch briefings**: Call `mcp__storyflow__list-briefings` with `customerId` and `assetId` from config to get briefings for this specific asset.

3. **Display briefings**, grouped by status. The MCP response includes the status of each briefing and its available transitions. Group briefings by their status, ordered by actionability (briefings that need attention first). Skip empty groups.

   A briefing is a "ready to claim" candidate when its status is `Accepted` and no architect is assigned yet. Briefings later in the lifecycle (`Scoped`, `Refined`, `Priced`, `ToDo`, `Doing`) are already being worked on (their status projects from the linked stories).

   ```
   # Briefings for [asset_name] ([customer_name])

   ## [Status Group]
   [Key] [Title]
   Status: [status] | Architect: [name or unassigned] | Stories: [count if available]
   Available actions: [list transition labels from MCP response]
   ```

4. **Suggest next steps** based on what is shown:
   - For briefings with available transitions: suggest `/storyflow:briefing <key>` to see full details and act on the transitions
   - If no briefings exist for this asset: "No briefings found for [asset_name]. Check the StoryFlow UI or ask the customer to create a briefing."
