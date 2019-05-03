include .bootstrap.mk

# start defining your targets below

hello: ## example hello world target
	echo "Hello $(lastword $(MAKEFILE_LIST))"
.PHONY: hello