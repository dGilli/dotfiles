# Updates Homebrew formulae and casks, and writes the versions to a lockfile.
brew_update() {
    LOCKFILE="$HOME/.config/brew.lock"

    echo "Updating homebrew formulae\n"
    brew upgrade --greedy

    echo "Updating homebrew casks\n"
    brew upgrade --casks --greedy

    echo "Writing to $LOCKFILE\n"
    brew list --versions > "$LOCKFILE"
}

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

# Helper function for listing commits
_list_commits_helper() {
    pushd "$1" > /dev/null 2>&1

    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        local commits
        commits=$(
            git --no-pager log --since="$2 days ago" --oneline 2>/dev/null
        )
        if [ ! -z "$commits" ]; then
            echo "\n\n=== Commits in $1 ===\n$commits"
        fi
    fi

    popd > /dev/null 2>&1
}

# Main lists_commits function
list_commits() {
    if [[ -z "$1" ]]; then
        echo "Please provide the number of days as an argument."
        return 1
    fi

    find . -type d -name ".git" -exec bash -c \
        '_list_commits_helper "$(dirname "$0")" "$1"' {} "$1" \;
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
  local LAST_GOOD_COMMIT=""

  git log --oneline | while read commit; do
    if [[ $commit =~ "^([a-f0-9]+) ([a-z]+)\(([a-z]+)\):" ]]; then
      echo "${match[3]}"
      LAST_GOOD_COMMIT=$commit
      BAD_COUNT=0
    else
      BAD_COUNT=$((BAD_COUNT + 1))
      if [ $BAD_COUNT -ge 10 ]; then
        echo "\nProbably only bad commits from here on out..."
        if [ -n "$LAST_GOOD_COMMIT" ]; then
          echo "Last detected good commit: $LAST_GOOD_COMMIT"
        fi
        return 1
      fi
    fi
  done
}

# ------------------------------------------
# Function: add_work_item
# Description:
#    This function adds a work item to Azure DevOps.
#    It takes two arguments: the project and the title.
# ------------------------------------------
function add_work_item() {
    declare -A projects
    projects+=(
        ["web"]="Web Engineering"
        ["akdms"]="AKDMS Website"
    )
    az boards work-item create \
        --org "https://dev.azure.com/acribis" \
        --project ${projects[$1]} \
        --type "User Story" \
        --title $2 \
        --open
}
complete -W "web akdms" add_work_item

# ------------------------------------------
# Function: list_tasks
# ------------------------------------------
function list_tasks() {
    local query_path="f7a5a5fc-a04c-4b93-a1f7-2b86ff42d227"
    local selected_project=$(az boards query --path $query_path \
        --query '[*][fields."System.AreaLevel1"]' -o tsv \
        | awk '!x[$0]++' | fzf)

    if [ -n "$selected_project" ]; then
        local selected_task=$(az boards query --path $query_path \
            --query "[?fields.\"System.AreaLevel1\"=='$selected_project'][join(': ', [to_string(id), fields.\"System.Title\"])]" \
            -o tsv \
            | fzf)
    fi

    if [ -n "$selected_task" ]; then
        local selected_task_id=$(echo $selected_task | sed 's/:.*//')
        echo "Task ID: $selected_task_id"

        echo -n "FROM / TO: "
        read input_string
        fromTo=("${(@s:/:)input_string}")

        trim_whitespace() {
            local var="$1"
            var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace
            var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace
            echo "$var"
        }

        local from=$(trim_whitespace "$fromTo[1]")
        local to=$(trim_whitespace "$fromTo[2]")

        local command="watson add -cb '$selected_project' +'azure $selected_task_id' --from $from --to $to"

        # Echo the command
        echo "Executing command: $command"

        # Execute the command
        eval "$command"
    fi
}

# ------------------------------------------
# Function: list_tasks
# ------------------------------------------
function watson_edit_month() {
    ids=$(watson log --from 2023-09-01 -s | awk -F, 'NR > 1 {print $1}')

    IFS=$'\n'
    for id in $ids; do
        echo "Processing ID: $id"
        watson edit "$id"
    done
    unset IFS
}

# ------------------------------------------
# Function: watson_retro
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
watson_retro() {
    if [[ $1 == -* ]]; then
        hours=$(echo $1 | tr -d '-' | cut -d: -f1)
        minutes=$(echo $1 | cut -d: -f2)
        total_minutes=$((hours * 60 + minutes))
        time=$(date -j -v-"${total_minutes}M" +"%H:%M" "$(date +%m%d%H%M%Y)")
    else
        time=$1
    fi
    project_arg=$2
    shift 2
    wt start --at "$time" "$project_arg" "$@" && wt stop
}

