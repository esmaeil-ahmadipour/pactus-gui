FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive


# نصب پیش‌نیازها
RUN apt-get update && apt-get install -y \
  curl \
  git \
  unzip \
  xz-utils \
  libglu1-mesa \
  build-essential \
  libfuse2 \
  libgtk-3-dev \
  libglib2.0-dev \
  libnss3 \
  libxss1 \
  libasound2 \
  libx11-dev \
  libssl-dev \
  wget \
  squashfs-tools \
  patchelf \
  tar \
  gzip \
  pkg-config \
  python3 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# دانلود و نصب Dart SDK آخرین نسخه (ARM64)
RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-arm64-release.zip -O dart-sdk.zip \
  && unzip dart-sdk.zip -d /usr/local \
  && rm dart-sdk.zip

ENV PATH="/usr/local/dart-sdk/bin:${PATH}"

# دانلود Flutter SDK نسخه پایدار (نسخه کامل)
RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.3-stable.tar.xz \
    && tar xf flutter_linux_3.27.3-stable.tar.xz -C /usr/local \
    && rm flutter_linux_3.27.3-stable.tar.xz

ENV PATH="/usr/local/flutter/bin:${PATH}"

# اطمینان از اینکه Flutter از Dart نصب شده در PATH استفاده می‌کند
RUN which dart && dart --version

# اجرای flutter doctor بدون اینکه دنبال dart داخلی بگردد
RUN flutter doctor -v

WORKDIR /app
COPY . /app
