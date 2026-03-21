---
name: storyflow-briefings
description: List available briefings from StoryFlow, grouped by status. Highlights briefings ready to claim (Approved).
allowed-tools: mcp__storyflow__list-briefings, Read
---

# List StoryFlow Briefings

Show briefings for the configured asset, highlighting what needs attention.

## Process

1. **Load config** (required): Read `.storyflow/config.json` to get `customer_id`, `customer_name`, `asset_id`, and `asset_name`.
   - If the file does not exist: tell the user to run `/storyflow:setup` first. Do not proceed without config, since you need to know which customer and asset you are working on.

2. **Fetch briefings**: Call `mcp__storyflow__list-briefings` with `customerId` and `assetId` from config to get briefings for this specific asset.

3. **Display briefings**, grouped by status in this order (skip empty groups):

   ```
   # Briefings for [asset_name] ([customer_name])

   ## In Progress
   [Briefings currently being worked on, show assigned architect]

   ## Approved
   [Ready to claim by a Software Architect]

   ## Priced
   [Stories priced, awaiting customer approval]

   ## Refined
   [Stories refined, next step is pricing]

   ## Scoped
   [Stories created, next step is refinement]

   ## Accepted
   [Accepted by agency, next step is scoping into stories]

   ## Submitted
   [Submitted by customer, awaiting agency review]

   ## Done / Cancelled / Archived
   [Completed or closed briefings]
   ```

4. **Format each briefing** as:
   ```
   [Key] [Title]
   Status: [status] | Architect: [name or unassigned] | Stories: [count if available]
   ```

5. **Suggest next steps** based on what is shown:
   - If there are **Approved** briefings: "Use `/storyflow:claim-briefing <key>` to claim a briefing"
   - If there are **In Progress** briefings: "Use `/storyflow:briefing <key>` to see progress"
   - If there are briefings in intermediate statuses (Refined, Scoped, etc.): "Use `/storyflow:briefing <key>` to see details and what is needed next"
   - If no briefings exist for this asset: "No briefings found for [asset_name]. Check the StoryFlow UI or ask the customer to create a briefing."
