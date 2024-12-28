
#!make

# import environnement file
DOCKER_PATH = ./docker
include $(DOCKER_PATH)/.env
-include $(DOCKER_PATH)/.env.*

CONTAINER_APP = mysquirrel-${APP_ENV}-app-1
DOCKER_COMPOSE = docker compose
DOCKER_EXEC = docker exec -it
DOCKER_EXEC_APP = ${DOCKER_EXEC} $(CONTAINER_APP)
CONSOLE = bin/console
BIN_VENDOR = vendor/bin

COMPOSE_ARGS = -f $(DOCKER_PATH)/compose.yml
ENV_ARGS = --env-file $(DOCKER_PATH)/.env

ifeq ($(APP_ENV),dev)
	COMPOSE_ARGS = -f $(DOCKER_PATH)/compose.yml -f $(DOCKER_PATH)/compose.dev.yml
endif

ENV_ARGS = --env-file=$(DOCKER_PATH)/.env --env-file=$(DOCKER_PATH)/.env.${APP_ENV}

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
	$(DOCKER_EXEC_APP) composer
.PHONY: composer

composer-install:
	$(DOCKER_EXEC_APP) composer install
.PHONY: composer

console-doctrine-migrations-migrate: ## apply migration
	$(DOCKER_EXEC_APP) $(CONSOLE) d:m:m
.PHONY: console-doctrine-migrations-migrate

console-doctrine-migrations-migrate-prev: ## rollback migration
	$(DOCKER_EXEC_APP) $(CONSOLE) d:m:m prev
.PHONY: console-doctrine-migrations-migrate-prev

console-make-migrate: ## create migration file
	$(DOCKER_EXEC_APP) $(CONSOLE) make:migration
.PHONY: console-make-migrate

cache-clear: ## cache clear
	$(DOCKER_EXEC_APP) $(CONSOLE) cache:clear
.PHONY: cache-clear

php-cs-fixer-dry: ## php cs fixer dry-run
	$(DOCKER_EXEC_APP) tools/php-cs-fixer/$(BIN_VENDOR)/php-cs-fixer fix src --dry-run
.PHONY: php-cs-fixer-dry

phpstan: ## phpstan
	$(DOCKER_EXEC_APP) $(BIN_VENDOR)/phpstan analyse
.PHONY: phpstan

phpunit: ## phpunit
	$(DOCKER_EXEC_APP) $(BIN_VENDOR)/phpunit
.PHONY: phpunit