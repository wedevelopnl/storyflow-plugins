---
name: storyflow-claim
description: Claim an approved briefing for implementation. Transitions the briefing to InProgress and assigns you as the implementing Software Architect.
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__claim-briefing, Read
---

# Claim a Briefing

Claim an approved briefing so you can start implementing its stories.

## Arguments

The user provides a briefing ID as argument: `/storyflow:claim-briefing <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` to see available briefings.

## Process

1. **Load project context** (required): Read `.storyflow/config.json` to get `customer_name`, `asset_name`, `customer_id`, `asset_id`.
   - If the file does not exist: tell the user to run `/storyflow:setup` first. Do not proceed without config.

2. **Fetch briefing**: Call `mcp__storyflow__get-briefing` with the provided ID to verify it exists and check its status.

3. **Safety check**: Verify the briefing's asset matches the configured asset. If they don't match, warn the user: "This briefing belongs to [briefing asset], but this project is configured for [asset_name]. Are you sure you want to proceed?"

4. **Verify status**: The briefing must be in **Approved** status to be claimed.
   - If not Approved, inform the user of the current status and explain what needs to happen first.
   - If Approved, proceed to claim.

5. **Confirm with user**: Before claiming, show:
   ```
   About to claim briefing:
   Title: [title]
   Customer: [customer]
   Asset: [asset]

   This will transition the briefing to InProgress and assign you as the implementer.
   Proceed? (yes/no)
   ```

6. **Claim briefing**: Call `mcp__storyflow__claim-briefing` with the briefing ID.

7. **Confirm success**: Show confirmation and suggest next steps:
   - "Briefing claimed successfully. You are now the assigned Software Architect."
   - "Next: Use `/storyflow:implement-briefing <id>` to generate an implementation plan."
   - "Or use `/storyflow:briefing <id>` to review the full context first."
