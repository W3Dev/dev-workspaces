FROM gitpod/workspace-full

RUN sudo apt-get update -y

RUN sudo apt install -y build-essential libtool libreadline-dev \
    zlib1g-dev flex bison libseccomp-dev libssl-dev clang pkg-config \
    libpq-dev etcd cmake postgresql-client

RUN sudo apt-get -y install etcd