#!/bin/bash

# Simple bash script to list all installed formulas and their storage usage
brew list --formula | xargs -n1 -P8 -I {} sh -c "brew info {} | grep 'KB\|MB\|GB' && echo {}"