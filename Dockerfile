FROM crystallang/crystal:0.34.0-alpine
WORKDIR /app

EXPOSE 3000

COPY shard.yml shard.lock ./
RUN shards

COPY src ./src/
RUN shards build

COPY scripts ./scripts/

RUN apk add --no-cache redis

ENTRYPOINT ["./scripts/entrypoint"]
