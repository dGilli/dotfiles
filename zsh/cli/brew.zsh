# ------------------------------------------
# Function: brew_install
# Description:
#     Search for Homebrew formulae and casks using fzf, allowing selection
#     and installation of multiple packages.
#
# Usage:
#     brew_install <SEARCH_TERM>
#
# Arguments:
#     SEARCH_TERM: The term to search for in Homebrew formulae and casks.
# ------------------------------------------
brew_install() {
    selected=$(brew search "$1" | grep -v "^$" | fzf --multi --preview "brew info {}")
    if [ -n "$selected" ]; then
        echo "$selected" | xargs brew install
    fi
}

# ------------------------------------------
# Function: brew_update
# Description:
#     Update all Homebrew formulae and casks, and save the updated versions
#     to a lockfile for reference.
#
# Usage:
#     brew_update
#
# Lockfile Path:
#     $HOME/.config/brew.lock
# ------------------------------------------
brew_update() {
    LOCKFILE="$HOME/.config/brew.lock"

    echo "Updating Homebrew formulae..."
    brew upgrade --greedy

    echo "Updating Homebrew casks..."
    brew upgrade --casks --greedy

    echo "Writing to $LOCKFILE..."
    brew list --versions > "$LOCKFILE"
}

