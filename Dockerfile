FROM golang:1.23.0-alpine3.20 AS build-env
WORKDIR /app
ADD . /app

RUN go build -o bin/echo-server cmd/server/main.go

FROM alpine

WORKDIR /app
COPY --from=build-env /app/bin/echo-server /app

CMD ["/app/echo-server"]
