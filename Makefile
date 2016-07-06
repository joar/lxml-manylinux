REPO_URL ?= "https://github.com/lxml/lxml.git"
REPO_PATH ?= ./lxml
SOURCE_TAG ?= master

.PHONY: checkout-source
checkout-source:
	git clone "$(REPO_URL)" "$(REPO_PATH)"
	cd "$(REPO_PATH)" && git checkout "$(SOURCE_TAG)"
