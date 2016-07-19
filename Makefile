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
wheels: | deps
	/io/travis/build-wheels.sh

.PHONY: deps
deps: | libxml2 libxslt

.PHONY: libxml2
libxml2:
	curl ftp://xmlsoft.org/libxml2/libxml2-$(LIBXML2_VERSION).tar.gz | tar xz
	cd "$(LIBXML2_PATH)" && ./configure && make && make install

.PHONY: libxslt
libxslt:
	curl ftp://xmlsoft.org/libxml2/libxslt-$(LIBXSLT_VERSION).tar.gz | tar xz
	cd "$(LIBXSLT_PATH)" && ./configure && make && make install
