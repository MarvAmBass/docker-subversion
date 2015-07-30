#!/bin/bash

cat <<EOF
To use this container you can add a volume for /etc/apache2/dav_svn
which includes the following 2 files:

dav_svn.authz
   a authz file to control the access to your subversion repositories

dav_svn.passwd
   a htpasswd file to manage the users for this subversion system
   
There will be also daily backups of the subversion projects stored under

/var/svn-backup

The actuall SVN Data is stored in the Volume beneath

/var/local/svn
EOF

if [ ! -f /etc/apache2/dav_svn/dav_svn.authz ]
then
    echo "generating dav_svn.authz file which disables user protection"
    cat <<EOF > /etc/apache2/dav_svn/dav_svn.authz
# disable protection - everybody can do what he wants
[/]
* = rw
EOF
fi

if [ ! -f /etc/apache2/dav_svn/dav_svn.passwd ]
then
    echo "generating empty htpasswd file for svn users"
    echo "# no users in this htpasswd file" > /etc/apache2/dav_svn/dav_svn.passwd
fi

chown -R www-data:www-data "/var/local/svn/"
cron -f &
