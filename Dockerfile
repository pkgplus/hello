FROM golang:1.13.1-alpine3.10 as build-env
MAINTAINER Xue Bing <xuebing1110@gmail.com>

# repo
RUN cp /etc/apk/repositories /etc/apk/repositories.bak
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/community/" >> /etc/apk/repositories

# aok repo
RUN apk update
RUN apk add --no-cache git

# mkdir /src
RUN mkdir -p /src
WORKDIR /src

# go mod
ENV GOPROXY=https://goproxy.cn
COPY go.mod .
COPY go.sum .
RUN go mod download

# build
COPY . .
RUN go build -o /app/hello hello.go


## docker image stage
FROM alpine:3.10
MAINTAINER Xue Bing <xuebing.it@haier.com>

# repo
RUN cp /etc/apk/repositories /etc/apk/repositories.bak
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/v3.10/community/" >> /etc/apk/repositories

# timezone
RUN apk update
RUN apk add --no-cache tzdata bash curl \
    && echo "Asia/Shanghai" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

## Add Tini
#RUN apk add --no-cache tini
#ENTRYPOINT ["/sbin/tini", "--"]

# cmd
COPY --from=build-env /app /app

EXPOSE 8080
WORKDIR /app
CMD ["/app/hello"]

