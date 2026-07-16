# Build the CRMS Go server as a tiny static binary.
FROM golang:1.24-alpine AS build
WORKDIR /src
# The office network resets connections to sum.golang.org, and there is no
# go.sum to verify against anyway — skip the checksum-DB lookup.
ENV GOFLAGS=-mod=mod GOSUMDB=off
# Download modules before copying sources so the layer caches across deploys.
COPY go.mod ./
RUN go mod download
COPY *.go ./
RUN go mod tidy && CGO_ENABLED=0 go build -ldflags='-s -w' -o /crms-server .

FROM alpine:3.21
RUN apk add --no-cache ca-certificates tzdata && adduser -D -H crms
USER crms
COPY --from=build /crms-server /usr/local/bin/crms-server
EXPOSE 8080
ENTRYPOINT ["crms-server"]
