FROM python:3.7.3-alpine3.9
ENV BASE_FOLDER /app

ENV DJANGO_PROJECT_NAME project

RUN mkdir ${BASE_FOLDER}

ADD requirements.txt ${BASE_FOLDER}/
ADD postgres_ready.py /

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --virtual postgres-build-deps \
        gcc=8.3.0-r0 \
        python3-dev=3.6.8-r2 \
        libressl-dev=2.7.5-r0 \
        musl-dev=1.1.20-r4 && \
    apk add --no-cache postgresql-dev=11.3-r0 && \
    pip install --no-cache-dir -r ${BASE_FOLDER}/requirements.txt && \
    apk del postgres-build-deps && \
    rm -rf /var/cache/apk/* && \
    addgroup -S django && \
    adduser -D -H -S django django && \
    chown -R django:django ${BASE_FOLDER} && \
    chmod +x /postgres_ready.py
    
WORKDIR ${BASE_FOLDER}