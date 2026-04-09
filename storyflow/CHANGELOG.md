# Changelog

All notable changes to the StoryFlow plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.0 - 2026-04-10

### BREAKING CHANGES

The StoryFlow briefing and story lifecycles have been harmonised. Clients that hardcoded transition names, workflow status values, or the "approved briefing" terminology must update.

**Briefing transitions no longer exposed (the briefing projection replaces them):**

From `Accepted` onwards, a briefing's workflow status is projected automatically from its linked stories. The following briefing-level transitions are therefore removed from the MCP transition map and will fail if invoked directly:

- `scoped` (`Accepted -> Scoped`)
- `refined` (`Scoped -> Refined`)
- `priced` (`Refined -> Priced`)
- `approve` (briefing-level, `Priced -> ToDo`)
- `start` (`ToDo -> Doing`)
- `complete` (`Doing -> Done`)
- `return-to-accepted` (`Scoped -> Accepted`)
- `return-to-scoped` (`Refined -> Scoped`)
- `return-to-refined` (`Priced -> Refined`)
- `archive` (briefing-level, replaced by the `archivedAt` orthogonal flag)

The briefing transition map now only contains `submit`, `withdraw`, `return-to-draft`, `accept`, `return-to-submitted`, and `cancel`. Forward motion from `Accepted` onwards happens by moving the linked stories.

**Story transitions no longer exposed:**

- `archive` (story-level, replaced by the `archivedAt` orthogonal flag)

**Removed workflow status values:**

- Story statuses: `NeedsClarification`, `Archived`
- Briefing statuses: `Archived`

`NeedsClarification` was dropped without a replacement flag; `Archived` is now an orthogonal flag (`archivedAt`), not a workflow status.

**New story transitions:**

- `accept` (`Submitted -> Accepted`): the agency commits to the story
- `scope` (`Accepted -> Scoped`): the agency confirms the scope definition
- `return-to-submitted` (`Accepted -> Submitted`)
- `return-to-accepted` (`Scoped -> Accepted`)
- `return-to-scoped` (`Refined -> Scoped`)

Refinement (`refine`) now starts from `Scoped`, not `Submitted`.

**New orthogonal MCP actions (not workflow transitions):**

- `archive-story` + `unarchive-story`: toggle the `archivedAt` soft-delete flag (allowed only from a terminal workflow status; preserves the status).
- `archive-briefing` + `unarchive-briefing`: same for briefings.

**Briefing status is now a projection.** From `Accepted` onwards, the briefing's workflow status is automatically computed from its linked stories using a min-wins rule with a `Doing` any-wins override. Manual briefing transitions for those steps no longer exist.

### Migration

1. Upgrade the plugin: `/plugin update storyflow@storyflow-marketplace`.
2. Review any external automations or scripts that call the MCP server directly. Replace removed transition names with the new orthogonal actions (`archive-story`, etc.) or the new `accept` / `scope` story transitions.
3. Clients that listed `approved` as the "ready to claim" criterion should switch to `accepted` (the same semantic step under the new naming).
4. Clients that surfaced `Archived` as a separate kanban column should use the `archivedAt` flag on the regular workflow status instead.
5. Clients that called briefing transitions from `Accepted` onwards (`scoped`, `refined`, `priced`, `approve`, `start`, `complete`, or any `return-to-*` from those steps) should drive the motion through the linked stories instead.

### Added

- Orthogonal archive flag (`archivedAt`) exposed in `get-briefing` and `get-story` responses.
- New explicit agency commitment steps: `accept` and `scope` between `Submitted` and `Refined`.
- `load-briefing` and `load-story` skills now render the archive flag alongside the workflow status.
- README section documenting the lifecycle and the archive flag.

### Changed

- `claim-briefing` skill: updated terminology (`accepted` instead of `approved`), no longer claims to "transition the briefing to InProgress". Claim now only assigns the architect; the workflow status projects from the stories.
- `list-briefings` skill: claim-target is now briefings in `Accepted` status without an assigned architect.
- `refine-briefing` and `refine-story` skills: refinement now starts from `Scoped` status (stories must be accepted and scoped first).
- `briefing-to-stories` skill: generated stories start in `Accepted` instead of `Submitted`.
- Plugin version bumped to 2.0.0 to signal the breaking changes.

### Removed

- All references to `approved briefing` terminology from skill descriptions and bodies.
- All references to `NeedsClarification` and `Archived` as workflow statuses from skill content.
