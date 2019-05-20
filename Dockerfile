# FROM mcr.microsoft.com/dotnet/core/sdk:3.0.100-preview3-stretch
FROM ubuntu:18.04

LABEL author="felipedemacedo" created_at="15/04/2019"

# Install Tesseract
RUN apt-get update && apt-get install -y software-properties-common wget
RUN add-apt-repository -y ppa:alex-p/tesseract-ocr
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y tesseract-ocr-eng python3.7 python-pip

WORKDIR /
ADD tessdata.tar .
ADD tesseract.tar .

ENV TESSDATA_PREFIX=/tessdata/

# Install Google Chrome dependencies
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*

# Install System.Drawing native dependencies https://github.com/dotnet/dotnet-docker/issues/618
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated \
        libc6-dev \
        libgdiplus \
        libx11-dev \
     && rm -rf /var/lib/apt/lists/*

# Install .Net Core 2.2 SDK https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-current#ubuntu18-04-issue
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN add-apt-repository universe && \
 apt-get install -y apt-transport-https && \
 apt-get update && \
 apt-get install -y apt-utils dotnet-sdk-2.2

EXPOSE 4444 5900

CMD [ "bash" ]