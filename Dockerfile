# syntax=docker/dockerfile:1
FROM hexpm/elixir:1.18.4-erlang-28.0.2-debian-bookworm-20250811

RUN apt-get update && \
    apt-get install -y build-essential git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs ./
RUN mix deps.get

COPY . .

RUN mix compile
