FROM golang:1.8.3-alpine3.6
MAINTAINER Xue Bing <xuebing1110@gmail.com>

# repo
RUN cp /etc/apk/repositories /etc/apk/repositories.bak
RUN echo "http://mirrors.aliyun.com/alpine/v3.6/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/v3.6/community/" >> /etc/apk/repositories

# timezone
RUN apk update
RUN apk add --no-cache tzdata \
    && echo "Asia/Shanghai" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Add Tini
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]

# move to GOPATH
RUN mkdir -p /go/src/github.com/xuebing1110/hello
COPY . $GOPATH/src/github.com/xuebing1110/hello/
WORKDIR $GOPATH/src/github.com/xuebing1110/hello

# build
RUN mkdir -p /app
RUN go build -o /app/hello ./hello.go

EXPOSE 8080
WORKDIR /app
CMD ["/app/hello"]