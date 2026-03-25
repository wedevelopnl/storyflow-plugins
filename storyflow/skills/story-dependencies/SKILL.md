---
name: Story Dependencies
description: "Guidance for identifying and documenting dependencies between stories. Covers implicit dependency recognition, foundation story identification, dependency notation, and sequencing strategy. Use when creating stories, planning implementation phases, or sequencing work on a briefing."
user-invocable: false
---

# Story Dependencies

Identifying dependencies between stories prevents implementation bottlenecks and ensures correct sequencing.

## Types of Dependencies

### Data Dependencies
Story B needs data structures (entities, tables, schemas) created by Story A.
- Signal: Story B references data that doesn't exist yet
- Example: "Dashboard showing order statistics" depends on "Order management"

### UI Dependencies
Story B needs UI components (pages, modals, navigation) built by Story A.
- Signal: Story B extends or modifies a screen that Story A creates
- Example: "Filter orders by status" depends on "Order list view"

### Business Rule Dependencies
Story B's logic assumes rules or workflows established by Story A.
- Signal: Story B references a process or state machine from Story A
- Example: "Send notification on order completion" depends on "Order status workflow"

### Integration Dependencies
Story B needs an API or service endpoint created by Story A.
- Signal: Story B consumes data or triggers actions via Story A's interface
- Example: "Mobile app order tracking" depends on "Order status API"

## Identifying Foundation Stories

Foundation stories unlock multiple other stories and should always come first:
- Stories that create new core entities or data models
- Stories that establish shared UI layouts or navigation
- Stories that set up authentication, permissions, or integrations
- Stories with the most dependents (other stories that need them)

## Documenting Dependencies

When writing stories, note dependencies in the business context section:
- "This story builds on [other story title] which provides [what]"
- Keep dependency notes in business language, not technical terms

When creating implementation plans, group dependent stories in the same or sequential phases.

## Dependency Anti-Patterns

- **Circular dependencies**: If A depends on B and B depends on A, the stories need to be restructured
- **Long chains**: A -> B -> C -> D suggests stories are too granular; consider merging
- **Hidden dependencies**: Always make dependencies explicit rather than assuming ordering
