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

parse() {
    :
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

    # clear screen to use a clean slate
    clear_screen
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

cursor_up() {
    # https://vt100.net/docs/vt510-rm/CUU.html
    printf '\e[A'
}

cursor_down() {
    # https://vt100.net/docs/vt510-rm/CUD.html
    printf '\e[B'
}

#########
### control flow
#########
refresh() {
    hide_cursor
    clear_screen
    show_cursor
}

read_input() {
    # The read utility shall read a single logical line from standard input
    # into one or more shell variables.
    # '-r':, do not allow backslashes to escape any characters
    # '-n NCHARS': return after reading NCHARS
    # '-s': do not echo input from incoming terminal
    local key
    read -srn 1 key
    case ${key} in
        j)
            printf '\e[B'
            # cursor_up
            ;;

        k)
            printf '\e[A'
            # cursor_down
            ;;

        q)
            _RUNNING=0
            ;;

        *)
            ;;
    esac
}

main() {
    setup
    while [[ 1 ]]; do
        # refresh
        read_input

        # # if user chose to end application
        if [[ ${_RUNNING} -eq 0 ]]; then
            restore
            break
        fi

        # thanks, taken from: https://github.com/dylanaraps/fff
        # Exit if there is no longer a terminal attached.
        if [[ ! -t 1 ]]; then
            restore
            exit 1
        fi
    done
}

main "$@"
