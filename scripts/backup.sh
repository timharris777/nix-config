#!/bin/bash

mkdir -p ~/Documents/backups
cp ~/.gitconfig ~/Documents/backups
cp ~/.gitconfig-cfacorp  ~/Documents/backups
rsync -av --exclude='*.lock' ~/.gnupg/ ~/Documents/backups/.gnupg