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

