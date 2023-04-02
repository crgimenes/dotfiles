#!/bin/zsh

remote_machine="neptune.local"
reset="\e[0m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
purple="\e[35m"
cyan="\e[36m"
white="\e[37m"
bold="\e[1m"


folders=("/Users/cesar/Projects/" "/Users/cesar/Docs/")

function rsync_loop_dry_run() {
    for folder in $folders; do
        rsync -hvaz --dry-run --delete cesar@$remote_machine:$folder $folder
    done
}

function rsync_loop() {
    for folder in $folders; do
        rsync -hvaz --delete cesar@$remote_machine:$folder $folder
    done
}

# rsync_loop_dry_run
# exit 0

# confirm execution

echo -e "${yellow}${bold}This script will sync the following folders:${reset}"
echo -e "${green}${bold}"
echo "  - /Users/cesar/Docs/"
echo "  - /Users/cesar/Projects/"
echo -e "${reset}"
echo "with the remote machine $remote_machine"
echo -e "Are you sure you want to continue?${green}${bold}(y/n)${reset}"

read answer

if [[ $answer != "y" ]]; then
    echo -e "${yellow}${bold}Aborting...${reset}"
    exit 1
fi

# Syncing files

echo -e "${green}${bold}Syncing files...${reset}"
rsync_loop

