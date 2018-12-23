# rsyncer with gdfuse

## rsyncer

```
# Usage: path/to/this/script.sh src_path patch_path des_path [log_path]
# For crontab that runs every Monday AM 1:10:
# 10 1 * * 1 path/to/this/script.sh /mnt/usr /mnt/gdrive/usrpatch /mnt/gdrive/usr [log_name]

# This will:
# 1. update 'patch_path' -> 'src_path'
# 2. sync 'src_path' -> 'des_path' (delete enabled)
# 3. sync folder structure 'src_path' -> 'patch_path' (delete enabled)
```

#### prepare with docker-compose

```sh
cp docker-compose.sample.yml docker-compose.yml
vim docker-compose.yml
docker-compose build
```

## docker-google-drive-ocamlfuse

using https://github.com/mitcdh/docker-google-drive-ocamlfuse with docker-compose

```sh
cp .env.sample .env
vim .env
docker-compose up gdfuse
```

#### to reset config

```sh
docker-compose kill
docker-compose down -v
```

## rsyncer and gdfuse

pending
