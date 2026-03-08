#!/bin/bash

# -----------------------------------------
# Git Auto Pull Script
# Pulls latest changes for all repositories
# -----------------------------------------

# 📌 Base directory where all repositories are located
BASE_DIR="/c/manju-devops/devopsmanju"

# 📌 List of repositories to update
REPOS=(
  "roboshop-shell-2025"
  "roboshop-ansible-2025"
  "learn-shell-2025"
  "learn-ansible-2025"
  "roboshop-terraform-2025"
  "learn-terraform-2025"
  "roboshop-terraform-practice-2025"
  "tool-setup-code-2025"
)

echo "--------------------------------------------------"
echo "🚀 Starting Git Auto-Pull for all repositories..."
echo "Base Directory: $BASE_DIR"
echo "--------------------------------------------------"
echo

# Loop through each repository
for repo in "${REPOS[@]}"; do
  REPO_PATH="$BASE_DIR/$repo"

  echo "📁 Processing: $repo"

  # Check if folder exists
  if [[ ! -d "$REPO_PATH" ]]; then
    echo "❌ Directory not found: $REPO_PATH"
    echo
    continue
  fi

  # Enter the repo
  cd "$REPO_PATH" || continue

  # Check if it's a git repo
  if [[ ! -d ".git" ]]; then
    echo "⚠️  Not a Git repository: $REPO_PATH"
    echo
    continue
  fi

  # Pull latest changes safely
  echo "🔄 Fetching latest changes..."
  git fetch origin main

  echo "⬇️ Pulling updates..."
  git pull origin main

  echo "✅ Updated: $repo"
  echo "--------------------------------------------------"
  echo
done

echo "🎉 All repositories updated successfully!"
