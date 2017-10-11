FROM debian:jessie-slim
LABEL creator="Johannes Schickling <schickling.j@gmail.com>"
LABEL maintainer="Alex Knol <alexknol@gmail.com>"

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''

ENV AZURE_TENANT_ID **none**
ENV AZURE_APP_ID **none**
ENV AZURE_SECRET_ID **none**
ENV AZURE_STORAGE_ACCOUNT **none**
ENV AZURE_STORAGE_ACCESS_KEY **none**
ENV AZURE_STORAGE_CONTAINER **none**
ENV AZURE_BLOB_NAME **none**

ENV SCHEDULE **None**

ADD run.sh run.sh
ADD backup.sh backup.sh
# ADD restore.sh restore.sh

CMD ["sh", "run.sh"]
