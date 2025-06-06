#!/bin/bash

mkdir -p ~/Documents/backups
cp ~/.gitconfig ~/Documents/backups
cp ~/.gitconfig-cfacorp  ~/Documents/backups
cp ~/.saml2aws  ~/Documents/backups
rsync -av ~/.aws/ ~/Documents/backups/.aws
rsync -av --exclude='*.lock' ~/.gnupg/ ~/Documents/backups/.gnupg