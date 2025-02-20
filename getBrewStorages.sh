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

# Function to check directory size and handle errors
check_directory_size() {
    local dir=$1
    local description=$2

    if [ -d "$dir" ]; then
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        if [ -z "$size" ]; then
            print_message "blue" "$description: Empty"
        else
            print_message "blue" "$description: $size"
        fi
    else
        print_message "yellow" "$description: Directory does not exist"
    fi
}

# Get Homebrew cache and prefix directories
cache_dir=$(brew --cache)
prefix_dir=$(brew --prefix)

# Display Homebrew cache size
check_directory_size "$cache_dir" "Homebrew Cache Size"

# Display Homebrew storage usage
check_directory_size "$prefix_dir" "Homebrew Storage Usage"