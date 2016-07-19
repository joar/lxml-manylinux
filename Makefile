REPO_URL ?= "https://github.com/lxml/lxml.git"
REPO_PATH ?= ./lxml
SOURCE_TAG ?= master

LIBXML2_VERSION ?= "2.9.3"
LIBXSLT_VERSION ?= "1.1.29"

LIBXML2_PATH ?= "libxml2-$(LIBXML2_VERSION)"
LIBXSLT_PATH ?= "libxslt-$(LIBXSLT_VERSION)"

.PHONY: checkout-source
checkout-source:
	git clone "$(REPO_URL)" "$(REPO_PATH)"
	cd "$(REPO_PATH)" && git checkout "$(SOURCE_TAG)"

.PHONY: wheels
wheels:
	/io/travis/build-wheels.sh
