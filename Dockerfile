# #############################################################################
# #############################################################################
# Base image

# https://hub.docker.com/_/alpine
ARG VERSION="23.04"

FROM ubuntu:${VERSION} AS base

# #############################################################################
# #############################################################################
# Production image

FROM base

# -----------------------------------------------------------------------------
# Packages to install

# https://pkgs.alpinelinux.org/packages
ARG PACKAGES="sudo bash wget curl git \
    build-essential file \
    dos2unix \
    python3 python3-pip \
    shellcheck"

RUN \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y ${PACKAGES} && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# USER

# ARG PUID="${UID:-1000}"
# ARG PGID="${GID:-1000}"
# ARG USERNAME="${USER:-tedi}"

# Create a new user on start
# RUN addgroup -g ${PGID} ${USERNAME}
# RUN adduser -u ${PUID} \
#             -G ${USERNAME} \
#             --shell /bin/bash \
#             --disabled-password \
#             -H ${USERNAME}

# RUN mkdir -p /home/${USERNAME}
# RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}
# WORKDIR /home/${USERNAME}
# USER ${USERNAME}

RUN echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu
USER ubuntu
ENV TERM=linux

# -----------------------------------------------------------------------------
# Node js

ENV NVM_DIR "/home/ubuntu/.nvm"

ARG NVM_VERSION="v0.39.3"
ARG NODE_VERSION="v20.4.0"

RUN \
    curl -o- \
    "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" \
    | bash

RUN /bin/bash -c "source ${NVM_DIR}/nvm.sh && nvm install ${NODE_VERSION} && nvm use --delete-prefix ${NODE_VERSION}"

# -----------------------------------------------------------------------------
# Startup

WORKDIR /workdir
ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["/bin/bash", "-i"]
