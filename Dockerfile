FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    curl python3 build-essential make g++ cmake git jq python3-pip \
    libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libasound2t64 libpango-1.0-0 libcairo2 wget gnupg2 \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

RUN npm i -g opencode-ai
RUN curl -LO https://github.com/steipete/gogcli/releases/download/v0.10.0/gogcli_0.10.0_linux_amd64.tar.gz && \
    tar xzf gogcli_0.10.0_linux_amd64.tar.gz && \
    mv gog /usr/local/bin/ && \
    rm gogcli_0.10.0_linux_amd64.tar.gz

RUN wget -q https://github.com/pimalaya/himalaya/releases/download/v1.1.0/himalaya.x86_64-linux.tgz && \
    tar xzf himalaya.x86_64-linux.tgz -C /usr/local/bin/ himalaya && \
    rm himalaya.x86_64-linux.tgz

ARG CACHEBUST=1
RUN npm i -g openclaw

COPY start.sh /start.sh

USER ubuntu

EXPOSE 18789

ENTRYPOINT ["/start.sh"]
