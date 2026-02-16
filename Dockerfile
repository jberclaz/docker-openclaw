FROM ubuntu:24.04 AS builder

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

FROM ubuntu:24.04

COPY --from=builder /usr/local/bin/gog /usr/local/bin/
COPY --from=builder /usr/local/bin/himalaya /usr/local/bin/
COPY --from=builder /usr/bin/google-chrome-stable /usr/bin/
COPY --from=builder /opt/google/chrome /opt/google/chrome
COPY --from=builder /usr/lib/node_modules /usr/lib/node_modules
COPY --from=builder /usr/lib/node_modules/npm /usr/lib/node_modules/npm
COPY --from=builder /usr/bin/node /usr/bin/
COPY --from=builder /usr/bin/npm /usr/bin/

RUN for pkg in openclaw opencode-ai; do \
      bin=$(node -p "require('/usr/lib/node_modules/$pkg/package.json').bin['$pkg']") && \
      ln -sf "/usr/lib/node_modules/$pkg/$bin" "/usr/bin/$pkg"; \
    done

RUN apt-get update && apt-get install -y \
    libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libasound2t64 libpango-1.0-0 libcairo2 \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh

USER ubuntu

EXPOSE 18789

ENTRYPOINT ["/start.sh"]
