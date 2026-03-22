---
name: storyflow-briefing
description: Load full context for a specific briefing, including its stories, documents, and conversation.
allowed-tools: mcp__storyflow__get-briefing, mcp__storyflow__get-briefing-stories, mcp__storyflow__add-briefing-comment, Read
---

# Load Briefing Context

Fetch and display a briefing as a smart dashboard: full context with status-aware next steps.

## Arguments

The user provides a briefing ID as argument: `/storyflow:briefing <id>`

If no ID is provided, ask the user for one. Suggest running `/storyflow:briefings` first to see available briefings.

## Process

1. **Load project context**: Read `.storyflow/config.json`.
   - If file exists: extract `customer_name`, `asset_name`, `customer_id`, `asset_id` for context.
   - If file does not exist: continue without context. Suggest running `/storyflow:setup` for a better experience.

2. **Fetch briefing and stories in parallel**:
   - Call `mcp__storyflow__get-briefing` with the provided ID.
   - Call `mcp__storyflow__get-briefing-stories` with the briefing ID.

   Do NOT call `get-story` for individual stories. The stories list already contains status, priority, price, complexity, and risk. Use `/storyflow:story <key>` when the user wants to dive into a specific story.

3. **Display briefing dashboard**:

   If config was loaded and the briefing's asset does not match `asset_name` from config, show a warning:
   "Note: this briefing belongs to asset [briefing asset], not the configured asset [asset_name]."

   ```
   # Briefing: [Key] - [Title]
   Status: [status] | Customer: [customer] | Asset: [asset] | Project: [project]
   Architect: [assigned name or "unassigned"] | Created: [date] | Updated: [date]

   ## Briefing Document
   [Show the full briefing document content as returned by get-briefing.
    This is the functional specification from the Virtual PO chat,
    not a list of file attachments.]

   ## Stories ([count])

   | # | Story | Status | Priority | Price | Complexity | Risk |
   |---|-------|--------|----------|-------|------------|------|
   | [key] | [title] | [status] | [priority] | [price or -] | [complexity or -] | [risk or -] |

   ## Next Steps
   [Status-aware guidance, see below]
   ```

4. **Status-aware next steps**:

   - **Draft**: "This briefing is still being drafted. The customer is working with the Virtual PO to finalize requirements."

   - **Submitted**: "This briefing has been submitted by the customer and is awaiting review and acceptance."

   - **Accepted**: "This briefing has been accepted and needs to be scoped into stories. Use `/storyflow:briefing-to-stories [id]` to generate stories."

   - **Scoped**: "Stories have been created. Next step is to refine them. Use `/storyflow:refine-briefing [id]` to run multi-agent refinement on all stories."

   - **Refined**: "All stories have been refined. Next step is to price the individual stories and then finalize pricing to move the briefing to **priced** status."
     - List unpriced stories if any: "Unpriced stories: [keys]"
     - "Use `/storyflow:story <key>` to view story details."

   - **Priced**: "All stories are priced. The briefing is ready to be approved by the customer. After approval, a Software Architect can claim it."

   - **Approved**: "This briefing is approved and ready to be claimed."
     - "Claim this briefing: `/storyflow:claim-briefing [id]`"
     - "Generate an implementation plan: `/storyflow:implement-briefing [id]`"

   - **InProgress**: "This briefing is in progress, assigned to [architect name]."
     - "View a story: `/storyflow:story <key>`"
     - "Generate/update implementation plan: `/storyflow:implement-briefing [id]`"
     - "Mark a story as done: use the `transition-story` MCP tool with transition `complete`"

   - **Done**: "This briefing has been completed."

   - **Cancelled**: "This briefing has been cancelled."

   - **Archived**: "This briefing has been archived."

   Always end with: "Use `/storyflow:story <key>` to dive into a specific story's full details, acceptance criteria, and refinement analysis."
