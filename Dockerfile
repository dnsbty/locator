# Build Elixir code

FROM elixir:alpine AS elixir-build

RUN apk update --no-cache \
  && apk add --no-cache build-base git openssh

RUN mix local.hex --force \
  && mix local.rebar --force

ENV MIX_ENV=prod

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix deps.get

COPY config/config.exs config/config.exs
COPY config/prod.exs config/prod.exs
RUN mix deps.compile

COPY priv priv
COPY lib lib

RUN mix compile --warnings-as-errors

# Build the Javascript stuff

FROM node:lts-alpine AS js-build

WORKDIR /app

ENV NODE_ENV=prod

COPY --from=elixir-build /app/deps deps
WORKDIR /app/assets
COPY assets/package.json assets/package-lock.json ./
RUN npm install

COPY assets .
RUN npm run deploy

# Bring Elixir and Javascript together and create the release binary

FROM elixir-build AS release-build

WORKDIR /app

COPY --from=js-build /app/priv/static ./priv/static
RUN mix phx.digest

COPY config/runtime.exs config/runtime.exs

RUN mix release

# Put it into an empty Alpine container

FROM alpine:latest
RUN apk update --no-cache && apk add --no-cache openssl ncurses-libs
ENV LANG=en_US.UTF-8

WORKDIR /app

COPY --from=release-build /app/_build/prod/rel/locator .

COPY bin/entrypoint.sh /app/bin/

ENV PORT=4000
EXPOSE 4000

ENTRYPOINT ["/app/bin/entrypoint.sh"]
CMD ["/app/bin/locator", "start"]
