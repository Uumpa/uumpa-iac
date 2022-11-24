# Pulled Nov 20, 2022
FROM mcr.microsoft.com/azure-cli@sha256:d8517e7c0a7cf9706784fa251440766862cd70775c3d66085fe893176d6c82d9
RUN pip install --upgrade pip && pip install certbot
RUN echo installing kubectl &&\
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.24.2/bin/linux/amd64/kubectl &&\
    chmod +x ./kubectl &&\
    mv ./kubectl /usr/local/bin/kubectl
COPY ./certbot.py /usr/local/bin/uumpa-certbot.py
COPY ./certbot-authenticator.py /usr/local/bin/certbot-authenticator.py
COPY ./certbot-cleanup.py /usr/local/bin/certbot-cleanup.py
