GOVER := $(shell go version)

GOOS    := $(if $(GOOS),$(GOOS),linux)
GOARCH  := $(if $(GOARCH),$(GOARCH),amd64)
GOENV   := GO111MODULE=on CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH)
GO      := $(GOENV) go
GOBUILD := $(GO) build

COMMIT    := $(shell git describe --no-match --always --dirty)
BUILDTIME := $(shell date '+%Y-%m-%d %T %z')

PKG := github.com/AstroProfundis/alertmanager-syslog
LDFLAGS := -w -s
LDFLAGS += -X "$(PKG)/pkg/version.GitHash=$(COMMIT)"
LDFLAGS += -X "$(PKG)/pkg/version.BuildTime=$(BUILDTIME)"

default: all

all: check server

server:
	$(GOBUILD) -ldflags '$(LDFLAGS)' -o bin/alertmanager-syslog cmd/*.go

lint:
	@golint ./...

vet:
	$(GO) vet ./...

check: lint vet

clean:
	@rm -rf bin

.PHONY: server
