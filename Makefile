
#!make

# import environnement file
DOCKER_PATH = ./docker
include $(DOCKER_PATH)/.env
-include $(DOCKER_PATH)/.env.*

CONTAINER_APP = mysquirrel-${APP_ENV}-app-1
DOCKER_COMPOSE = docker compose
DOCKER_EXEC = docker exec -it
DOCKER_EXEC_APP = ${DOCKER_EXEC} $(CONTAINER_APP)
CONSOLE = php bin/console
BIN_VENDOR = php vendor/bin/

COMPOSE_ARGS = -f $(DOCKER_PATH)/compose.yml
ENV_ARGS = --env-file $(DOCKER_PATH)/.env

ifeq ($(APP_ENV),dev)
	COMPOSE_ARGS = -f $(DOCKER_PATH)/compose.yml -f $(DOCKER_PATH)/compose.dev.yml
	ENV_ARGS = --env-file=$(DOCKER_PATH)/.env --env-file=$(DOCKER_PATH)/.env.dev
endif

help: ## Show this help.
	@echo "Symfony-And-Docker-Makefile"
	@echo "---------------------------"
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

docker-build:## docker build
	${DOCKER_COMPOSE} ${COMPOSE_ARGS} ${ENV_ARGS} build
.PHONY: docker-build

docker-up:## docker up
	${DOCKER_COMPOSE} ${COMPOSE_ARGS} ${ENV_ARGS} up -d
.PHONY: docker-up

docker-down:## docker down
	${DOCKER_COMPOSE} ${COMPOSE_ARGS} ${ENV_ARGS} down
.PHONY: docker-down

docker-exec-app:## docker exec app
	$(DOCKER_EXEC_APP) /bin/sh
.PHONY: docker-exec-app

composer:
	$(DOCKER_EXEC) composer
.PHONY: composer

composer-install:
	$(DOCKER_EXEC) composer install
.PHONY: composer

server-start: ## launch server
	$(DOCKER_EXEC) symfony serve:start -d
.PHONY: server-start

server-stop: ## stop server
	$(DOCKER_EXEC) symfony serve:stop
.PHONY: server-stop

dmm: ## apply migration
	$(DOCKER_EXEC) $(CONSOLE) d:m:m
.PHONY: dmm

dmmprev: ## rollback migration
	$(DOCKER_EXEC) $(CONSOLE) d:m:m prev
.PHONY: dmmprev

migrate: ## create migration file
	$(DOCKER_EXEC) $(CONSOLE) make:migration
.PHONY: migrate

entity: ## create migration file
	$(DOCKER_EXEC) $(CONSOLE) make:migration
.PHONY: database-update

cache-clear: ## cache clear
	$(DOCKER_EXEC) $(CONSOLE) cache:clear
.PHONY: cache-clear

phpcsf: ## php cs fixer
	$(DOCKER_EXEC) $(BIN_VENDOR)php-cs-fixer
.PHONY: phpcsf

phpstan: ## phpstan
	$(DOCKER_EXEC) $(BIN_VENDOR)phpstan
.PHONY: phpstan

phpunit: ## phpunit
	$(DOCKER_EXEC) $(BIN_VENDOR)phpunit
.PHONY: phpunit