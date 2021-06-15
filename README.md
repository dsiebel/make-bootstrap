# make-bootstrap

Basic, universal setup for projects using Makefiles.

## Prerequisites

* Make (duh! ideally v4+)

## Installation

Just download the most recent .bootstrap.mk file from Github to
your project's root directory

```sh
curl -lO https://raw.githubusercontent.com/dsiebel/make-bootstrap/master/.bootstrap.mk
```

and start using it in your Makefile (see [Makefile](/Makefile))

```Makefile
include .bootstrap.mk

# your make targets here
```

## Updating

The bootstrap file provides a `self-update` target, which essentially
executes the same cURL seen above under "Installation":

```sh
$ make self-update
backing up existing bootstrap file...
downloading latest version from github.com/dsiebel/make-bootstrap (master)
done!
```

## Alternative `help` goals

Simple version using `sed`. Requires comment _before_ the target declaration

```Makefile
## help: display this help
help:
	@sed -n 's/^##//p' $(MAKEFILE_LIST)
```

Another simple but sophisticated version using `awk`that supports sections via `##@`.
```Makefile
##@ Help section

help: ## Shows this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[.a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
```
