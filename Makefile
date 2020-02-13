DEV_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.dev.yml -p caffe_dev
PROD_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.prod.yml -p caffe_prod
CI_COMPOSE_OPTS = -f docker-compose.yml -f docker-compose.ci.yml -p caffe_ci

dev.start: ## Build and start the application in development mode (to force rebuild add: ARGS="--build")
	docker-compose ${DEV_COMPOSE_OPTS} up ${ARGS}

dev.stop: ## Stop the development containers
	docker-compose ${DEV_COMPOSE_OPTS} stop ${ARGS}

dev.seed: ## Seed the development database with some dummy data
	docker-compose ${DEV_COMPOSE_OPTS} exec backend mix ecto.seed

dev.clean: ## Remove the development containers
	docker-compose ${DEV_COMPOSE_OPTS} rm -fsv

prod.start: ## Start the application in production mode (also runs the DB migrations)
	docker-compose ${PROD_COMPOSE_OPTS} up ${ARGS}

prod.stop: ## Stop the production containers
	docker-compose ${PROD_COMPOSE_OPTS} stop ${ARGS}

prod.seed: ## Seed the production database with the base data
	docker-compose ${PROD_COMPOSE_OPTS} exec backend bin/caffe eval "Caffe.Release.seed"

prod.exec: ## Execute commands on a production service e.g. make prod.exec ARGS="backend bash"
	docker-compose ${PROD_COMPOSE_OPTS} exec ${ARGS}

prod.console: ## Open an IEx session on the running backend service
	docker-compose ${PROD_COMPOSE_OPTS} exec backend bin/caffe remote

prod.clean: ## Remove the production containers
	docker-compose ${PROD_COMPOSE_OPTS} rm -fsv

ci: ## Runs all frontend and backend tests
	docker-compose ${CI_COMPOSE_OPTS} up -d --build
	docker-compose ${CI_COMPOSE_OPTS} exec frontend npm test
	docker-compose ${CI_COMPOSE_OPTS} exec db /bin/sh -c "until pg_isready -q; do echo 'db unavailable. sleeping'; sleep 1; done"
	docker-compose ${CI_COMPOSE_OPTS} exec backend mix do ecto.reset, test

help:
	@grep -E '^[a-zA-Z\.]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
