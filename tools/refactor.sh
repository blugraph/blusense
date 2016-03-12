#!/bin/bash
#
# This script reconfigures the directories and updates sw to the new
# versions.
#
######################################################################

#SW_DIR="/home/arkbg/dev/devsrc"
#RUN_DIR="/home/arkbg/dev"
SW_DIR="/home/mjay/develop/bg/devsrc"
BKUP_DIR="/home/mjay/develop/bg/bkup"
LOG_DIR="/home/mjay/develop/bg/logs"
RUN_DIR="/home/mjay/develop/bg"

# Do not allow the script to run as root.  
if [ "$(id -u)" == "0" ]; then
    echo "This script cannot run as root"
    exit 1
fi

# Remove all existing files. Prepare new dir for src.
cd $RUN_DIR
# Remove the existing repo.
rm -rf github
# Some files may have root permissions. Change all to user perm.
chown -R arkbg.pi *
#
if [[ ! -e $SW_DIR ]]; then
  mkdir -p $SW_DIR
elif [[ ! -d $SW_DIR ]]; then
  echo "$SW_DIR already exists but is not a directory" 1>&2
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

function clone_master() {
    echo "Cloning $1"
    cd "$SW_DIR" \
        && git clone "https://github.com/jayachandranm/$1"
}

clone_master "bgsense"
