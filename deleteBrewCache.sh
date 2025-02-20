#!/bin/bash

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    case $color in
        "red")    echo -e "\033[31m$message\033[0m" ;;
        "green")  echo -e "\033[32m$message\033[0m" ;;
        "yellow") echo -e "\033[33m$message\033[0m" ;;
        "blue")   echo -e "\033[34m$message\033[0m" ;;
        *)        echo -e "$message" ;;
    esac
}

# Get the Homebrew cache directory
cache_dir=$(brew --cache)

# Check if the cache directory exists
if [ ! -d "$cache_dir" ]; then
    print_message "yellow" "Homebrew cache directory does not exist: $cache_dir"
    print_message "blue" "The directory will be created automatically the next time you run a brew command."
    print_message "blue" "Nothing to delete. Exiting."
    exit 0
fi

# Get the size of the Homebrew cache
cache_size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)

# Display the current cache size
if [ -z "$cache_size" ]; then
    print_message "blue" "Homebrew cache is empty."
else
    print_message "blue" "Current Homebrew cache size: $cache_size"
fi

# Ask for confirmation before deletion
print_message "yellow" "Are you sure you want to delete the Homebrew cache? (y/n)"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    print_message "red" "Deletion canceled."
    exit 1
fi

# Delete the cache
print_message "blue" "Deleting Homebrew cache..."
rm -rf "$cache_dir"/*
if [ $? -eq 0 ]; then
    print_message "green" "Deletion completed successfully."
else
    print_message "red" "Failed to delete the cache. Please check permissions or try again."
    exit 1
fi

# Verify the cache is empty
new_cache_size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)
if [ -z "$new_cache_size" ]; then
    print_message "blue" "Homebrew cache is now empty."
else
    print_message "blue" "New Homebrew cache size: $new_cache_size"
fi