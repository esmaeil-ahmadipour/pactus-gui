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
  cmake \
  ninja-build \
  g++ \
  clang \
  clangd \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# نصب Dart SDK
RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-arm64-release.zip -O dart-sdk.zip \
  && unzip dart-sdk.zip -d /usr/local \
  && rm dart-sdk.zip

ENV PATH="/usr/local/dart-sdk/bin:${PATH}"

# تأیید نصب Dart
RUN dart --version
RUN which dart

# نصب Flutter بدون اجرای اسکریپت‌های داخلی و استفاده از Dart نصب‌شده
RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.0-stable.tar.xz \
  && tar xf flutter_linux_3.32.0-stable.tar.xz -C /usr/local \
  && rm flutter_linux_3.32.0-stable.tar.xz

ENV PATH="/usr/local/flutter/bin:${PATH}"

# جلوگیری از خطای git "dubious ownership"
RUN git config --global --add safe.directory /usr/local/flutter

# پاکسازی cache قبلی Flutter و عدم reliance روی Dart داخلی
RUN rm -rf /usr/local/flutter/bin/cache

# اجرای flutter doctor
RUN flutter doctor -v

WORKDIR /app
COPY . /app
