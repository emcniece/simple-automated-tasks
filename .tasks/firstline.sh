#!/usr/bin/env bash

# EXPERIMENTAL: firstline.sh
# Prints the first line of each PHP file so that
# first-line injected attacks can be easily found.
# Relies on user parsing for now, so there is no point
# in adding this to cron.

# Include config
source $TASKDIR/sites.sh

# Pushbullet token
TOKEN=''

# Store sites with errors
ERRORS=""
TOTAL=0
COUNT=0

for i in ${SITES[@]}
do
        cd "$ROOT/$i/public/"
        for file in `find . -name '*.php'`; do
                (( TOTAL++ ))
                line=$(head -n 1 $file);
                if [[ "$line" = "<?php" ]]; then
                        (( COUNT++ ))
                fi
        done

	echo "Files matching <?php: " $COUNT
	echo "Total files: " $TOTAL
	echo "Difference: " $(expr $TOTAL - $COUNT)

        cd "$ROOT/$i/public"
done

#if [ -n "$ERRORS" ]; then
#        curl -u $TOKEN: https://api.pushbullet.com/v2/pushes -d type=note -d title="Server" -d body="Found PHP in the uploads directory for the following sites: $ERRORS"
#fi
