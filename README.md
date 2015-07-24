How to run this Container

Create auth files: 

- __$DAV_SVN_CONF/dav_svn.authz__

    [groups]
    admin = testuser
    gruppe2 = testuser2

    [project1:/]
    @admin = rw
    @gruppe2 = r

    [project2:/]
    @gruppe2 = rw

- __$DAV_SVN_CONF/dav_svn.passwd__

Username: testuser
Passwort: test

    testuser:$apr1$A2fjdj5R$hx9HvwAuj.i5niRjHEMnA.

Run the container

    docker run \
    -d \
    -v /etc/localtime:/etc/localtime:ro \
    -v $SVN:/var/local/svn \
    -v $SVN_BACKUP:/var/svn-backup \
    -v $DAV_SVN_CONF/:/etc/apache2/dav_svn/ \
    --name subversion marvambass/subversion \
