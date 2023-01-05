SHELL := /bin/bash
FILE := $(lastword $(MAKEFILE_LIST))

PWD := $(shell pwd)
FILES := $(shell find ${PWD} -name '*.sh')

.PHONY: run vhs vhs-setup
vhs-setup:
	@[ -n "$(shell pacman -Qs vhs)" ] || sudo pacman -S vhs

vhs: vhs-setup

run:
	@./shmenu

