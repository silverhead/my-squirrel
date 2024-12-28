
#!make

SHELL:=bash

default: help

COLOR_YELLOW:=33

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
ENV_ARGS = --env-file=$(DOCKER_PATH)/.env --env-file=$(DOCKER_PATH)/.env.${APP_ENV}

ifeq ($(APP_ENV),dev)
	COMPOSE_ARGS = -f $(DOCKER_PATH)/compose.yml -f $(DOCKER_PATH)/compose.dev.yml
endif

.PHONY: help
help: ## Show the help with the list of commands
	@clear
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<command>\033[0m\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[0;33m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""

##@ Docker commands

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

##@ Composer commands

composer: ## run composer
	$(DOCKER_EXEC_APP) composer
.PHONY: composer

composer-install: ## run composer install
	$(DOCKER_EXEC_APP) composer install
.PHONY: composer-install

##@ Symfony console commands

doc-migrate: ## apply migration (doctrine:migrations:migrate)
	$(DOCKER_EXEC_APP) $(CONSOLE) d:m:m
.PHONY: doc-migrate

doc-migrate-prev: ## rollback migration (doctrine:migrations:migrate --prev)
	$(DOCKER_EXEC_APP) $(CONSOLE) d:m:m prev
.PHONY: doc-migrate-prev

make-migrate: ## create migration file (make:migration)
	$(DOCKER_EXEC_APP) $(CONSOLE) make:migration
.PHONY: make-migrate

cache-clear: ## cache clear
	$(DOCKER_EXEC_APP) $(CONSOLE) cache:clear
.PHONY: cache-clear

##@ Quality tests commands

php-cs-fixer-dry: ## php-cs-fixer : scan code to check PHP Coding standards issues (without fix)
	$(DOCKER_EXEC_APP) tools/php-cs-fixer/$(BIN_VENDOR)/php-cs-fixer fix src --dry-run
.PHONY: php-cs-fixer-dry

php-cs-fixer: ## php-cs-fixer : scan code to check PHP Coding standards issues (auto fix issues)
	$(DOCKER_EXEC_APP) tools/php-cs-fixer/$(BIN_VENDOR)/php-cs-fixer fix src
.PHONY: php-cs-fixer

phpstan: ## phpstan : scan code to check code to find obvious bugs & tricky bugs
	$(DOCKER_EXEC_APP) $(BIN_VENDOR)/phpstan analyse
.PHONY: phpstan

phpunit: ## phpunit : run tests
	$(DOCKER_EXEC_APP) $(BIN_VENDOR)/phpunit
.PHONY: phpunit