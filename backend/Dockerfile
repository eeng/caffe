FROM elixir:1.9-alpine

# Install build dependencies
RUN apk update && apk add build-base

WORKDIR /code

# Install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

ARG MIX_ENV
ENV MIX_ENV=${MIX_ENV:-dev}

# Install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# Compile the app
COPY . .
RUN mix compile

CMD [ "mix", "phx.server" ]
