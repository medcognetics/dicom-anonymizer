PROJECT=dicomanonymizer
PYTHON=pdm run python

init: pdm.lock
	which pdm || pip install --user pdm
	pdm venv create -n $(PROJECT)
	pdm sync -d

pdm.lock:
	$(MAKE) update

update:
	pdm install -d

clean:
	find $(CLEAN_DIRS) -path '*/__pycache__/*' -delete
	find $(CLEAN_DIRS) -type d -name '__pycache__' -empty -delete
	find $(CLEAN_DIRS) -name '*@neomake*' -type f -delete
	find $(CLEAN_DIRS) -name '*,cover' -type f -delete
	find $(CLEAN_DIRS) -name '*.orig' -type f -delete
	pdm venv remove -y $(PROJECT)
	rm -f .pdm-python
	rm -r dist

reset:
	$(MAKE) clean
	$(MAKE) init

pypi:
	$(PYTHON) -m build
	$(PYTHON) -m twine upload dist/*