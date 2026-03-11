---
name: Briefing to Implementation Plan
description: "This skill should be used when the user asks how to convert a briefing into an implementation plan, what structure a briefing-based plan should follow, how to sequence stories into phases, or what information to extract from briefing data for planning. For automated plan generation with codebase exploration, the briefing-planner agent is preferred (via /storyflow:implement-briefing). Also relevant when asking about plan templates, phase ordering, or story dependency mapping."
---

# Briefing to Implementation Plan

Guides the conversion of StoryFlow briefing data and stories into a structured implementation plan compatible with the `/implement-plan` workflow.

For automated plan generation with codebase exploration, use the `briefing-planner` agent via `/storyflow:implement-briefing`. This skill provides the reference template and sequencing strategy for manual planning or understanding the plan format.

For lifecycle and transition knowledge, see the `storyflow-workflow` skill.

## Reading Briefing Data

Fetch data using MCP tools: `mcp__storyflow__get-briefing` for the briefing itself, `mcp__storyflow__get-briefing-stories` for the story list, and `mcp__storyflow__get-story` for individual story details.

A briefing contains several types of information to extract:

- **Description**: The customer's high-level requirements and goals
- **Documents**: Attached files categorized as functional specs, technical specs, or user stories
- **Conversation**: Comments and discussion between customer and agency
- **Asset**: The target codebase (Git repository) where changes will be made

## Reading Story Data

Each story within a briefing provides:

- **Title and description**: What needs to be built
- **Refinement data**: Detailed functional requirements, technical notes, acceptance criteria
- **Complexity**: Relative sizing (helps with sequencing)
- **Priority**: Business priority ordering
- **Dependencies**: Implicit or explicit dependencies on other stories

## Story Sequencing Strategy

To sequence stories into implementation phases:

1. **Identify foundations first**: Stories that create new entities, database tables, or core domain logic come first
2. **Group by domain**: Stories touching the same aggregate or feature area belong in the same phase
3. **Respect dependencies**: If Story B uses an entity from Story A, Story A comes first
4. **Backend before frontend**: API endpoints and business logic before UI components
5. **Risk-first**: Higher complexity stories earlier, when context is fresh

## Plan Template Structure

Generate plans compatible with `/implement-plan`. Use this template:

```markdown
# Implementation Plan: [Briefing Title]

## Context
- **Briefing**: [title] (ID: [id])
- **Customer**: [customer name]
- **Asset**: [asset name]
- **Stories**: [count] stories, [total complexity summary]

## Phase 1: [Domain/Feature Group Name]

### Stories covered
- Story: [title] (ID: [id]) - [status]

### Changes

#### 1.1 [Specific change description]
- **Files**: `path/to/file.php`, `path/to/other.ts`
- **What**: [Concrete description of code changes]
- **Why**: [Rationale tied back to story requirements]

#### 1.2 [Next change]
...

### Testing
- [ ] [Specific test to write or run]
- [ ] [Integration test for the feature]

### Verification
- [ ] [How to verify this phase works]

## Phase 2: [Next Domain/Feature Group]
...

## Cross-Cutting Concerns
- [ ] Translations (EN + NL) for new UI text
- [ ] Security: authorization checks for new endpoints
- [ ] Multi-tenancy: customer scoping for new entities
```

## Best Practices

- **Include story IDs**: Every phase should reference which story IDs it covers, enabling tracking
- **Be specific about files**: List exact file paths based on codebase exploration, not guesses
- **Match existing patterns**: The plan should follow patterns found in the codebase (DDD structure, feature folders, etc.)
- **Test strategy per phase**: Each phase should be independently testable
- **Keep phases small**: 2-4 stories per phase maximum. Each phase should be completable in one session.
- **Note decisions**: Document any architectural decisions or trade-offs in the plan

## Codebase Exploration

Before creating the plan, explore the codebase to understand:

- Existing domain structure (`backend/src/Domain/`)
- Existing feature modules (`frontend/src/features/`)
- Similar features already implemented (patterns to follow)
- Database migrations (existing schema)
- API endpoints (existing controller patterns)

This exploration ensures the plan references real file paths and follows established conventions.
