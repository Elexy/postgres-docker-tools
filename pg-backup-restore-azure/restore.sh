#! /bin/bash

set -eo pipefail

if [ "${AZURE_TENANT_ID}" = "**None**" ]; then
  echo "You need to set the AZURE_TENANT_ID environment variable."
  exit 1
fi

if [ "${AZURE_APP_ID}" = "**None**" ]; then
  echo "You need to set the AZURE_APP_ID environment variable."
  exit 1
fi

if [ "${AZURE_SECRET_ID}" = "**None**" ]; then
  echo "You need to set the AZURE_SECRET_ID environment variable."
  exit 1
fi

if [ "${AZURE_STORAGE_ACCOUNT}" = "**None**" ]; then
  echo "You need to set the AZURE_STORAGE_ACCOUNT environment variable."
  exit 1
fi

if [ "${AZURE_STORAGE_CONTAINER}" = "**None**" ]; then
  echo "You need to set the AZURE_STORAGE_CONTAINER environment variable."
  exit 1
fi

if [ "${AZURE_STORAGE_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the $AZURE_STORAGE_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${POSTGRES_DATABASE}" = "**None**" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ "${POSTGRES_HOST}" = "**None**" ]; then
  if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ "${POSTGRES_USER}" = "**None**" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ "${POSTGRES_PASSWORD}" = "**None**" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

# export ENV vars for azstorage container
export AZURE_STORAGE_ACCOUNT="$AZURE_STORAGE_ACCOUNT"
export AZURE_STORAGE_ACCESS_KEY="$AZURE_STORAGE_ACCESS_KEY"

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "logging into Azure cloud account"

az login \
  --service-principal \
  --user $AZURE_APP_ID \
  --password $AZURE_SECRET_ID \
  --tenant $AZURE_TENANT_ID

if [ "${AZURE_BLOB_NAME}" = "**None**" ]; then
  echo "Finding latest backup"
  file=$(az storage blob list \
    --container-name $AZURE_STORAGE_CONTAINER \
    --query 'max_by([], &properties.lastModified)' -o tsv | cut -f3)

else
  file=${AZURE_BLOB_NAME}
fi

echo "Fetching ${file} from Azure"

az storage blob download \
    --container-name $AZURE_STORAGE_CONTAINER \
    --name $file \
    --file dump.sql.gz
gzip -d dump.sql.gz

if [ "${DROP_PUBLIC}" == "yes" ]; then
	echo "Recreating the public schema"
	psql $POSTGRES_HOST_OPTS -d $POSTGRES_DATABASE -c "drop schema public cascade; create schema public;"
fi

echo "Restoring ${LATEST_BACKUP}"

psql $POSTGRES_HOST_OPTS -d $POSTGRES_DATABASE < dump.sql

echo "Restore complete"