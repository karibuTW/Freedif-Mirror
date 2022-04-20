#!/bin/bash

# Original script taken from Manjaro Repo, updated by Karibu for Freedif.org mirrors
# Once adapted, need to chmod +x and set up cron job (crontab -e) with "25 */4 * * * /home/karibu/mirror-script/script_ABC.sh"

RSYNC=/usr/bin/rsync

DESTPATH="/media/Stockage/Mirrors/projectname"
LOCKFILE=/tmp/rsync-projectname.lock

synchronize() {
    $RSYNC -av --progress --delete-after --timeout=3600 --contimeout=3600     rsync://url/projectname  "$DESTPATH"
}

if [ ! -e "$LOCKFILE" ]
then
    echo $$ >"$LOCKFILE"
    synchronize
else
    PID=$(cat "$LOCKFILE")
    if kill -0 "$PID" >&/dev/null
    then
        echo "Rsync - Synchronization still running"
        exit 0
    else
        echo $$ >"$LOCKFILE"
        echo "Warning: previous synchronization appears not to have finished correctly"
        synchronize
    fi
fi

rm -f "$LOCKFILE"
