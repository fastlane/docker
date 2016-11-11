FROM swiftdocker/swift

ADD install-rbenv ./install-rbenv

RUN apt-get update && apt-get install -y libssl-dev zlib1g-dev

RUN ./install-rbenv
