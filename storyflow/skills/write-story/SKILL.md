---
name: Writing User Stories
description: "Guidelines for writing a single high-quality user story. Covers user story format, language guardrails, acceptance criteria (Given/When/Then), complexity sizing, and priority assessment. Use when writing or reviewing individual stories."
---

# Writing User Stories

## Audience

Stories are read by non-technical clients who need to understand what they are getting and what it costs. They do NOT need to know how it will be built. The development team handles technical details during refinement.

## Language Guardrails

FORBIDDEN in story titles and descriptions:
- Framework or library names (React, Symfony, PostgreSQL, Redis, etc.)
- Technical protocols (REST, GraphQL, WebSocket, SSE, JWT, OAuth, etc.)
- Code concepts (API endpoint, migration, middleware, controller, service, entity, etc.)
- Architecture patterns (microservice, event-driven, CQRS, etc.)
- Developer tools (Docker, Git, webpack, npm, etc.)

USE INSTEAD:
- "Real-time updates" NOT "WebSocket connection"
- "Secure login" NOT "JWT authentication"
- "Automatic notifications" NOT "Event-driven email triggers"
- "Data import" NOT "CSV parsing endpoint"
- "Search functionality" NOT "Elasticsearch integration"

SELF-CORRECTION CHECKPOINT:
Before finalizing each story, ask yourself:
1. "Would a non-technical client understand this title?"
2. "Am I describing WHAT the user gets, or HOW it will be built?"
3. "Could this title appear on an invoice to the client?"

If the answer to #1 or #3 is NO, or #2 is "HOW": REWRITE in business terms.

## Story Description Format

Each story has a markdown description with the following structure:

**As a** [user role]
**I want to** [action/feature]
**So that** [business value]

**Business context:**
[Relevant business background, related workflows, constraints the client should know about]

**Acceptance Criteria:**

**Scenario: [name]**
- **Given** [precondition]
- **When** [action]
- **Then** [expected result]
- **And** [additional expected result]

### Complete Example

**Title:** "Email notifications for order status changes"

**Description:**

**As a** registered customer
**I want to** receive email notifications when my order status changes
**So that** I stay informed about my delivery without having to check the app

**Business context:**
Customers currently have to log in to see if their order moved to a new status. Automatic notifications reduce support inquiries and improve the customer experience.

**Acceptance Criteria:**

**Scenario: Order shipped notification**
- **Given** I have placed an order and it is confirmed
- **When** the order status changes to "Shipped"
- **Then** I receive an email with the tracking number and estimated delivery date

**Scenario: Notification preferences**
- **Given** I am on my account settings page
- **When** I disable order notifications
- **Then** I no longer receive status change emails for future orders

**Scenario: Invalid email address**
- **Given** my account email address is invalid or bouncing
- **When** the system tries to send a notification
- **Then** the notification is flagged for review and I see a prompt to update my email next time I log in

**Complexity:** M
**Priority:** medium

### User Story Format Rules

- **As a**: Use the EXACT persona names from the briefing (e.g., "warehouse manager", "shift supervisor"). Fall back to generic roles (end user, admin) ONLY if the briefing does not define specific personas. NEVER use technical actors ("database", "API", "system").
- **I want to**: What action or feature? Concrete, specific, in the user's language.
- **So that**: What PROBLEM does this solve, or what OUTCOME does this enable? Business value, not technical details.

### Strong "So that" examples
- "So that I can identify overdue invoices before they become collection cases"
- "So that new employees can start working independently within their first day"
- "So that I do not need to manually reconcile data between two systems every week"

### Weak "So that" examples (IMPROVE THESE)
- "So that I can manage users" (restates the want, no value)
- "So that the data is up to date" (too vague)
- "So that I have an overview" (does not explain why the overview matters)

### Good story title examples
- "Activity history: see who changed what and when"
- "Email notifications for order status changes"
- "Dashboard with key business metrics"
- "Bulk import of customer data from spreadsheet"

### Bad story title examples (AVOID)
- "Set up audit logging infrastructure" (too technical)
- "Implement WebSocket event handlers" (implementation detail)
- "Database migration for user preferences" (invisible to the client)

## Acceptance Criteria (Given-When-Then)

Each story has 2-5 scenarios:
- At least 1 happy path scenario
- At least 1 error/edge case scenario
- Be specific: "within 2 seconds" instead of "fast"
- No OR statements (split into separate scenarios)
- Write from the user's perspective, not a technical perspective

### Writing testable scenarios
- **Given**: Include specific data states. Example: "Given I have 3 pending orders and 1 completed order"
- **When**: Observable user actions. Example: "When I select 'Last 30 days' from the date filter"
- **Then**: Observable outcomes. Example: "Then I see only the 3 pending orders, sorted by date descending"
- Every scenario must be verifiable without looking at code or database

### Error scenario specificity
Each error scenario MUST specify:
- The exact error condition (not just "something goes wrong")
- The expected feedback shown to the user
- What data is preserved or lost when the error occurs

### Common edge cases to consider
- What happens with no data (empty state)?
- What happens with large amounts of data?
- What if the user does not have permission?
- What if required input is missing or invalid?

## Complexity

Rate the scope of each story. This is about how much new functionality the client gets, not about developer effort.

- **S** = Single-screen change, one user interaction
- **M** = New screen or workflow with 2-3 user interactions
- **L** = Multi-screen workflow with 4+ interactions, multiple user roles, or complex business rules
- **XL** = Too large. Split it. Each story should be independently demonstrable.

When in doubt between two sizes, choose the larger one.

## Priority

- **high** = Must-have. The product cannot fulfill its core purpose without this.
- **medium** = Should-have. Important but the product is functional without it.
- **low** = Nice-to-have. Adds polish or convenience.

Distribution guideline: If more than 40% of stories are high priority, reconsider whether they are all truly launch-critical.

Base priority on:
1. How many users are affected (all users vs. admin-only)
2. What happens if this is deferred (broken vs. minor inconvenience)
3. Whether the briefing explicitly emphasized this as critical
