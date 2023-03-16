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

# confirm execution

echo -e "${yellow}${bold}Warning: This will sync your local files to $remote_machine${reset}"
echo -e "Are you sure you want to continue?${green}${bold}(y/n)${reset}"

read answer

if [[ $answer != "y" ]]; then
    echo -e "${yellow}${bold}Aborting...${reset}"
    exit 1
fi

# Syncing files

rsync -hvaz --delete ~/Projects/ cesar@$remote_machine:/Users/cesar/Projects
rsync -hvaz --delete ~/Docs/ cesar@$remote_machine:/Users/cesar/Docs

