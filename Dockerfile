FROM ruby:3.3-alpine AS builder

RUN apk add --no-cache build-base libpq-dev

WORKDIR /app

RUN bundle config set --local without 'development test'

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 && \
    rm -rf /usr/local/bundle/cache

FROM ruby:3.3-alpine

RUN apk add --no-cache libpq curl tini tzdata

WORKDIR /app

RUN addgroup -S app && adduser -S -G app app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --chown=app:app . .

ENV BUNDLE_WITHOUT="development test" \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

USER app

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD curl -fsS http://localhost:3000/health || exit 1

CMD ["tini", "--", "sh", "-c", "bin/rails db:prepare && exec bin/rails server -b 0.0.0.0"]