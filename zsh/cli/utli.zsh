# ------------------------------------------
# Function: clean_dsstore
# Description:
#     Recursively find all .DS_Store files within the current directory and
#     its subdirectories. If the -f or --force flag is provided, delete without
#     confirmation; otherwise, prompt for confirmation before deleting.
#
# Usage:
#     clean_dsstore [-f | --force]
#
# Options:
#     -f, --force: Force deletion without asking for confirmation.
#
# Notes:
#     - Deleting .DS_Store files is safe and does not affect the actual data
#       in your directories. macOS will recreate these files as needed.
# ------------------------------------------
clean_dsstore() {
    FORCE=false

    # Check for the -f or --force flag
    if [ "$1" == "-f" ] || [ "$1" == "--force" ]; then
        FORCE=true
    fi

    echo "Searching for all .DS_Store files..."
    files=$(find . -name '.DS_Store' -type f)

    if [ -z "$files" ]; then
        echo "No .DS_Store files found."
        return
    fi

    if [ "$FORCE" = true ]; then
        echo "Force deletion: Deleting all .DS_Store files..."
        find . -name '.DS_Store' -type f -delete
        echo "Cleanup completed."
    else
        echo "The following .DS_Store files will be deleted:"
        echo "$files"
        read -p "Are you sure you want to delete these files? (y/n): " confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "Deleting .DS_Store files..."
            find . -name '.DS_Store' -type f -delete
            echo "Cleanup completed."
        else
            echo "Operation canceled. No files were deleted."
        fi
    fi
}

