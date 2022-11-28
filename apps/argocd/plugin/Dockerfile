FROM quay.io/argoproj/argocd:v2.5.2
USER root
RUN apt update && apt install -y python3 python3-pip curl
RUN pip install kubernetes==25.3.0
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
USER 999
COPY argocd_iac_plugin.py /usr/local/bin/argocd_iac_plugin.py
