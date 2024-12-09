# GitHub Projects Integration Guide

## Setup

### 1. Create Project
```bash
# Create a new project (requires gh extension)
gh project create "AI-Driven Development" --org your-org --public

# Or for personal/private projects
gh project create "AI-Driven Development" --user your-username
```

### 2. Configure Fields
Add custom fields to match our task template:
```bash
gh project field-create "AI-Driven Development" --data-type text --name "Context"
gh project field-create "AI-Driven Development" --data-type text --name "Technical Specs"
gh project field-create "AI-Driven Development" --data-type number --name "Priority"
gh project field-create "AI-Driven Development" --data-type single_select --name "Stage" \
  --single-select-options "Backlog,Planning,In Progress,Review,Done"
```

### 3. Create Views
```bash
# Create a Kanban view
gh project view-create "AI-Driven Development" --name "Kanban" \
  --layout board --group-by "Stage"

# Create a Planning view
gh project view-create "AI-Driven Development" --name "Planning" \
  --layout table --group-by "Priority"
```

## Task Management

### Create Tasks
```bash
# Create a new task
gh issue create --title "Implement HTTP Client" \
  --body "$(cat templates/backlog/task.md)" \
  --project "AI-Driven Development" \
  --label "feature"

# Or using our template directly
gh issue create --template "task.md" \
  --project "AI-Driven Development"
```

### Update Tasks
```bash
# Update task status
gh project item-edit --project "AI-Driven Development" \
  --id ITEM_ID --field Stage --value "In Progress"

# Add technical specifications
gh project item-edit --project "AI-Driven Development" \
  --id ITEM_ID --field "Technical Specs" --value "$(cat specs.md)"
```

### Query Tasks
```bash
# List all in-progress tasks
gh project item-list --project "AI-Driven Development" \
  --filter 'Stage="In Progress"'

# List high priority tasks
gh project item-list --project "AI-Driven Development" \
  --filter 'Priority>3'
```

## Automation

### GitHub Actions Integration
```yaml
name: Project Automation

on:
  issues:
    types: [opened, edited, closed]

jobs:
  update_project:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Add to project
        if: github.event.action == 'opened'
        run: |
          gh project item-create "AI-Driven Development" --url ${{ github.event.issue.html_url }}
          
      - name: Update status
        if: github.event.action == 'closed'
        run: |
          gh project item-edit --project "AI-Driven Development" \
            --id ${{ github.event.issue.node_id }} \
            --field Stage --value "Done"
```

### Custom Scripts

#### Task Creation Helper
```bash
#!/bin/bash
# create-task.sh

# Read template
template=$(cat templates/backlog/task.md)

# Get user input
read -p "Task Title: " title
read -p "Priority (1-5): " priority
read -p "Context: " context

# Create issue with template
gh issue create --title "$title" \
  --body "$template" \
  --project "AI-Driven Development" \
  --label "feature"

# Update project fields
item_id=$(gh project item-list --project "AI-Driven Development" \
  --filter "title=\"$title\"" --format json | jq -r '.[0].id')

gh project item-edit --project "AI-Driven Development" \
  --id "$item_id" \
  --field Priority --value "$priority" \
  --field Context --value "$context"
```

## Best Practices

### Task Organization
1. Use consistent labels
   - `feature` - New features
   - `bug` - Bug fixes
   - `tech-debt` - Technical improvements
   - `docs` - Documentation updates

2. Priority Levels
   - 1: Nice to have
   - 2: Minor improvement
   - 3: Important
   - 4: Critical
   - 5: Urgent/Blocking

3. Stage Workflow
   - Backlog: Initial task creation
   - Planning: Being refined/estimated
   - In Progress: Active development
   - Review: Code review/testing
   - Done: Completed and deployed

### Automation Tips
1. Use templates for consistency
2. Automate status updates
3. Link PRs to issues
4. Use project fields for metrics

### Integration with AI Development
1. Include AI context in task description
2. Link to relevant documentation
3. Track iterations in comments
4. Document AI-generated solutions 