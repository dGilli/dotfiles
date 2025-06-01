#!/usr/bin/env bash

# Update homebrew and write lockfile
#
# Update all Homebrew formulae and casks, and save the updated versions to a
# lockfile for reference.
#
# Usage:
#     brew_update
#   ./brew-update.sh
#
# @author    Dennis Gilli <me@dennisgilli.com>
# @copyright Copyright (c) 2025 Dennis Gilli
# @link      https://dennisgilli.com/
# @license   MIT-0

LOCKFILE="$HOME/.config/brew.lock"

echo "Updating Homebrew formulae..."
brew upgrade --greedy

echo "Updating Homebrew casks..."
brew upgrade --casks --greedy

echo "Writing to $LOCKFILE..."
brew list --versions > "$LOCKFILE"

read -rp "Do you want to commit the changes to the lockfile? (y/n): " commit_choice
if [[ "$commit_choice" == "y" ]]; then
    git add "$LOCKFILE"
    read -rp "Enter commit message: " commit_message
    git commit -m "$commit_message"
    echo "Changes committed."
else
    echo "No changes committed."
fi

