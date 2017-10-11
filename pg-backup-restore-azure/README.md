# postgres-backup-restore-azure

Docker image to easily backup PostgresSQL to Azure Blob storage (supports periodic backups) and restore from Azure blob storage.

## Backup Usage

Docker:
```
docker run \
  -e AZURE_STORAGE_ACCOUNT=<storage account name> \
  -e AZURE_STORAGE_ACCESS_KEY=<azure storage access key> \
  -e AZURE_TENANT_ID=<azure tenant id> \
  -e AZURE_APP_ID=<azure service principle app id> \
  -e AZURE_SECRET_ID=<azure service principle secret> \
  -e AZURE_STORAGE_CONTAINER=<azure storage container>
  -e POSTGRES_DATABASE=<database name> \
  -e POSTGRES_HOST=<postgres hostname> \
  -e POSTGRES_USER=<postgres db user> \
  -e POSTGRES_PASSWORD=<postgres db password> \
  postgres-azure-backup bash backup.sh
```

Docker Compose:
```yaml
postgres:
  image: postgres
  environment:
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password

pgbackupazure:
  image: elexy/postgres-azure-backup-restore
  links:
    - postgres
  environment:
    SCHEDULE: '@daily'
    AZURE_TENANT_ID: tenant1
    AZURE_APP_ID: app_ID
    AZURE_SECRET_ID: verysecret
    AZURE_STORAGE_ACCOUNT: storage_account
    AZURE_STORAGE_ACCESS_KEY: storage_key
    AZURE_STORAGE_CONTAINER: postgres-backups
    POSTGRES_DATABASE: dbname
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
    POSTGRES_EXTRA_OPTS: '--schema=public --blobs'
```

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable like `-e SCHEDULE="@daily"` to run the backup automatically.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).

