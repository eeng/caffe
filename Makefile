DEV_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.dev.yml -p caffe_dev
PROD_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.prod.yml -p caffe_prod
CI_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.ci.yml -p caffe_ci

dev.start:
	docker-compose ${DEV_COMPOSE_OPTS} up ${ARGS}

dev.stop:
	docker-compose ${DEV_COMPOSE_OPTS} stop ${ARGS}

dev.seed:
	docker-compose ${DEV_COMPOSE_OPTS} exec backend mix ecto.seed

dev.clean:
	docker-compose ${DEV_COMPOSE_OPTS} rm -fsv

prod.start:
	docker-compose ${PROD_COMPOSE_OPTS} up ${ARGS}

prod.stop:
	docker-compose ${PROD_COMPOSE_OPTS} stop ${ARGS}

prod.seed:
	docker-compose ${PROD_COMPOSE_OPTS} exec backend bin/caffe eval "Caffe.Release.seed"

prod.exec:
	docker-compose ${PROD_COMPOSE_OPTS} exec ${ARGS}

prod.shell:
	docker-compose ${PROD_COMPOSE_OPTS} exec backend bash

prod.console:
	docker-compose ${PROD_COMPOSE_OPTS} exec backend bin/caffe remote

prod.clean:
	docker-compose ${PROD_COMPOSE_OPTS} rm -fsv

ci:
	docker-compose ${CI_COMPOSE_OPTS} up -d --build
	docker-compose ${CI_COMPOSE_OPTS} exec frontend npm test
	docker-compose ${CI_COMPOSE_OPTS} exec db /bin/sh -c "until pg_isready -q; do echo 'db unavailable. sleeping'; sleep 1; done"
	docker-compose ${CI_COMPOSE_OPTS} exec backend mix do ecto.reset, test
