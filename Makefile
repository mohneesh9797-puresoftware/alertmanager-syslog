GOVER := $(shell go version)

GOOS    := $(if $(GOOS),$(GOOS),linux)
GOARCH  := $(if $(GOARCH),$(GOARCH),amd64)
GOENV   := GO111MODULE=on CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH)
GO      := $(GOENV) go
GOBUILD := $(GO) build

LDFLAGS := -w -s

default: server

server: check
	$(GOBUILD) -ldflags '$(LDFLAGS)' -o bin/alertmanager-syslog cmd/server.go

lint:
	@golint ./...

vet:
	$(GO) vet ./...

check: lint vet

clean:
	@rm -rf bin

.PHONY: server