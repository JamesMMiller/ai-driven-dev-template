#!/bin/bash

# Check for gh CLI
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is required but not installed."
    exit 1
fi

# Check for required arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <task-title> [priority] [stage]"
    exit 1
fi

TITLE="$1"
PRIORITY="${2:-3}"  # Default priority: 3
STAGE="${3:-Backlog}"  # Default stage: Backlog
PROJECT="AI-Driven Development"
TEMPLATE_PATH="templates/backlog/task.md"

# Read template
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "Template file not found: $TEMPLATE_PATH"
    exit 1
fi

# Create issue with template
echo "Creating task: $TITLE"
ISSUE_URL=$(gh issue create --title "$TITLE" \
    --body "$(cat $TEMPLATE_PATH)" \
    --project "$PROJECT" \
    --label "feature" \
    --json url -q .url)

if [ $? -ne 0 ]; then
    echo "Failed to create issue"
    exit 1
fi

# Get the item ID from the project
echo "Getting project item ID..."
ITEM_ID=$(gh project item-list "$PROJECT" \
    --owner "@me" \
    --format json \
    | jq -r ".items[] | select(.content.url==\"$ISSUE_URL\") | .id")

if [ -z "$ITEM_ID" ]; then
    echo "Failed to get project item ID"
    exit 1
fi

# Update project fields
echo "Updating project fields..."
gh project item-edit --project "$PROJECT" \
    --id "$ITEM_ID" \
    --field Priority --value "$PRIORITY"

gh project item-edit --project "$PROJECT" \
    --id "$ITEM_ID" \
    --field Stage --value "$STAGE"

echo "Task created successfully!"
echo "URL: $ISSUE_URL" 