FROM ubuntu:18.04

LABEL author="felipedemacedo" created_at="15/04/2019" updated_at="07/06/2019"

USER root

#=========
# Set TimeZone to America/Recife
#=========
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends tzdata
ENV TZ=America/Recife
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y software-properties-common wget

#=========
# Firefox
#=========
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    firefox \
    flashplugin-installer \
    unzip \
    ca-certificates

#=========
# Tesseract
#=========
RUN add-apt-repository -y ppa:alex-p/tesseract-ocr
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y tesseract-ocr-eng python3.7 python-pip

WORKDIR /
ADD tessdata.tar .
ADD tesseract.tar .

ENV TESSDATA_PREFIX=/tessdata/

#=========
# Google Chrome
#=========
RUN wget http://dl.google.com/linux/deb/pool/main/g/google-chrome-stable/google-chrome-stable_74.0.3729.131-1_amd64.deb \
    && apt-get install -y -f ./google-chrome-stable_74.0.3729.131-1_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

#=========
# System.Drawing native dependencies https://github.com/dotnet/dotnet-docker/issues/618
#=========
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated \
        libc6-dev \
        libgdiplus \
        libx11-dev \
     && rm -rf /var/lib/apt/lists/*

#=========
# .Net Core 2.2 SDK https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-current#ubuntu18-04-issue
#=========
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN add-apt-repository universe && \
 apt-get install -y apt-transport-https && \
 apt-get update && \
 apt-get install -y apt-utils dotnet-sdk-2.2 cifs-utils

EXPOSE 4444 5900

CMD [ "bash" ]

