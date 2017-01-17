#!/bin/sh
#
# Usage: check_update.sh blusense
#

RUN_DIR="/home/arkbg/dev"
SW_DIR="$RUN_DIR/devsrc/$1"
TOOLS_DIR="$SW_DIR/tools"
BKUP_DIR="$RUN_DIR/bkup"
LOG_DIR="$RUN_DIR/logs"
BKUP_DIR="/home/arkbg/dev/bkup"
CF_DIR="$RUN_DIR/config"

# http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
# Before checking for updates, do a remote update.
cd "$SW_DIR" \
    && git checkout master \
    && git remote update
#git remote update

LOCAL=$(git rev-parse @{0})
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @{0} @{u})

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
    $TOOLS_DIR/sw_update.sh "$1"
elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
else
    echo "Diverged"
fi

# Method 2
#git fetch origin
#git log HEAD..origin/master --oneline

# Method 3
#git rev-list HEAD...origin/master --count
