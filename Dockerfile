# Stage 1: Build the Go application
FROM golang:1.25.1-alpine AS builder

WORKDIR /src

COPY Server/MuchToDo/go.mod Server/MuchToDo/go.sum ./
RUN go mod download

COPY Server/MuchToDo/ ./

RUN GOMAXPROCS=1 CGO_ENABLED=0 GOOS=linux go build -v -p=1 \
    -trimpath \
    -ldflags="-s -w" \
    -o /out/muchtodo ./cmd/api

# Stage 2: Run the application
FROM alpine:3.22

RUN apk add --no-cache ca-certificates wget \
    && addgroup -S app \
    && adduser -S app -G app

WORKDIR /app

COPY --from=builder --chown=app:app /out/muchtodo /usr/local/bin/muchtodo

USER app

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8080/health || exit 1

CMD ["/usr/local/bin/muchtodo"]
