FROM python:3.7.4-slim-buster
ENV BASE_FOLDER /app

ENV DJANGO_PROJECT_NAME project
ARG INSTALLATION_DEPENDENCY_LIBS="gcc=4:8.3.0-1 python3-dev=3.7.3-1 libssl-dev=1.1.1c-1 libcups2-dev=2.2.10-6+deb10u1 linux-libc-dev=4.19.67-2+deb10u1 libpq-dev=11.5-1+deb10u1"
ARG RUNTIME_LIBS="authbind=2.1.2 libcups2=2.2.10-6+deb10u1 libxslt1.1=1.1.32-2.1~deb10u1 libxml2=2.9.4+dfsg1-7+b3 libpq5=11.5-1+deb10u1"

RUN mkdir ${BASE_FOLDER}

ADD requirements.txt ${BASE_FOLDER}/
ADD postgres_ready.py /

RUN apt update && \
    apt-get install -y $INSTALLATION_DEPENDENCY_LIBS && \
    pip install --no-cache-dir -r ${BASE_FOLDER}/requirements.txt && \
    apt-get purge -y $INSTALLATION_DEPENDENCY_LIBS && \
    apt autoremove -y && \
    apt-get install -y $RUNTIME_LIBS && \
    apt-get clean && \
    addgroup django && \
    adduser --system --no-create-home --disabled-password django && \
    adduser django django && \
    chown -R django:django ${BASE_FOLDER} && \
    chmod +x /postgres_ready.py && \
    touch /etc/authbind/byport/80 && \
    chown django /etc/authbind/byport/80 && \
    chmod 775 /etc/authbind/byport/80

WORKDIR ${BASE_FOLDER}
