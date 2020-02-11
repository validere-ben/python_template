.DEFAULT_GOAL := help

help: ## display this message
	@echo "usage: make [target]"
	@echo
	@echo "available targets:"
	@grep -h "##" $(MAKEFILE_LIST) | grep -v grep  | column -t -s '##'
	@echo

.PHONY: init
init: ## install pipenv and dev deps
	pip install pipenv --upgrade
	pipenv clean
	pipenv install --dev

.PHONY: all
all: ## run code formatter, linting, and tests
all: format lint coverage

.PHONY: format
format: ## run code formatters
	pipenv run isort --recursive .
	pipenv run black .

.PHONY: check_format
check_format: ## check for code formatter errors
	pipenv run black . --check --diff

.PHONY: lint
lint: ## run mypy, flake8, and isort linter checks
	pipenv run mypy --config-file=./mypy.ini .
	pipenv run flake8 .
	pipenv run isort --check-only --recursive .

.PHONY: test
test: ## run test suite
	pipenv run python -m pytest -v tests

.PHONY: coverage
coverage: ## run test suite and output coverage files
	pipenv run pytest \
		--verbose \
		--cov-report term \
		--cov-report html:coverage/html \
		--cov-report xml:coverage/coverage.xml \
		--cov-report annotate:coverage/annotate \
		--cov=pyb \
		tests