#!/bin/bash

# Input parameters
INSTANCE_ID="$1"
ENVIRONMENT="$2"
AWS_ACCOUNT="$3"
AWS_REGION="$4"

# JSON file containing agent statuses
AGENT_STATUSES_FILE="./configs/${ENVIRONMENT}/connect/agent_statuses.json"

# Check if required parameters are provided
if [ -z "$INSTANCE_ID" ] || [ -z "$ENVIRONMENT" ] || [ -z "$AWS_ACCOUNT" ] || [ -z "$AWS_REGION" ]; then
    echo "Error: Missing required parameters"
    echo "Usage: $0 <instance_id> <environment> <aws_account> <aws_region>"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# Check if agent_statuses.json exists
if [ ! -f "$AGENT_STATUSES_FILE" ]; then
    echo "Error: $AGENT_STATUSES_FILE not found"
    exit 1
fi

# Get existing agent statuses from Amazon Connect
existing_statuses=$(aws connect list-agent-statuses \
    --instance-id "$INSTANCE_ID" \
    --region "$AWS_REGION" \
    --output json)

if [ $? -ne 0 ]; then
    echo "Error: Failed to list existing agent statuses"
    exit 1
fi

# Process each status from the JSON file
jq -c '.[]' "$AGENT_STATUSES_FILE" | while read -r status; do
    status_name=$(echo "$status" | jq -r '.name')
    desired_state=$(echo "$status" | jq -r '.state')
    
    # Check if status exists
    existing_status=$(echo "$existing_statuses" | jq -r --arg name "$status_name" \
        '.AgentStatusSummaryList[] | select(.Name == $name)')

    if [ -n "$existing_status" ]; then
        # Status exists, check if state needs updating
        current_state=$(echo "$existing_status" | jq -r '.State')
        status_id=$(echo "$existing_status" | jq -r '.Id')
        
        if [ "$current_state" != "$desired_state" ]; then
            echo "Updating status '$status_name' to state '$desired_state'"
            aws connect update-agent-status \
                --instance-id "$INSTANCE_ID" \
                --agent-status-id "$status_id" \
                --state "$desired_state" \
                --region "$AWS_REGION"
            
            if [ $? -eq 0 ]; then
                echo "Successfully updated status '$status_name'"
            else
                echo "Error: Failed to update status '$status_name'"
            fi
        else
            echo "Status '$status_name' already in desired state '$desired_state'"
        fi
    else
        # Status doesn't exist, create it
        echo "Creating new status '$status_name' with state '$desired_state'"
        aws connect create-agent-status \
            --instance-id "$INSTANCE_ID" \
            --name "$status_name" \
            --state "$desired_state" \
            --region "$AWS_REGION"
        
        if [ $? -eq 0 ]; then
            echo "Successfully created status '$status_name'"
        else
            echo "Error: Failed to create status '$status_name'"
        fi
    fi
done

exit 0