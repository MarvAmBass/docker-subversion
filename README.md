# Docker Subversion Server based on secured Apache SSL PHP on Ubuntu 14.04
_maintained by MarvAmBass_

[FAQ - All you need to know about the marvambass Containers](https://marvin.im/docker-faq-all-you-need-to-know-about-the-marvambass-containers/)

## What is it

A Docker Subversion Apache2 Container (based on marvambass/apache2-ssl-php).

Features automatic daily dumps of your SVN Repos for Backup purposes.

You can control the access of your Project with a htpasswd file in combination with a authz file.

## Creating a project

You are able to create a new Project by simply adding a new Folder to your repository root directory (`/var/local/svn`).
A cron running every 10 minutes will eventually pick it up.

## How to access your repository

By defdault the repository is host on `/svn`, so for instance you can checkout `yourRepo` using `svn checkout http://yourDockerIp/svn/yourRepo`


## pre run configuration (optional)

You may create the following two files. If you don't need access control you can just skip this step.

Create authz file like this example: 

__$DAV_SVN_CONF/dav_svn.authz__

    [groups]
    admin = user1,user2, testuser
    devgroup = user5, user6

    [project1:/]
    @admin = rw
    @devgroup = r

    # devgroup members are able to read and write on project2
    [project2:/]
    @devgroup = rw
    
    # admins have control over every project - and can list all projects on the root point
    [/]
    @admin = rw

    # everybody is able to read repos and sees all projects
    [/]
    * = r
    

__$DAV_SVN_CONF/dav_svn.passwd__

To add a new User like 'testuser' with password 'test' use the following command

    htdigest -c $DAV_SVN_CONF/dav_svn.passwd Subversion testuser

Or if you're to lazy, just use this line for your file (for testing only!)

    testuser:Subversion:5d1b8d8c9a69af4b0180cdafe09cb907

## Run the container

    docker run \
    -d \
    -v $SVN:/var/local/svn \
    -v $SVN_BACKUP:/var/svn-backup \
    -v $DAV_SVN_CONF/:/etc/apache2/dav_svn/ \
    --name subversion marvambass/subversion \
