#!/bin/bash

BACKUP_DIR=~/Documents/backups

DATE_TIME=$(date +"%Y%m%dT%H%M")

function restore_file() {
    if [ -f "${BACKUP_DIR}/${1}" ]; then
        if [ -f ~/"${1}" ]; then
            echo "Backing up file: ~/${1} to ~/${1}.${DATE_TIME}.bak"
            mv ~/"${1}" ~/"${1}.${DATE_TIME}.bak"
        fi
        mv "${BACKUP_DIR}/${1}" ~/"${1}"
        echo "File restored: ${1}"
    else
        echo "No backup found for file: ${1}"
    fi
}

function restore_folder() {
    if [ -d "${BACKUP_DIR}/${1}" ]; then
        if [ -d ~/"${1}" ]; then
            echo "Backing up folder: ~/${1} to ~/${1}.${DATE_TIME}.bak"
            mv ~/"${1}" ~/"${1}.${DATE_TIME}.bak"
        fi
        mv "${BACKUP_DIR}/${1}" ~/"${1}"
        echo "Folder restored: ${1}"
    else
        echo "No backup found for folder: ${1}"
    fi
}

restore_file .gitconfig
restore_file .gitconfig-cfacorp
restore_folder .gnupg
