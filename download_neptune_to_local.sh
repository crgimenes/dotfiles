#!/bin/zsh

remote_machine="neptune.local"


# Syncing files

rsync -hvaz --delete cesar@$remote_machine:/Users/cesar/Docs/ ~/Docs
rsync -hvaz --delete cesar@$remote_machine:/Users/cesar/Projects/ ~/Projects


