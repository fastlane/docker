FROM circleci/ruby:2.3.4-node

ENV XAR_VERSION "1.6.1"
USER root

WORKDIR /tmp

# Build xar
ADD https://github.com/downloads/mackyle/xar/xar-$XAR_VERSION.tar.gz .
RUN tar -xzf xar-$XAR_VERSION.tar.gz \
  && mv xar-$XAR_VERSION xar \
  && cd xar \
  && ./autogen.sh --noconfigure \
  && ./configure \
  && make 

ENV PATH $PATH:/usr/local/itms/bin

# Java versions to be installed
ENV JAVA_VERSION 8u131
ENV JAVA_DEBIAN_VERSION 8u131-b11-1~bpo8+1
ENV CA_CERTIFICATES_JAVA_VERSION 20161107~bpo8+1

# Needed for fastlane to work
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Required for iTMSTransporter to find Java
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

USER root

# iTMSTransporter needs java installed
# We also have to install make to install xar
# And finally shellcheck
RUN echo 'deb http://archive.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list \
  && sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list \
  && apt-get -o Acquire::Check-Valid-Until=false update \
  && apt-get install --yes \
    make \
    shellcheck \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Python
ARG BUILDDIR="/tmp/build"
ARG PYTHON_VER="3.6.8"
WORKDIR ${BUILDDIR}

RUN apt-get update -o Acquire::Check-Valid-Until=false -qq && \
apt-get -o Acquire::Check-Valid-Until=false upgrade -y > /dev/null 2>&1 && \
apt-get install wget gcc make zlib1g-dev -y -qq > /dev/null 2>&1 && \
wget --quiet https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tgz > /dev/null 2>&1 && \
tar zxf Python-${PYTHON_VER}.tgz && \
cd Python-${PYTHON_VER} && \
./configure  > /dev/null 2>&1 && \
make > /dev/null 2>&1 && \
make install > /dev/null 2>&1 && \
rm -rf ${BUILDDIR} 

USER circleci

# Make xar
RUN cd /tmp/xar \
  && sudo make install \
&& sudo rm -rf /tmp/*
