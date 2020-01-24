FROM mcr.microsoft.com/powershell:7.0.0-rc.1-alpine-3.8

RUN apk add git
RUN apk add openssh-client

ENTRYPOINT [ "/usr/bin/env", "pwsh" ]