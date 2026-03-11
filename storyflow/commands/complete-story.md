---
name: storyflow-complete
description: Mark an in-progress story as done. Optionally adds a completion note as an internal comment.
allowed-tools: mcp__storyflow__get-story, mcp__storyflow__transition-story, mcp__storyflow__add-story-comment, AskUserQuestion
---

# Complete a Story

Mark a story as done after implementation is complete.

## Arguments

The user provides a story ID as argument: `/storyflow:complete-story <id>`

If no ID is provided, ask the user for one.

## Process

1. **Fetch story**: Call `mcp__storyflow__get-story` with the provided ID to verify it exists and check its status.

2. **Verify status**: The story must be in **in_progress** (InProgress) status.
   - If not InProgress, inform the user of the current status and explain what needs to happen.
   - If InProgress, proceed.

3. **Ask for completion note**: Ask the user if they want to add a completion note. This is optional but recommended for team communication.
   - Suggest including: what was implemented, any notable decisions, test coverage.

4. **Add comment** (if provided): Call `mcp__storyflow__add-story-comment` with the completion note. Mark it as an internal comment.

5. **Transition story**: Call `mcp__storyflow__transition-story` with the story ID and action `complete`.

6. **Confirm success**: Show confirmation:
   ```
   Story "[title]" marked as complete.
   [If comment was added: Completion note added.]
   ```

7. **Check remaining stories**: If the story belongs to a briefing, mention how many stories remain in that briefing (if this information is available from the story data).
