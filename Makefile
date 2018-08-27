.PHONY: build dev lint test

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## "Installe" l'application sur le serveur
	git pull origin master
	make build
	pm2 start --env production

build: node_modules lint ## Construit le projet
	npx tsc

dev: build ## Lance le mode développement
	npx concurrently -k \
		-p "[{name}]" \
		-n "TypeScript,Node" \
		-c "yellow.bold,cyan.bold,green.bold" \
		"npx tsc -w" \
		"npx nodemon --inspect dist/index.js"

test: lint ## Lance les tests
	npx jest --forceExit --verbose --runInBand

wtest: lint ## Lance les tests à chaque modification
	npx jest --forceExit --verbose --runInBand --watchAll

lint: ## Lance le linter
	npx tslint -c tslint.json -p tsconfig.json

node_modules:
	yarn
