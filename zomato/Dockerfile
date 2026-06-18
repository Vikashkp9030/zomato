# Multi-stage build for Go microservices

FROM golang:1.21-alpine as builder

ARG SERVICE_NAME

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-w -s" \
    -o bin/${SERVICE_NAME} \
    ./services/${SERVICE_NAME}/cmd/main.go

FROM alpine:latest

ARG SERVICE_NAME

RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /app/bin/${SERVICE_NAME} .

EXPOSE 8000-8008

CMD ["./${SERVICE_NAME}"]
