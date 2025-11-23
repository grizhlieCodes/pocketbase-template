# Stage 1: Download PocketBase
FROM alpine:3.20 AS downloader

ARG PB_VERSION=0.34.0
ARG PB_SHA256=""

RUN apk add --no-cache curl unzip ca-certificates && update-ca-certificates

WORKDIR /tmp/pb

RUN curl -fsSL -o pocketbase.zip \
    "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip"

# Optional SHA256 verification
RUN if [ -n "$PB_SHA256" ]; then \
        echo "${PB_SHA256}  pocketbase.zip" | sha256sum -c - ; \
    else \
        echo "WARNING: PB_SHA256 not set, skipping checksum verification"; \
    fi

RUN unzip pocketbase.zip && chmod +x pocketbase

# Stage 2: Runtime
FROM alpine:3.20

RUN apk add --no-cache ca-certificates tini su-exec && update-ca-certificates

# Create non-root user
RUN addgroup -S pocketbase && adduser -S -G pocketbase -u 65532 pocketbase

WORKDIR /app

# Copy binary from downloader stage
COPY --from=downloader /tmp/pb/pocketbase /usr/local/bin/pocketbase

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy migrations and hooks
COPY ./pb_migrations ./pb_migrations
COPY ./pb_hooks ./pb_hooks

# Environment defaults (Railway will override PORT if set)
ENV PORT=8080
ENV DATA_DIR=/data

EXPOSE 8080

# Use tini for proper signal handling
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
