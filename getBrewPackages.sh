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

# Function to get storage usage of a package
get_package_storage() {
    local package=$1
    local type=$2

    if [ "$type" == "cask" ]; then
        info=$(brew info --cask "$package")
    else
        info=$(brew info "$package")
    fi

    # Extract storage information (e.g., "10MB" or "1.2GB")
    storage=$(echo "$info" | grep -oE "[0-9]+\s*[KMG]B" | head -n 1)
    if [ -z "$storage" ]; then
        storage="Unknown"
    fi

    echo "$storage"
}

# Function to list packages and their storage usage
list_packages() {
    local type=$1
    local list_command=$2

    print_message "blue" "=== $type ==="
    packages=$($list_command)
    if [ -z "$packages" ]; then
        print_message "yellow" "No $type installed."
        return
    fi

    for package in $packages; do
        storage=$(get_package_storage "$package" "$type")
        path=$(brew --prefix "$package" 2>/dev/null)
        if [ -z "$path" ]; then
            path="Not found"
        fi
        echo -e "Package: \033[32m$package\033[0m"
        echo -e "Storage: \033[33m$storage\033[0m"
        echo -e "Path: \033[34m$path\033[0m"
        echo "-------------------------"
    done
}

# List formulas
list_packages "Formulas" "brew list"

# List casks
list_packages "Casks" "brew list --cask"