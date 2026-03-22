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
/plugin marketplace add wedevelopnl/storyflow-marketplace
```

### 2. Install the plugin

```
/plugin install storyflow@storyflow-marketplace
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

## Commands

| Command | Description |
|---------|-------------|
| `/storyflow:briefings` | List briefings for the configured asset, grouped by status |
| `/storyflow:briefing <id>` | Smart briefing dashboard with status-aware next steps |
| `/storyflow:claim-briefing <id>` | Claim an approved briefing for implementation |
| `/storyflow:briefing-to-stories <id>` | Generate user stories from an accepted briefing |
| `/storyflow:implement-briefing <id>` | Generate an implementation plan from briefing and stories |
| `/storyflow:story <id>` | Load individual story details |
| `/storyflow:refine-story <id>` | Refine a single story with multi-agent analysis |
| `/storyflow:refine-briefing <id>` | Refine all stories of a briefing with multi-agent analysis |
| `/storyflow:update-docs [type]` | Generate or update asset documentation (`functional`, `technical`, or `both`) |
| `/storyflow:setup` | Configure plugin for the current project |

## Skills

Skills are loaded automatically when relevant context is detected:

- **storyflow-workflow**: Triggers on briefing/story lifecycle questions. Provides knowledge about statuses, transitions, roles, and refinement.
- **briefing-to-plan**: Triggers when converting briefings to implementation plans. Guides story sequencing and plan structure.
- **write-story**: Triggers when writing user stories. Covers story format, language guardrails, acceptance criteria, complexity sizing, and priority assessment.
- **refinement-output**: Defines the output structure for story refinement analysis (complexity, risk, report, concerns).
- **asset-documentation**: Triggers when generating or updating asset documentation. Guides the documentation workflow.

## Agents

- **briefing-planner**: Dedicated agent that explores the local codebase and generates an implementation plan from briefing data. Invoked automatically by `/storyflow:implement-briefing`. Uses Opus for plan quality.
- **codebase-analyzer**: Analyzes a codebase from a functional perspective to support story generation. Explores the current project to understand what the application offers and which workflows will be affected by the briefing.
- **refinement-lead**: Orchestrates story refinement by triaging which specialists are needed, dispatching them in parallel, and synthesizing results into a final refinement analysis.
- **refinement-backend**: Backend specialist analyzing API design, data models, domain logic, and database impact.
- **refinement-frontend**: Frontend specialist analyzing UI components, state management, forms, and UX patterns.
- **refinement-devops**: DevOps specialist analyzing migrations, configuration, deployment, and monitoring.
- **refinement-qa**: QA specialist analyzing testability, edge cases, regression impact, and test coverage.
- **refinement-security**: Security specialist analyzing authorization, multi-tenancy isolation, and data protection.

## Workflow

A typical session for a Software Architect:

1. `/storyflow:briefings` to see available work
2. `/storyflow:briefing <id>` to review a specific briefing
3. `/storyflow:claim-briefing <id>` to claim it
4. `/storyflow:implement-briefing <id>` to generate an implementation plan
5. `/implement-plan` to execute the plan (requires superpowers plugin)
6. Mark stories as done via the `transition-story` MCP tool

## How it works

The plugin uses MCP (Model Context Protocol) to connect to the StoryFlow API. Authentication is handled via OAuth 2.1: Claude Code automatically manages the token lifecycle through the standard MCP OAuth flow. All communication goes through the MCP server bundled with the plugin.
