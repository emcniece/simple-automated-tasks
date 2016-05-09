#!/usr/bin/env bash

# Include config
source $TASKDIR/sites.sh

# Pushbullet token
TOKEN=''

# Store sites with errors
ERRORS=""

for i in ${SITES[@]}
do
        cd "$ROOT/$i/public"
        # Verify checksums
        cd "$ROOT/$i/public/wp-content/uploads"
        numFiles=$(find . -name '*.php' \
                ! -path './sucuri/*' \
                ! -path './wp-migrate-db/*' \
                | wc -l)

        if [ "$numFiles" -gt 0 ]; then
                ERRORS="$ERRORS $i"
        fi

        cd "$ROOT/$i/public"
done

if [ -n "$ERRORS" ]; then
        curl -u $TOKEN: https://api.pushbullet.com/v2/pushes -d type=note -d title="Server" -d body="Found PHP in the uploads directory for the following sites: $ERRORS"
fi
