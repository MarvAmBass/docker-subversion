# Subversion Container (ghcr.io/marvambass/subversion) based on secured Apache SSL PHP on debian:bullseye [x86 + arm]
_maintained by MarvAmBass_

## What is it

A Docker Subversion Apache2 Container (based on `ghcr.io/servercontainers/apache2-ssl-secure`).

Features automatic daily dumps of your SVN Repos for Backup purposes.

You can control the access of your Project with a htpasswd file in combination with a authz file.

## Build & Variants

You can specify `DOCKER_REGISTRY` environment variable (for example `my.registry.tld`)
and use the build script to build the main container and it's variants for _x86_64, arm64 and arm_

You'll find all images tagged like `d11.2-s1.2.1-2.1` which means `d<debian version>-s<subversion version (with some esacped chars)>`.
This way you can pin your installation/configuration to a certian version. or easily roll back if you experience any problems
(don't forget to open a issue in that case ;D).

To build a `latest` tag run `./build.sh release`

## Changelogs

* 2023-03-22
    * github action to build container
    * implemented ghcr.io as new registry
    * added example config and `docker-compose.yml`
    * new baseimage `ghcr.io/servercontainers/apache2-ssl-secure`


## Creating a project

You are able to create a new Project by simply adding a new Folder to your repository root directory (`/var/local/svn`).
A cron running every 10 minutes will eventually pick it up.

## How to access your repository

By defdault the repository is host on `/svn`, so for instance you can checkout `yourRepo` using `svn checkout http://yourDockerIp/svn/yourRepo`


## pre run configuration (optional)

You may create the following two files. If you don't need access control you can just skip this step.

Create authz file like this example: 

__$DAV_SVN_CONF/dav_svn.authz__

```
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
```    

__$DAV_SVN_CONF/dav_svn.passwd__

To add a new User like 'testuser' with password 'test' use the following command

```
    htdigest -c $DAV_SVN_CONF/dav_svn.passwd Subversion testuser
```

Or if you're to lazy, just use this line for your file (for testing only!)

```
    testuser:Subversion:5d1b8d8c9a69af4b0180cdafe09cb907
```

## Run the container

```
    docker run \
    -d \
    -v $SVN:/var/local/svn \
    -v $SVN_BACKUP:/var/svn-backup \
    -v $DAV_SVN_CONF/:/etc/apache2/dav_svn/ \
    --name subversion ghcr.io/marvambass/subversion
```