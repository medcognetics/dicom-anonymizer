.PHONY: clean clean-env check quality style test env upload upload-test

PROJECT=dicomanonymizer
CODE_DIRS=$(PROJECT) tests
PYTHON=pdm run python

check:
	$(MAKE) style
	$(MAKE) quality
	$(MAKE) types
	$(MAKE) test

clean:
	find $(CODE_DIRS) -path '*/__pycache__/*' -delete
	find $(CODE_DIRS) -type d -name '__pycache__' -empty -delete
	find $(CODE_DIRS) -name '*@neomake*' -type f -delete
	find $(CODE_DIRS) -name '*.pyc' -type f -delete
	find $(CODE_DIRS) -name '*,cover' -type f -delete
	find $(CODE_DIRS) -name '*.orig' -type f -delete
	rm -rf dist

clean-env:
	rm -rf .venv

deploy:
	pdm venv create
	pdm install --production --no-lock

init:
ifeq (, $(shell which pdm))
	$(error "No pdm in $(PATH), please install it to initialize this project")
else
	pdm venv create
	pdm install -d
endif

node_modules:
ifeq (, $(shell which npm))
	$(error "No npm in $(PATH), please install it to run pyright type checking")
else
	npm install
endif

quality:
	$(MAKE) clean
	$(PYTHON) -m black --check $(CODE_DIRS)
	$(PYTHON) -m autopep8 -a $(CODE_DIRS)

style:
	$(PYTHON) -m autoflake -r -i $(CODE_DIRS)
	$(PYTHON) -m isort $(CODE_DIRS)
	$(PYTHON) -m autopep8 -a $(CODE_DIRS)
	$(PYTHON) -m black $(CODE_DIRS)

test:
	$(PYTHON) -m pytest \
		-rs \
		--cov=./$(PROJECT) \
		--cov-report=term \
		./tests/

types: node_modules
	pdm run npx --no-install pyright tests $(PROJECT)

reset:
	$(MAKE) clean
	$(MAKE) clean-env
	$(MAKE) init
	$(MAKE) test
# TODO Add this back in
# $(MAKE) check

pypi:
	$(PYTHON) -m build
	$(PYTHON) -m twine upload dist/*
