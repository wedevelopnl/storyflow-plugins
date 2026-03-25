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

## Skills

| Skill | Description |
|-------|-------------|
| `/storyflow:setup` | Configure plugin for the current project |
| `/storyflow:briefings` | List briefings for the configured asset, grouped by status |
| `/storyflow:briefing <id>` | Smart briefing dashboard with status-aware next steps |
| `/storyflow:story <id>` | Load individual story details with refinement data |
| `/storyflow:claim-briefing <id>` | Claim an approved briefing for implementation |
| `/storyflow:briefing-to-stories <id>` | Generate user stories from an accepted briefing |
| `/storyflow:refine-story <id>` | Refine a single story with multi-agent analysis |
| `/storyflow:refine-briefing <id>` | Refine all stories of a briefing with multi-agent analysis |
| `/storyflow:implement-briefing <id>` | Generate an implementation plan from briefing and stories |
| `/storyflow:asset-documentation [type]` | Generate or update asset documentation (`functional`, `technical`, or `both`) |

Note: `/storyflow:briefings`, `/storyflow:briefing`, and `/storyflow:story` are read-only and can also be auto-triggered by Claude when relevant context is detected.

Domain knowledge (how to write stories, refinement output format) is served dynamically by the StoryFlow application via MCP guidelines calls (`get-story-guidelines`, `get-refinement-guidelines`, `get-asset-documentation-guidelines`). The `briefing-to-plan` reference skill provides plan structure and sequencing guidance locally.


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
5. Execute the plan phase by phase
6. Mark stories as done via the `transition-story` MCP tool

## How it works

The plugin uses MCP (Model Context Protocol) to connect to the StoryFlow API. Authentication is handled via OAuth 2.1: Claude Code automatically manages the token lifecycle through the standard MCP OAuth flow. All communication goes through the MCP server bundled with the plugin.

## Roadmap

### Future Features

- **Personal dashboard** (`/storyflow:my-work`): View all assigned stories across briefings (requires new MCP tool)
- **Briefing chat** (`/storyflow:ask-briefing`): Ask clarifying questions to the Virtual PO from the terminal (requires new MCP endpoint)
- **Bulk story transitions**: Mark multiple stories as done in one operation
- **Automatic story status sync**: Transition stories based on git commit references
- **Plan completion tracking**: Track implementation progress against the generated plan
