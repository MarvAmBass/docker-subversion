#!/bin/bash
if [ ! -d /var/svn-backup/ ]; then
  exit 0
fi
# variables
SVNDIR="/var/local/svn/"
BACKUPDIR="/var/svn-backup"

find $SVNDIR* -maxdepth 0 -type d | while IFS= read -r DIR
do
	NAME=`expr match "$DIR" '.*\(/.*\)'`
	if [ -f $BACKUPDIR$NAME.info ]; then
      info=$(cat $BACKUPDIR$NAME.info)
    else
      info=""
    fi
    actual=$(svnlook youngest $DIR)
    if [ "$actual" != "$info" ] ; then
	  echo "svnadmin dump $DIR > $BACKUPDIR$NAME.dump"
      svnadmin dump $DIR > $BACKUPDIR$NAME.dump
      echo $actual >$BACKUPDIR$NAME.info
    fi

done
