---
name: Epic vs Story Organization
description: "When to group stories into epics vs keeping them standalone. Covers epic naming, grouping criteria, and organizational patterns. Use when deciding how to structure stories within a briefing."
user-invocable: false
---

# Epic vs Story Organization

Guidance for deciding when to group stories into epics.

## When to Use Epics

Create an epic when:
- **3+ related stories** share a common theme or user journey
- Stories together form a **complete feature area** (e.g., "User Management" with create, edit, delete, list)
- The grouping helps the customer understand **what they're getting** as a package

Do NOT create an epic for:
- Fewer than 3 stories (use standalone stories instead)
- Technical grouping ("Backend changes", "Frontend changes")
- Stories that happen to touch the same code but serve different user needs

## Epic Naming

Good epic names describe a user-facing capability:
- "Order Management"
- "Customer Self-Service Portal"
- "Reporting and Analytics"
- "Notification Preferences"

Bad epic names describe technical or organizational concepts:
- "Database Changes" (technical grouping)
- "Sprint 1 Work" (timeline-based)
- "Miscellaneous Improvements" (too vague)
- "Phase 2" (arbitrary sequencing)

## Organizational Patterns

### By User Journey
Group stories that together form a complete workflow:
- Epic: "Invoice Management"
  - Create invoice from order
  - Send invoice to customer
  - Track invoice payment status
  - Generate monthly invoice report

### By Feature Area
Group stories that relate to the same domain concept:
- Epic: "Product Catalog"
  - Product listing with search and filters
  - Product detail page
  - Product categories and tags
  - Product image management

### Standalone Stories
Keep stories standalone when they:
- Are cross-cutting (affect multiple areas)
- Are independent improvements with no related stories
- Don't naturally group with other stories in the briefing
