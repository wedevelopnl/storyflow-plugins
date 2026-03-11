#!/bin/bash
# Detect StoryFlow configuration on session start.
# Outputs a reminder if .claude/storyflow.local.md exists,
# otherwise suggests running /storyflow:setup.
set -euo pipefail

CONFIG_FILE="$CLAUDE_PROJECT_DIR/.claude/storyflow.local.md"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "StoryFlow plugin is installed but not configured for this project. Run /storyflow:setup to link this project to a customer and asset."
  exit 0
fi

# Extract customer_name and asset_name from YAML frontmatter
customer_name=""
asset_name=""

in_frontmatter=false
while IFS= read -r line; do
  if [ "$line" = "---" ]; then
    if [ "$in_frontmatter" = true ]; then
      break
    fi
    in_frontmatter=true
    continue
  fi
  if [ "$in_frontmatter" = true ]; then
    case "$line" in
      customer_name:*)
        customer_name=$(echo "$line" | sed 's/^customer_name:[[:space:]]*//' | sed 's/^"//' | sed 's/"$//')
        ;;
      asset_name:*)
        asset_name=$(echo "$line" | sed 's/^asset_name:[[:space:]]*//' | sed 's/^"//' | sed 's/"$//')
        ;;
    esac
  fi
done < "$CONFIG_FILE"

if [ -n "$customer_name" ] && [ -n "$asset_name" ]; then
  echo "StoryFlow: Connected to ${customer_name} / ${asset_name}. Use /storyflow:briefings to see available work."
else
  echo "StoryFlow: Config found but incomplete. Run /storyflow:setup to reconfigure."
fi
