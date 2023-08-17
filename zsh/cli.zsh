# ------------------------------------------
# Function: list_commits
# Description:
#     List all commits made in the last X days in all Git repositories found
#     within the current directory and its subdirectories.
#
# Usage: 
#     list_commits <DAYS>
# 
# Arguments:
#     DAYS: The number of days to look back for commits.
# ------------------------------------------
list_commits() {
    if [[ -z "$1" ]]; then
        echo "Please provide the number of days as an argument."
        return 1
    fi

    find . -type d -name ".git" -exec sh -c 'dir="$(dirname {})";
    pushd "$dir" > /dev/null 2>&1;
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        commits=$(git --no-pager log --since="$1 days ago" --oneline 2>/dev/null);
        if [ ! -z "$commits" ]; then
            echo "\n=== Commits in $dir ===\n$commits";
        fi
    fi;
    popd > /dev/null 2>&1;' sh "$1" \;
}

# ------------------------------------------
# Function: list_scopes
# Description:
#     This function parses the git commit history of the current directory,
#     searching for commit messages that follow the Angular commit convention.
#     It extracts and prints the scopes from these commits. If 10 consecutive
#     commits are found that do not follow the Angular convention, the function
#     prints a warning message and reports the last known good commit.
#
# Usage:
#     list_scopes
# ------------------------------------------
function list_scopes() {
  local BAD_COUNT=0
  local MAX_BAD_COUNT=10
  local LAST_GOOD_COMMIT=""

  git log --oneline | while read commit; do
    if [[ $commit =~ "^([a-f0-9]+) ([a-z]+)\(([a-z]+)\):" ]]; then
      echo "${match[3]}"
      LAST_GOOD_COMMIT=$commit
      BAD_COUNT=0
    else
      BAD_COUNT=$((BAD_COUNT + 1))
      if [ $BAD_COUNT -ge $MAX_BAD_COUNT ]; then
        echo "\nProbably only bad commits from here on out..."
        if [ -n "$LAST_GOOD_COMMIT" ]; then
          echo "Last detected good commit: $LAST_GOOD_COMMIT"
        fi
        return 1
      fi
    fi
  done
}
