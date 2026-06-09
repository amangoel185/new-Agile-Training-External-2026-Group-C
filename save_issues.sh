#!/bin/bash

# SPDX-FileCopyrightText: 2026 University of Manchester
#
# SPDX-License-Identifier: apache-2.0

# Load the config file
source config.cfg

# Create a directory to store the JSON files
mkdir -p $ISSUES_DIR

# Get the list of issue numbers
issue_numbers=$(gh issue list -R $SOURCE_REPO --state all --limit 10000 --json number --jq '.[].number')


# Loop through each issue number and save the issue details to a JSON file
for issue_number in $issue_numbers; do
    issue_json=$(gh issue view $issue_number -R $SOURCE_REPO --json $FIELDS)
    echo $issue_json > "$ISSUES_DIR/issue_$issue_number.json"
done

# Get the labels for the repositiory
labels_json=$(gh label list -R $SOURCE_REPO --json name,color,description)
echo $labels_json > "labels.json"

echo "All issues have been saved to the '$ISSUES_DIR' directory."