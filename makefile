.DEFAULT_GOAL := help

# NOTE: There is no cargo command to JUST install dependancies without also building the project
#       Open issue: https://github.com/rust-lang/cargo/issues/2644
install: ## Install project dependancies (rust will install dependancies on build)
	@npm install

format: ## Format rust and javascript source code
	@cd ./rust; cargo fmt \
	&& npm run format

format-check: ## Check formatting of rust and javascript source code
	@cd ./rust; cargo fmt -- --check \
	&& npm run format-check

lint: ## Lint rust and javascript source code
	@cd ./rust; cargo clippy \
	&& npm run lint

build: ## Build rust and javascript and have webpack bundle everything
	@npm run build

# TODO: Implement javascript tests
test: ## Run rust and javascript tests in firefox and chrome
	@wasm-pack test --firefox --chrome rust/main_crate \
	&& wasm-pack test --firefox --chrome rust/sub_crate \

start: ## Start webpack dev server for running the application with hot reloading on rust or javascript code changes
	@npm run start

# NOTE: Not using cargo clean and similar because this is more general
clean: ## Clean up all the installed dependancies and build artifacts
	@rm -rf dist
	@rm -rf node_modules
	@rm -rf rust/{{project-name}}/pkg
	@rm -rf rust/target
	@rm -rf rust/Cargo.lock

dshell: ## Open a shell session inside the projects docker container
	@docker exec -it {{project-name}}-container bash

dclean: ## Remove projects docker container and image
	@docker stop {{project-name}}-container
	@docker rm {{project-name}}-container
	@docker rmi -f {{project-name}}-image

dbuild-image: ## Build projects docker image
	@docker build --tag {{project-name}}-image .

dcreate-container: ## Create projects docker container
	@docker create \
	--name {{project-name}}-container \
	--volume $(shell pwd):/app_src_volume \
	--publish 8080:8080/tcp \
	{{project-name}}-image

dstart-container: ## Start projects docker container
	@docker start {{project-name}}-container

dsetup: ## Setup project inside docker from scratch
	@make dbuild-image && make dcreate-container && make dstart-container

# Usage: make indock cmd=build
indock: ## Run a make command inside docker, example usage: make indock cmd=build
	@docker exec {{project-name}}-container make $(cmd)

# Source: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'