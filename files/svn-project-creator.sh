#!/bin/bash

# variables
SVNDIR="/var/local/svn/"

find $SVNDIR* -maxdepth 0 -type d | while IFS= read -r DIR
do
	NAME=`expr match "$DIR" '.*\(/.*\)'`
	
	if [ -f "$DIR/README.txt" ] && [ `cat "$DIR/README.txt" | grep "This is a Subversion repository" | wc -l` -eq 1 ]
	then
		echo "$DIR is already a SVN Filesystem"
	else
		echo "creating new SVN Filesystem: $DIR"
		svnadmin create --fs-type fsfs "$DIR"
		chown -R www-data:www-data "$DIR"
	fi
done

chown -R www-data:www-data "$SVNDIR"
