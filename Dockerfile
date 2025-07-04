FROM mcr.microsoft.com/playwright:v1.32.0-focal

# bring in your scripts
COPY entrypoint.sh /entrypoint.sh
COPY scripts /scripts

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
