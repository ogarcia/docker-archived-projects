# Small docker of Nextcloud Desktop Client [![CircleCI](https://circleci.com/gh/ogarcia/docker-nextcloud-client.svg?style=svg)](https://circleci.com/gh/ogarcia/docker-nextcloud-client)

(c) 2023 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

The [Nextcloud Desktop Client][1] is a tool to synchronize files from
Nextcloud Server with your computer.

This docker packages **Nextcloud Desktop Client** under [Alpine Linux][2],
a lightweight Linux distribution.

Visit [Docker Hub][3], [Quay][4] or [GitHub][5] to see all available tags.

[1]: https://github.com/nextcloud/desktop
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/connectical/nextcloud-client/
[4]: https://quay.io/repository/connectical/nextcloud-client/
[5]: https://github.com/orgs/connectical/packages/container/package/nextcloud-client

## Prepare

If you want the Nexcloud client to run as a normal user instead of as root
you must first create the volume.

```shell
mkdir -p /srv/nextcloud-client/conf
  /srv/nextcloud-client/home \
  /srv/nextcloud-client/documents
chown 1000:1000 /srv/nextcloud-client
```

You should also create a `passwd` file containing the user's UID and GID.

```passwd
root:x:0:0:root:/root:/bin/ash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/mail:/sbin/nologin
news:x:9:13:news:/usr/lib/news:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucppublic:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
man:x:13:15:man:/usr/man:/sbin/nologin
postmaster:x:14:12:postmaster:/var/mail:/sbin/nologin
cron:x:16:16:cron:/var/spool/cron:/sbin/nologin
ftp:x:21:21::/var/lib/ftp:/sbin/nologin
sshd:x:22:22:sshd:/dev/null:/sbin/nologin
at:x:25:25:at:/var/spool/cron/atjobs:/sbin/nologin
squid:x:31:31:Squid:/var/cache/squid:/sbin/nologin
xfs:x:33:33:X Font Server:/etc/X11/fs:/sbin/nologin
games:x:35:35:games:/usr/games:/sbin/nologin
cyrus:x:85:12::/usr/cyrus:/sbin/nologin
vpopmail:x:89:89::/var/vpopmail:/sbin/nologin
ntp:x:123:123:NTP:/var/empty:/sbin/nologin
smmsp:x:209:209:smmsp:/var/spool/mqueue:/sbin/nologin
guest:x:405:100:guest:/dev/null:/sbin/nologin
nobody:x:65534:65534:nobody:/:/sbin/nologin
messagebus:x:100:101:messagebus:/dev/null:/sbin/nologin
youruser:x:1000:1000:root:/data:/bin/ash
```

Store this file in `/srv/nextcloud-client/conf/passwd`.

## Run

To run this container, simply exec.

```shell
docker run -d \
  --name=nextcloud-client \
  -p 127.0.0.1:5900:5900 \
  -u 1000:1000 \ # Set to UID and GID you want
  -e VNCPASS=VERYSECUREPASSWORD \
  -v /srv/nextcloud-client/conf/passwd:/etc/passwd \
  -v /srv/nextcloud-client/home:/data \
  -v /srv/nextcloud-client/documents:/data/documents \
  connectical/nextcloud-client
```

This will run `nextcloud-client`, store the configuration in the
`/srv/nextcloud-client/home` and the synchronized data in
`/srv/nextcloud-client/documents`.

Once it is running you will be able to connect with a VNC client to port
5900 to configure or control the NextCloud client.

You can launch this container with systemd using
`docker-nextcloud-client.service` (you must set the values to your
preference beforehand).

## Shell run

If you can run a shell instead `entrypoint.sh` command, simply do.

```sh
docker run -t -i --rm \
  --entrypoint=/bin/sh \
  connectical/nextcloud-client
```

Please note that the `--rm` modifier destroy the docker after shell exit.
