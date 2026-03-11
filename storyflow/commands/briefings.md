---
name: storyflow-briefings
description: List available briefings from StoryFlow, grouped by status. Highlights briefings ready to claim (Approved).
allowed-tools: mcp__storyflow__list-briefings, Read
---

# List StoryFlow Briefings

Show available briefings from StoryFlow, highlighting work ready to be claimed.

## Process

1. **Load config**: Read `.claude/storyflow.local.md` to get the `customer_id`. If the file doesn't exist, tell the user to run `/storyflow:setup` first.

2. **Fetch briefings**: Call `mcp__storyflow__list-briefings`. If a customer_id is available from config, mention it in the context so results are relevant.

3. **Display briefings grouped by status**: Organize results into these groups, in this order:
   - **Ready to Claim** (status: Approved): These are available for a Software Architect to pick up. Highlight these prominently.
   - **In Progress**: Currently being worked on.
   - **Other statuses**: Group remaining briefings by their status.

4. **Format each briefing** as:
   ```
   [ID] Title - Customer Name
   Asset: asset name | Stories: N | Status: status
   ```

5. **Suggest next steps**:
   - For Approved briefings: "Use `/storyflow:briefing <id>` to see details, then `/storyflow:claim-briefing <id>` to claim it"
   - For InProgress briefings: "Use `/storyflow:briefing <id>` to see current progress"

If no briefings are found, let the user know and suggest checking the StoryFlow UI for filters or permissions.
