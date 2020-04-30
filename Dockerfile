FROM centos:7.4.1708

LABEL CREATEDBY="mike"

ENV GOLANG_VERSION 1.14.2
ENV GOLANG_DOWNLOAD_SHA256 6272d6e940ecb71ea5636ddb5fab3933e087c1356173c61f4a803895e947ebb3

COPY CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

# install dependency
RUN yum --disableplugin=fastestmirror makecache \
    &&  yum --disableplugin=fastestmirror install -y \ 
        git \
        deltarpm \
        gcc \
        make \
        libtool \
        epel-release \
        openssl 

# install golang
RUN curl -fsSL "https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz" -o go.tar.gz \
    && echo "${GOLANG_DOWNLOAD_SHA256} go.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz \
    && export PATH="/usr/local/go/bin:$PATH" \
    && go version


ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
