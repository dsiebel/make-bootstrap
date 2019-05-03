# Export all Make variables by default to sub-make as well as Shell calls.
#
# Note that you can still explicitely mark a variable with `unexport` and it is
# not going to be exported by Make, regardless of this setting.
#
# https://www.gnu.org/software/make/manual/html_node/Variables_002fRecursion.html
export

# Disable/enable various make features.
#
# https://www.gnu.org/software/make/manual/html_node/Options-Summary.html
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables

# Set `help` as the default goal to be used if no targets were specified on the command line
#
# https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
.DEFAULT_GOAL:=help

# Never delete a target if it exits with an error.
#
# https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.DELETE_ON_ERROR:

# Disable the suffix functionality of make.
#
# https://www.gnu.org/software/make/manual/html_node/Suffix-Rules.html
.SUFFIXES:

# This executes all targets in a single shell. This improves performance, by
# not spawning a new shell for each line, and also allows use to write multiline
# commands like conditions and loops without escaping sequences.
#
# https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL:

# This makes all targets silent by default, unless VERBOSE is set.
ifndef VERBOSE
.SILENT:
endif

# The shell that should be used to execute the recipes.
SHELL       := bash
.SHELLFLAGS := -euo pipefail -c

# Determine the root directory of our codebase and export it, this allows easy
# file inclusion in both Bash and Make.
override ROOT := $(shell path="$(CURDIR)"; while [[ "$${path}" != "/" \
 && ! -f "$${path}/.root.mk" ]]; do path="$${path%/*}"; done; echo "$${path}")

# A generic help message that parses the available targets, and lists each one
# that has a comment on the same line with a ## prefix.
help: ## Display this help
	readonly pad=25
	targets() {
		local targets=()
		local pattern='[^:]+:[^#]*## .*'

		for mk in "$$@"; do
			while read -r line; do
				if [[ "$${line}" =~ $${pattern} ]]; then
					targets+=("$${line}")
				fi
			done < "$${mk}"
		done

		readarray -t targets < <(for t in "$${targets[@]}"; do echo "$$t"; done | sort -d)

		for target in "$${targets[@]}"; do
			printf "    \033[0;32m%-$${pad}s\033[0m %s\n" "$${target%%:*}" "$${target##*## }"
		done
	}

	echo
	echo -e "\033[0;33mUsage:\033[0m
		make [flags...] [target...] [options...]

	\033[0;33mFlags:\033[0m
		See \033[1;30mmake --help\033[0m

	\033[0;33mTargets:\033[0m"

	targets $(MAKEFILE_LIST)

	printf "\n\033[0;33mOptions:\033[0m\n    \033[0;32m%-$${pad}s\033[0m Set mode to 1 for verbose output \033[0;33m[default: 0]\033[0m\n\n" 'VERBOSE=<mode>'
.PHONY: help

# alternative, simpler help goal (requires comments _before_ the rule):
## help: display this help
# help: Makefile
# 	@sed -n 's/^##//p' $<