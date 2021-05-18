# DEV versions use Git short SHA-1, RELEASE versions use the latest Git tag.

DEV_VERSION := $(shell git rev-parse --short HEAD)
RELEASE_VERSION := $(shell git describe --tags --abbrev=0)

.PHONY: build-image
build-image:
	docker build . -t replicant:$(DEV_VERSION)

.PHONY: release-image
release-image:
	docker build . -t docker.io/tammert/replicant:$(RELEASE_VERSION) -t docker.io/tammert/replicant:latest
	docker push docker.io/tammert/replicant:$(RELEASE_VERSION)
	docker push docker.io/tammert/replicant:latest

.PHONY: build-binary
build-binary:
	CGO_ENABLED=0 go build -o replicant

.PHONY: github-release
github-release:
	gh release create $(RELEASE_VERSION)

.PHONY: release
release: release-image github-release
