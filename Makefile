SHELL := /bin/bash
FILE := $(lastword $(MAKEFILE_LIST))

PWD := $(shell pwd)
FILES := $(shell find ${PWD} -name '*.sh')

.PHONY: run vhs vhs-setup install uninstall
vhs-setup:
	@[ -n "$(shell pacman -Qs vhs)" ] || sudo pacman -S vhs
	@[ -f ./demo.tape ] || (vhs new demo.tape; printf "Be sure to edit the demo.tape for your vhs use-case!\n")

vhs: vhs-setup
	vhs < demo.tape

run:
	@./shmenu.sh -o this that theother -p menu

install:
	@sudo cp ./shmenu.sh /usr/bin/shmenu

uninstall:
	@[ -f /usr/bin/shmenu ] && sudo rm -i /usr/bin/shmenu

