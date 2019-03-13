FROM debian:stretch-slim

RUN apt update -qq \
# wkhtmltopdf
    && apt install -y wget xz-utils libxrender1 libssl1.0-dev fontconfig libjpeg62-turbo libxext6  xfonts-base xfonts-75dpi \
    && wget --quiet https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && cp wkhtmltox/bin/wk* /usr/bin/ \
    && apt install -y libssl1.0-dev \
# cleanup
    && rm wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && rm -rf wkhtmltox \
    && apt-get remove -y wget xz-utils \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && truncate -s 0 /var/log/*log

ENTRYPOINT ["wkhtmltopdf"]

# Show the extended help
CMD ["-h"]