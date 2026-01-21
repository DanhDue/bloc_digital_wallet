# Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

# coverage:ignore-file

# Flutter Development Container for AI Agents
# Aligned with scripts/install_dev_tools.sh

FROM ubuntu:22.04

# Avoid prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Set locale
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    build-essential \
    libssl-dev \
    libffi-dev \
    libyaml-dev \
    libreadline-dev \
    zlib1g-dev \
    libgmp-dev \
    libncurses5-dev \
    jq \
    nano \
    sudo \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8

# Configure Git safe directory for Cloud AI Agents
RUN git config --system --add safe.directory '*'

# Create vscode user
RUN useradd -ms /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to vscode user
USER vscode
WORKDIR /home/vscode

# Install FVM (Flutter Version Manager)
RUN curl -fsSL https://fvm.app/install.sh | bash

# Set up environment variables
ENV PATH="/home/vscode/fvm/bin:/home/vscode/fvm/default/bin:/home/vscode/.pub-cache/bin:${PATH}"
ENV FLUTTER_ROOT="/home/vscode/fvm/default"
ENV PUB_CACHE="/home/vscode/.pub-cache"

# Install Flutter via FVM
RUN fvm install stable && \
    fvm global stable

# Precache Flutter
RUN /home/vscode/fvm/default/bin/flutter precache

# Set working directory
WORKDIR /workspace

# Default command
CMD ["bash"]
