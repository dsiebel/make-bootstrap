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
