#!/bin/bash

# SPDX-FileCopyrightText: 2026 University of Manchester
#
# SPDX-License-Identifier: apache-2.0

# Load the config file
source config.cfg

# Load the labels into the target repository
jq -r '.[] | [.name, .color, .description] | @tsv' labels.json \
| while IFS=$'\t' read -r labelName labelColor labelDescription; do
  echo "Creating label: $labelName with description: $labelDescription and color: $labelColor"
  gh api --method POST -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/$TARGET_REPO/labels \
    -f "name=$labelName"  -f "description=$labelDescription" -f "color=$labelColor"
  done

# Loop through each JSON file in the directory
for issue_file in $(ls $ISSUES_DIR/*.json | sort -V); do
    # Read the issue details from the JSON file
    issue_json=$(cat $issue_file)

    # Extract the fields from the JSON
    title=$(echo $issue_json | jq -r '.title')
    body=$(echo $issue_json | jq -r '.body')
    labels=$(echo $issue_json | jq -r '[.labels[].name] | join(",")')
    state=$(echo $issue_json | jq -r '.state')
    comments=$(echo $issue_json | jq -c '.comments')

    # Extract the issue number from the URL
    issue_number=$(echo $issue_url | awk -F'/' '{print $NF}')

    # Create the issue in the target repository
    issue_url=$(gh issue create -R $TARGET_REPO --title "$title" --body "$body" --label "$labels")

    # Extract the issue number from the URL
    issue_number=$(echo $issue_url | awk -F'/' '{print $NF}')

    # Update the state of the new issue if it was closed
    if [ "$state" == "CLOSED" ]; then
        gh api -X PATCH -H "Accept: application/vnd.github+json" \
            "/repos/$TARGET_REPO/issues/$issue_number" \
            -f state="CLOSED"
    fi

    # Add comments to the new issue
    for comment in $(echo $comments | jq -r '.[] | @base64'); do
        comment_body=$(echo $comment | base64 --decode | jq -r '.body')
        comment_author=$(echo $comment | base64 --decode | jq -r '.author.login')
        comment_body_with_author=$(printf "Original comment by $comment_author:\n%s" "$comment_body")
        gh api -X POST -H "Accept: application/vnd.github+json" \
            "/repos/$TARGET_REPO/issues/$issue_number/comments" \
            -f body="$comment_body_with_author"
    done

    # Add the issue to the project
    gh project item-add $projid --owner $TARGET_PROJECT_OWNER --url $issue_url

done

echo "All issues have been uploaded to the '$TARGET_REPO' repository."

if [ $DELETE_ISSUES_DIR_WHEN_DONE == "true" ]; then
    rm -r $ISSUES_DIR
    echo "Removed the the '$ISSUES_DIR' directory."
fi