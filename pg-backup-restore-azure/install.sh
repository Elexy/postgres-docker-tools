#! /bin/sh

# exit if a command fails
set -e

apt-get update
apt-get install -y wget apt-transport-https

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

apt-get update

# install pg_dump
apt-get install -y postgresql

# install azure cli
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
  tee /etc/apt/sources.list.d/azure-cli.list && \
  apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 && \
  apt-get update && apt-get install azure-cli

# install go-cron
apt-get install -y --no-install-recommends curl
curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron

# cleanup
rm -rf /var/cache/apt-get/*
