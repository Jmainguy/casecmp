FROM golang:1.10-alpine as builder
RUN set -e \
    && apk add --no-cache git \
    && wget -O - https://github.com/golang/dep/raw/master/install.sh | sh

WORKDIR /go/src/github.com/jimeh/casecmp
ADD . /go/src/github.com/jimeh/casecmp
RUN set -e \
    && dep ensure \
    && CGO_ENABLED=0 go build -a -o /casecmp \
       -ldflags "-X main.Version=$(cat VERSION)"


FROM scratch
COPY --from=builder /casecmp /
ENV PORT 8080
EXPOSE 8080
WORKDIR /
CMD ["/casecmp"]
