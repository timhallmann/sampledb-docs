VERSIONS := develop latest $(shell ls */version.txt | sed 's/\/version.txt//' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$$' | sort -Vr)
LATEST_VERSION := $(shell echo $(VERSIONS) | cut -f 3 -d' ')
DEVELOP_VERSION := $(shell sed 's/^v//' develop/version.txt)

all: build/merged

build:
	mkdir -p build

build/latest: latest/version.txt

latest/version.txt: $(LATEST_VERSION)/version.txt
	ln -s $(LATEST_VERSION) latest

build/merged: $(foreach version,$(VERSIONS),build/$(version))
	rm -rf $@
	VERSION_DIR=latest/docs \
	python3 -m sphinx \
		--builder html \
		--conf-dir=. \
		--html-define relative_path_to_versions=. \
		--html-define current_version=$(@F) \
		--html-define latest_version=$(LATEST_VERSION) \
		--html-define develop_version=$(DEVELOP_VERSION) \
		--html-define "versions=$(VERSIONS)" \
		latest/docs $@
	for version in $(VERSIONS); do mv build/$${version} build/merged/$${version}; done

build/%: build
	VERSION_DIR=$(@F)/docs \
	python3 -m sphinx \
		--builder html \
		--conf-dir=. \
		--html-define relative_path_to_versions=.. \
		--html-define current_version=$(@F) \
		--html-define latest_version=$(LATEST_VERSION) \
		--html-define develop_version=$(DEVELOP_VERSION) \
		--html-define "versions=$(VERSIONS)" \
		$(@F)/docs $@

clean:
	rm -rf build
	rm -rf latest

.PHONY: all clean
