FROM cimg/ruby:3.3-node

ENV XAR_VERSION="2.0.0"
USER root

# Install dependencies for building Python and xar
# gcc/make/libssl-dev/zlib1g-dev are needed to build xar/python
# openjdk-21-jdk is needed for iTMSTransporter
# shellcheck for linting shell scripts
RUN apt-get update && apt-get install --yes \
        gcc \
        make \
        shellcheck \
        libssl-dev \
        zlib1g-dev \
        openjdk-21-jdk \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Build xar
# Original: https://github.com/downloads/mackyle/xar/xar-$XAR_VERSION.tar.gz
# Now using a fastlane fork that supports OpenSSL 1.1.0
ADD https://github.com/fastlane/xar/archive/$XAR_VERSION.tar.gz .
RUN tar -xzf $XAR_VERSION.tar.gz \
  && mv xar-$XAR_VERSION/xar xar \
  && cd xar \
  && ./autogen.sh --noconfigure \
  && ./configure \
  && make

# Needed for fastlane to work
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Required for iTMSTransporter to find Java
ENV PATH=$PATH:/usr/local/itms/bin
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64/jre

# Install Python
ARG BUILDDIR="/tmp/build"
ARG PYTHON_VER="3.8.13"
WORKDIR ${BUILDDIR}

RUN wget --quiet https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz > /dev/null 2>&1 && \
tar zxf Python-${PYTHON_VER}.tgz && \
cd Python-${PYTHON_VER} && \
./configure  > /dev/null 2>&1 && \
make > /dev/null 2>&1 && \
make install > /dev/null 2>&1 && \
rm -rf ${BUILDDIR}

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.6.6 /uv /bin/uv
ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python

# Install pip & pipenv
RUN wget --quiet https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py > /dev/null 2>&1 && \
    python /tmp/get-pip.py && \
    rm /tmp/get-pip.py && \
    pip install pipenv

USER circleci

# Make xar
RUN cd /tmp/xar \
  && sudo make install \
&& sudo rm -rf /tmp/*
