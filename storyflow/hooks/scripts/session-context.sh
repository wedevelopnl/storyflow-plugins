#!/bin/bash
# Detect StoryFlow configuration on session start.
# Checks .storyflow/config.json first, falls back to legacy detection.
set -euo pipefail

CONFIG_FILE="$CLAUDE_PROJECT_DIR/.storyflow/config.json"
LEGACY_CONFIG="$CLAUDE_PROJECT_DIR/.claude/storyflow.local.md"

if [ -f "$CONFIG_FILE" ]; then
  # Parse JSON config using python3 (available on macOS and most Linux)
  read -r customer_name asset_name < <(python3 -c "
import json, sys
with open('$CONFIG_FILE') as f:
    cfg = json.load(f)
p = cfg.get('project', {})
print(p.get('customer_name', ''), p.get('asset_name', ''))
" 2>/dev/null || echo "")

  if [ -n "$customer_name" ] && [ -n "$asset_name" ]; then
    echo "StoryFlow: Connected to ${customer_name} / ${asset_name}. Use /storyflow:briefings to see available work."
  else
    echo "StoryFlow: Config found but incomplete. Run /storyflow:setup to reconfigure."
  fi
elif [ -f "$LEGACY_CONFIG" ]; then
  echo "StoryFlow: Legacy config detected (.claude/storyflow.local.md). Run /storyflow:setup to reconfigure."
else
  echo "StoryFlow plugin is installed but not configured for this project. Run /storyflow:setup to link this project to a customer and asset."
fi
