FROM ubuntu:bionic
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    mysql-client \
    less \
    vim \
    git \
    mc \
    openssh-client \
    nmap \
    bind9-host \
    inetutils-ping \
    inetutils-telnet \
    traceroute \
    tcptraceroute \
    && rm -rf /var/lib/apt/lists/*
