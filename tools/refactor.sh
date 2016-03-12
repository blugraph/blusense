#!/bin/bash
#
# This script reconfigures the directories and updates sw to the new
# versions.
#
######################################################################

#SW_DIR="/home/arkbg/dev/devsrc"
#RUN_DIR="/home/arkbg/dev"
SW_DIR="/home/mjay/develop/bg/devsrc"
#RUN_DIR="/home/mjay/develop"

# Do not allow the script to run as root.  
if [ "$(id -u)" == "0" ]; then
    echo "This script cannot run as root"
    exit 1
fi

# Remove all existing files. Prepare new dir for src.
rm -rf github
if [[ ! -e $SW_DIR ]]; then
  mkdir -p $SW_DIR
elif [[ ! -d $SW_DIR ]]; then
  echo "$SW_DIR already exists but is not a directory" 1>&2
fi

function clone_master() {
    echo "Cloning $1"
    cd "$SW_DIR" \
        && git clone "https://github.com/jayachandranm/bg/tree/master/$1" "$1"

clone_master "apps/sense"
clone_master "tools"
