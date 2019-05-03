include .bootstrap.mk

# start defining your targets below

hello: ## example hello world target
	echo "Hello $(firstword $(MAKEFILE_LIST))"
.PHONY: hello
