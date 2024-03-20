#!/bin/zsh

reset="\e[0m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
purple="\e[35m"
cyan="\e[36m"
white="\e[37m"

origem_folders=(
    "/Users/crg/Projects/"
    "/Users/crg/Documents/"
)

destination_folders=(
    "cesar@neptune.local:/Users/cesar/Projects/"
    "cesar@neptune.local:/Users/cesar/Documents/"
)

function rsync_loop_dry_run() {
    for ((i = 1; i <= ${#origem_folders[@]}; i++)); do
        echo -e "${green}${bold}Syncing ${origem_folders[$i]} to ${destination_folders[$i]}${reset}"
        rsync -hvaz --dry-run --progress -l --delete ${origem_folders[$i]} ${destination_folders[$i]}
    done
}

function rsync_loop() {
    for ((i = 1; i <= ${#origem_folders[@]}; i++)); do
        echo -e "${green}${bold}Syncing ${origem_folders[$i]} to ${destination_folders[$i]}${reset}"
        rsync -hvaz --delete --progress -l ${origem_folders[$i]} ${destination_folders[$i]}
    done
}

cat ~/dotfiles/ansi/mini_skull.ans

echo -e "${yellow}${bold}Warning: This will sync your local files to $remote_machine${reset}"
echo -e "Are you sure you want to continue?${green}${bold}(y/n)${reset}"

read answer

if [[ $answer != "y" ]]; then
    echo -e "${yellow}${bold}Aborting...${reset}"
    exit 1
fi

# Syncing files

echo -e "${green}${bold}Syncing files...${reset}"
rsync_loop
