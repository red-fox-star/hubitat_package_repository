FROM crystallang/crystal:0.34.0-alpine
RUN apk add --no-cache redis

ENV PORT 80
ENV PERSONAL_ACCESS_TOKEN 00000000000000
EXPOSE $PORT
ENV KEMAL_ENV production

WORKDIR /app

COPY shard.yml shard.lock ./
RUN shards

COPY src ./src/
RUN shards build --release

COPY scripts ./scripts/

ENTRYPOINT ["./scripts/entrypoint"]
