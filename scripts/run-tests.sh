#!/usr/bin/env bash
set -ex

export COMPOSE_FILE=docker-compose.yml:docker-compose.ci.yml
export COMPOSE_PROJECT_NAME=caffe_ci

docker-compose up -d --build
docker-compose exec frontend npm test
docker-compose exec db /bin/sh -c "until pg_isready -q; do echo 'db unavailable. sleeping'; sleep 1; done"
docker-compose exec backend mix do ecto.reset, test
# docker-compose down