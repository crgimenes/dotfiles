#!/bin/zsh

remote_machine="neptune.local"

# Syncing files
# rsync local files to neptune

rsync -hvaz --delete ~/Projects/ cesar@$remote_machine:/Users/cesar/Projects
rsync -hvaz --delete ~/Docs/ cesar@$remote_machine:/Users/cesar/Docs

