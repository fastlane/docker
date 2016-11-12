FROM debian:jessie
MAINTAINER David Ohayon <dohayon@twitter.com>

SHELL ["/bin/bash", "-c"]

ENV FASTLANE_VERSION "1.108.0"
ENV RUBY_VERSION "2.3.1"

# Packages needed to compile ruby, not actually important when running
ENV BUILD_ONLY_PACKAGES build-essential \
 bzip2 \
 curl \
 libreadline-dev \
 libssl-dev \
 zlib1g-dev

# Starts an irb shell, outputting fastlane version information at the beginning
CMD ["ruby", "-r", "fastlane", "-r", "irb", "-e", "puts \"Running fastlane version #{Fastlane::VERSION}\"", "-e", "IRB.start"]

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y \
 && apt-get install -y $BUILD_ONLY_PACKAGES \
    git \
 && rm -rf /var/lib/apt/list/*

# Install rbenv + ruby
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
 && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
 && ~/.rbenv/bin/rbenv install $RUBY_VERSION \
 && ~/.rbenv/bin/rbenv global $RUBY_VERSION \
 && rm -rf /tmp/*
	
# Install fastlane
RUN ~/.rbenv/bin/rbenv exec gem install fastlane -v $FASTLANE_VERSION \
 && ~/.rbenv/bin/rbenv rehash

# Remove build only packages & clean up 
RUN DEBIAN_FRONTEND=noninteractive apt-get remove -y $BUILD_ONLY_PACKAGES \
 && apt-get autoremove -y \
 && apt-get clean
