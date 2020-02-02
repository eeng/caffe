DEV_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.dev.yml
CI_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.ci.yml -p caffe_ci

dev:
	docker-compose ${DEV_COMPOSE_OPTS} up ${ARGS}

seed:
	docker-compose ${DEV_COMPOSE_OPTS} exec backend mix ecto.seed

clean:
	docker-compose ${DEV_COMPOSE_OPTS} rm -fsv

ci:
	docker-compose ${CI_COMPOSE_OPTS} up -d --build
	docker-compose ${CI_COMPOSE_OPTS} exec frontend npm test
	docker-compose ${CI_COMPOSE_OPTS} exec db /bin/sh -c "until pg_isready -q; do echo 'db unavailable. sleeping'; sleep 1; done"
	docker-compose ${CI_COMPOSE_OPTS} exec backend mix do ecto.reset, test
