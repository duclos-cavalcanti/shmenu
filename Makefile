SHELL := /bin/bash
MANDIR ?= /usr/share/man

PWD := $(shell pwd)
FILES := $(shell find ${PWD} -name '*.sh')

.PHONY: run vhs vhs-setup install uninstall
vhs-setup:
	@[ -n "$(shell pacman -Qs vhs)" ] || sudo pacman -S vhs
	@[ -f ./demo.tape ] || (vhs new demo.tape; printf "Be sure to edit the demo.tape for your vhs use-case!\n")

vhs: vhs-setup
	vhs < demo.tape

view:
	@[ -f ./.github/assets/demo.gif ] && (mpv ./.github/assets/demo.gif)

install-shmenu:
	@cp shmenu.sh /usr/bin/shmenu

install-man:
	@cp shmenu.1 $(MANDIR)/man1

install: install-shmenu install-man

uninstall:
	@rm -f /usr/bin/shmenu
	@rm -f $(MANDIR)/man1/shmenu.1

run:
	@./shmenu.sh -o this that theother -p menu -d

