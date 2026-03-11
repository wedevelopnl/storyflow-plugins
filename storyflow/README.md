# StoryFlow Plugin for Claude Code

Brings StoryFlow's briefing context directly into the local Claude Code development environment, so Software Architects can browse briefings, claim work, and generate implementation plans without leaving their terminal.

## Prerequisites

- A running StoryFlow instance with MCP endpoint enabled
- A Personal Access Token (PAT) for authentication
- Environment variables: `STORYFLOW_URL` and `STORYFLOW_PAT`

When used within the StoryFlow monorepo, the root `.mcp.json` already configures the MCP server.

## Setup

1. Install the plugin in your project
2. Run `/storyflow:setup` to link your project to a StoryFlow customer and asset
3. Start a new session to see the StoryFlow context reminder

## Commands

| Command | Description |
|---------|-------------|
| `/storyflow:briefings` | List available briefings for your customer |
| `/storyflow:briefing <id>` | Load full briefing context (description, documents, stories) |
| `/storyflow:claim-briefing <id>` | Claim an approved briefing for implementation |
| `/storyflow:implement-briefing <id>` | Generate an implementation plan from briefing + stories |
| `/storyflow:story <id>` | Load individual story details |
| `/storyflow:complete-story <id>` | Mark an in-progress story as complete |
| `/storyflow:setup` | Configure plugin for current project |

## Skills

- **storyflow-workflow**: Auto-triggers on briefing/story lifecycle questions. Provides knowledge about statuses, transitions, and roles.
- **briefing-to-plan**: Auto-triggers when converting briefings to implementation plans. Guides story sequencing and plan structure.

## Agents

- **briefing-planner**: Dedicated agent that explores the local codebase and generates an implementation plan from briefing data. Uses Opus for plan quality.

## Workflow

A typical workflow for a Software Architect:

1. `/storyflow:briefings` to see available work
2. `/storyflow:briefing <id>` to review a specific briefing
3. `/storyflow:claim-briefing <id>` to claim it
4. `/storyflow:implement-briefing <id>` to generate an implementation plan
5. `/implement-plan` to execute the plan (if superpowers plugin is installed)
6. `/storyflow:complete-story <id>` to mark stories as done
