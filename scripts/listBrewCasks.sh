#!/bin/bash

# Simple bash script to list all installed casks and their storage usage
brew list --cask | xargs -n1 -P8 -I {} sh -c "brew info --cask {} | grep 'KB\|MB\|GB' && echo {}"