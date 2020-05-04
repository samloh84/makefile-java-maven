SHELL := /bin/bash
.SHELLFLAGS := -ec

.PHONY: clean compile test package install

define _LOAD_MVNRC :=
	if [[ -f "~/.mvnrc" ]]; then \
		source "~/.mvnrc"; \
	fi; \
	if [[ -f "$(CURDIR)/.mvnrc" ]]; then \
		source "~/.mvnrc";  \
	fi
endef

all: clean compile package install

clean:
	set -euxo pipefail; \
	$(call _LOAD_MVNRC); \
	mvn clean

compile:
	set -euxo pipefail; \
	$(call _LOAD_MVNRC); \
	mvn compile


package:
	set -euxo pipefail; \
	$(call _LOAD_MVNRC); \
	mvn package

install:
	set -euxo pipefail; \
	$(call _LOAD_MVNRC); \
	mvn install
