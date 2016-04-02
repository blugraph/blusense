#!/bin/sh
#
# Usage: check_update.sg bgsense
#

RUN_DIR="/home/arkbg/dev"
SW_DIR="$RUN_DIR/devsrc"
BKUP_DIR="$RUN_DIR/bkup"
LOG_DIR="$RUN_DIR/logs"
BKUP_DIR="/home/arkbg/dev/bkup"

# http://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
# Before checking for updates, do a remote update.
cd "$SW_DIR/$1" \
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
    $RUN_DIR/sw_update.sh $1
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
