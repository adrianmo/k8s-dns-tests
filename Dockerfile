FROM mcr.microsoft.com/dotnet/core/runtime:2.2

RUN apt-get update && \
    apt-get install -y dnsutils curl vim tcpdump

COPY script.sh /script.sh
