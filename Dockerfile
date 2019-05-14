FROM python:3.7.3-alpine3.9
ENV BASE_FOLDER /app

ENV DJANGO_PROJECT_NAME project

RUN mkdir ${BASE_FOLDER}

ADD requirements.txt .

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --virtual postgres-build-deps \
        gcc=6.4.0-r5 \
        python3-dev=3.6.3-r9 \
        libressl-dev=2.6.4-r2 \
        musl-dev=1.1.18-r3 && \
    apk add --no-cache postgresql-dev=10.4-r0 && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del postgres-build-deps && \
    rm -rf /var/cache/apk/* && \
    addgroup -S django && \
    adduser -D -H -S django django && \
    chown -R django:django ${BASE_FOLDER} && \
    chmod +x ${BASE_FOLDER}/postgres_ready.py
    
WORKDIR ${BASE_FOLDER}
