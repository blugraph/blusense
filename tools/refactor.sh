#!/bin/bash
#
# This script reconfigures the directories and updates sw to the new
# versions.
#
######################################################################

RUN_DIR="/home/arkbg/dev"
SW_DIR="$RUN_DIR/devsrc"
SW_DIR_BG="$RUN_DIR/github"
BKUP_DIR="$RUN_DIR/bkup"
LOG_DIR="$RUN_DIR/logs"
#Ullas added config directory
CF_DIR="$RUN_DIR/config"

# Do not allow the script to run as root.  
if [ "$(id -u)" == "0" ]; then
    echo "This script cannot run as root"
    exit 1
fi

# Remove all existing files. Prepare new dir for src.
cd $RUN_DIR
# Remove the existing repo.
if [[ -e $SW_DIR_BG ]]; then
  rm -rf $SW_DIR_BG
fi
#
if [[ ! -e $SW_DIR ]]; then
  mkdir -p $SW_DIR
else
  # If directory or file with the name exists, delete first.
  rm -rf $SW_DIR
  mkdir -p $SW_DIR
#elif [[ ! -d $SW_DIR ]]; then
#  echo "$SW_DIR already exists but is not a directory" 1>&2
fi
#
if [[ ! -e $BKUP_DIR ]]; then
  mkdir -p $BKUP_DIR
elif [[ ! -d $BKUP_DIR ]]; then
  echo "$BKUP_DIR already exists but is not a directory" 1>&2
fi
#
if [[ ! -e $LOG_DIR ]]; then
  mkdir -p $LOG_DIR
elif [[ ! -d $LOG_DIR ]]; then
  echo "$LOG_DIR already exists but is not a directory" 1>&2
fi

# Ullas added Congig directory option
if [[ ! -e $CF_DIR ]]; then
  mkdir -p $CF_DIR
elif [[ ! -d $CF_DIR ]]; then
  echo "$CF_DIR already exists but is not a directory" 1>&2
fi

# Some files may have root permissions. Change all to user perm.
chown -R arkbg.pi *

function clone_master() {
    echo "Cloning $1"
    cd "$SW_DIR" \
        && git clone "https://github.com/blugraph/$1"
}

clone_master "blusense"
cp "$SW_DIR/blusense/tools/check_update.sh" $RUN_DIR
