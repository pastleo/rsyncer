# rsyncer with gdfuse

https://github.com/astrada/google-drive-ocamlfuse

## how to get access token

https://github.com/astrada/google-drive-ocamlfuse/wiki/Headless-Usage-&-Authorization

1. go to https://console.developers.google.com/apis/credentials
2. copy client id, like xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
3. go to https://accounts.google.com/o/oauth2/auth?client_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&response_type=code&access_type=offline&approval_prompt=force

## `rsyncer.sh`

```
# Usage: path/to/this/script.sh src_path patch_path des_path [log_path]
# For crontab that runs every Monday AM 1:10:
# 10 1 * * 1 path/to/this/script.sh /mnt/usr /mnt/gdrive/usrpatch /mnt/gdrive/usr [log_name]

# This will:
# 1. update 'patch_path' -> 'src_path'
# 2. sync 'src_path' -> 'des_path' (delete enabled)
# 3. sync folder structure 'src_path' -> 'patch_path' (delete enabled)
```

## docker-google-drive-ocamlfuse

using https://github.com/mitcdh/docker-google-drive-ocamlfuse with docker-compose

#### setup config

```sh
cp docker-compose.sample.yml docker-compose.yml
vim docker-compose.yml
chmod 777 ./log
docker-compose build
cp .env.sample .env
vim .env
chown 1000:1000 ./gdrive
docker-compose up gdfuse
```

#### to reset config

```sh
docker-compose kill
docker-compose down -v
```

#### rsyncer and docker-google-drive-ocamlfuse in cron job

ensure cron service is enabled and running:

```sh
pacman -S cronie # archlinux
systemctl enable cronie
systemctl start cronie
```

```sh
crontab -e

# For crontab that runs every Monday AM 1:10:
10 1 * * 1 path/to/run-docker-rsyncer.sh
```

## `mount-health-check.sh`

### install google-drive-ocamlfuse

https://aur.archlinux.org/packages/google-drive-ocamlfuse-opam/

```
yay -S google-drive-ocamlfuse-opam
```

### setup google-drive-ocamlfuse

```bash
google-drive-ocamlfuse -headless -id {CLIENT_ID}.apps.googleusercontent.com -secret {CLIENT_SECRET} -o nonempty,allow_other ./gdrive
# after mounting sucessfully for the first time, create a file:
echo 'healthy' > ./gdrive/.health-check
```

### `mount-health-check.sh` in cron job

```sh
crontab -e

# runs health check every 5 minutes:
*/5 * * * * /path/to/this/mount-health-check.sh 2>&1 >> /path/to/this/log/mount-health-check.log
# rotate log check every day:
30 2 * * * mv /path/to/this/log/mount-health-check.log /path/to/this/log/mount-health-check.log.last
```
