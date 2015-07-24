#!/bin/bash

# variables
SVNDIR="/var/local/svn/"
BACKUPDIR="/var/svn-backup"

find $SVNDIR* -maxdepth 0 -type d | while IFS= read -r DIR
do
	NAME=`expr match "$DIR" '.*\(/.*\)'`
	echo "svnadmin dump $DIR > $BACKUPDIR$NAME.dump"
	svnadmin dump $DIR > $BACKUPDIR$NAME.dump
done
