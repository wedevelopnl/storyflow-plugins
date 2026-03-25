---
name: Briefing Quality Assessment
description: "Guidance for assessing whether a briefing is ready for scoping into stories. Covers what a good briefing contains, what to extract for stories, when to request clarification from the customer, and signs that a briefing is too vague or too broad."
user-invocable: false
---

# Briefing Quality Assessment

Assess whether a briefing contains enough information to generate high-quality stories.

## What a Good Briefing Contains

### Essential Elements
- **Clear goal**: What the customer wants to achieve (not just what to build)
- **User personas**: Who will use the feature and their roles
- **Current situation**: What exists today and why it's insufficient
- **Success criteria**: How the customer will know the feature is complete
- **Scope boundaries**: What is explicitly out of scope

### Valuable Additions
- Existing workflows or processes being replaced
- Examples of similar features in other products
- Priority ranking of requirements
- Timeline constraints or business deadlines

## Readiness Signals

### Ready for Scoping
- All user personas are identified
- The goal is expressed in business terms, not technical terms
- Success criteria are specific enough to write acceptance criteria from
- Scope boundaries are clear

### Needs Clarification
- Requirements use vague language ("better", "faster", "improved")
- Multiple interpretations are possible for key requirements
- User personas are missing or unclear
- No success criteria defined
- Scope is either undefined or unrealistically broad

### Too Broad
- The briefing describes an entire application rather than a feature
- More than 15 stories would be needed to cover the scope
- Multiple independent features are bundled together
- The briefing mixes strategic goals with tactical requirements

## Extracting Information for Stories

From the briefing, identify:
1. **User journeys**: End-to-end flows a user performs
2. **Data objects**: Things the user creates, views, edits, or deletes
3. **Business rules**: Conditions, validations, and constraints
4. **Integrations**: External systems or data sources
5. **Edge cases**: What happens when things go wrong
