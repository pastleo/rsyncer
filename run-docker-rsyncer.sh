#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "pwd:"
pwd

echo ""

echo "docker-compose run rsyncer"
docker-compose run rsyncer

echo "sleep 15"
sleep 15

echo "docker-compose kill"
docker-compose kill

echo "umount ./gdrive"
umount ./gdrive
