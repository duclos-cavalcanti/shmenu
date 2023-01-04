#!/bin/bash

#########
### globals
#########
_RUNNING=1

#########
### utils
#########
usage() {
  echo "
    NAME: shmenu - bash-based menu tui

    USAGE: shmenu.sh [ARGS]

    ARGS:
    "
}

dependency() {
    local program="$1"
    if ! command -v ${program} &>/dev/null; then
        echo "program is not installed"
        exit 1
    fi
}

#########
### TUI
#########
setup() {
    # https://vt100.net/docs/vt100-ug/contents.html
    # Modes: Wraparound
    printf '\e[?7l'

    # https://vt100.net/docs/vt510-rm/DECCRA.html
    # stores initial terminal state
    # uses DECCRA - copy rectangular area command
    printf '\e[?1049h'

    # stty changes and prints terminal line settings
    # -echo, removes the echoing/visual typing of user input
    stty -echo
}

restore() {
    # https://vt100.net/docs/vt100-ug/contents.html
    # Modes: Wraparound
    printf '\e[?7h'

    # https://vt100.net/docs/vt510-rm/DECCRA.html
    # restore previous terminal state
    # uses DECCRA - copy rectangular area command
    printf '\e[?1049l'

    # stty changes and prints terminal line settings
    # -echo, enables the echoing/visual typing of user input
    stty echo
}

clear_screen() {
    # https://vt100.net/docs/vt510-rm/ED.html
    # ED - Erase in Display
    # Arg 2: complete display
    printf '\e[2J'

    # https://vt100.net/docs/vt510-rm/CUP.html
    # CUP - Cursor Position
    # restores cursor to 0,0 or 1,1
    printf '\e[H'
}

hide_cursor() {
    # https://vt100.net/docs/vt510-rm/DECTCEM.html
    # '\e[?25l': makes cursor invisible
    printf '\e[?25l'
}

show_cursor() {
    # https://vt100.net/docs/vt510-rm/DECTCEM.html
    # '\e[?25l': makes cursor visible
    printf '\e[?25h'
}

#########
### control flow
#########
refresh() {
    hide_cursor
    clear_screen
    show_cursor
}

parse() {

}

main() {
    setup
    while [[ ${_RUNNING} ]]; do
        refresh

    done
    restore
}

main "$@"
