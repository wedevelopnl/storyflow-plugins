# StoryFlow Plugin for Claude Code

Connect Claude Code to the StoryFlow platform so Software Architects can browse briefings, claim work, and generate implementation plans without leaving the terminal.

## What it does

- **Browse briefings**: View available client briefings grouped by status directly in your terminal.
- **Claim and implement**: Claim approved briefings and generate structured implementation plans from the stories they contain.
- **Load story context**: Pull individual story details into your session for reference while coding.
- **Generate documentation**: Create or update functional and technical asset documentation from the current codebase.

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and running
- A StoryFlow account with an agency role (Software Architect, PO, Admin, or Finance)

## Installation

### 1. Add the marketplace

```
/plugin marketplace add wedevelopnl/storyflow-plugins
```

### 2. Install the plugin

```
/plugin install storyflow@storyflow-plugins
```

### 3. Authenticate with StoryFlow

Run the following command to authenticate via your browser:

```
claude mcp auth storyflow
```

This opens your browser where you sign in to StoryFlow. Once approved, Claude Code stores the credentials automatically.

### 4. Configure your project

Start Claude Code in your project directory and run:

```
/storyflow:setup
```

This links the current codebase to a specific customer and asset in StoryFlow.

### Alternative: Personal Access Token (PAT)

For non-interactive scenarios (CI/CD, scripts), you can use a Personal Access Token instead of OAuth:

1. Log in to [StoryFlow](https://app.storyflowhq.com/profile) and create a token under **Profile > Access Tokens**
2. Set the environment variable in your shell profile:

```bash
export STORYFLOW_PAT="sf_pat_your_token_here"
```

3. Update `.mcp.json` in the plugin to include the token header:

```json
{
  "storyflow": {
    "type": "http",
    "url": "https://api.storyflowhq.com/_mcp",
    "headers": {
      "Authorization": "Bearer ${STORYFLOW_PAT}"
    }
  }
}
```

## Commands

| Command | Description |
|---------|-------------|
| `/storyflow:briefings` | List available briefings for your customer |
| `/storyflow:briefing <id>` | Load full briefing context (description, documents, stories) |
| `/storyflow:claim-briefing <id>` | Claim an approved briefing for implementation |
| `/storyflow:briefing-to-stories <id>` | Generate user stories from an accepted briefing |
| `/storyflow:implement-briefing <id>` | Generate an implementation plan from briefing and stories |
| `/storyflow:story <id>` | Load individual story details |
| `/storyflow:complete-story <id>` | Mark an in-progress story as complete |
| `/storyflow:update-docs [type]` | Generate or update asset documentation (`functional`, `technical`, or `both`) |
| `/storyflow:setup` | Configure plugin for the current project |

## Skills

Skills are loaded automatically when relevant context is detected:

- **storyflow-workflow**: Triggers on briefing/story lifecycle questions. Provides knowledge about statuses, transitions, and roles.
- **briefing-to-plan**: Triggers when converting briefings to implementation plans. Guides story sequencing and plan structure.
- **generate-stories**: Triggers when generating user stories from briefings. Covers story format, complexity sizing, priority assessment, and acceptance criteria.
- **asset-documentation**: Triggers when generating or updating asset documentation. Guides the documentation workflow.

## Agents

- **briefing-planner**: Dedicated agent that explores the local codebase and generates an implementation plan from briefing data. Invoked automatically by `/storyflow:implement-briefing`. Uses Opus for plan quality.

## Workflow

A typical session for a Software Architect:

1. `/storyflow:briefings` to see available work
2. `/storyflow:briefing <id>` to review a specific briefing
3. `/storyflow:claim-briefing <id>` to claim it
4. `/storyflow:implement-briefing <id>` to generate an implementation plan
5. `/implement-plan` to execute the plan (requires superpowers plugin)
6. `/storyflow:complete-story <id>` to mark stories as done

## How it works

The plugin uses MCP (Model Context Protocol) to connect to the StoryFlow API. Authentication is handled via OAuth 2.1: Claude Code automatically manages the token lifecycle through the standard MCP OAuth flow. All communication goes through the MCP server bundled with the plugin.
