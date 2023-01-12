#!/bin/bash

#########
### globals
#########
_DEBUG=0

declare -a _OPTIONS
_CUR=1
_TOTAL=0
_CHOSEN=

_PROMPT="MENU"

_INPUT=

#########
### utils
#########
usage() {
  echo "
    NAME: shmenu - bash-based menu tui

    USAGE: shmenu.sh [ARGS]

    ARGS:
    -o | --options: list of elements to consider as options for the menu
    -p | --prompt:  the menu's prompt/title
    -h | --help:    print this text
    "
}

parse() {
    if [[ $# -ne 0 ]]; then
        while [[ $# -gt 0 ]]; do
           case $1 in
                -o|--options)
                    shift
                    # append options as long as the current arg isnt
                    # either empty or a possible flag/switch to other
                    # features
                    while [[ -n ${1} ]]; do
                        [[ ${1:0:1} == "-"  ]] && break
                        _OPTIONS+=(${1})
                        shift
                    done
                    _TOTAL="${#_OPTIONS[@]}"
                    ;;

                -p|--prompt)
                    shift
                    # either take the next argument as prompt, if it is
                    # somehow empty then take the default value of MENU
                    _PROMPT="${1:-${_PROMPT}}"
                    shift
                    ;;

                -d|--debug)
                    _DEBUG=1
                    shift
                    ;;

                -h|--help)
                    usage
                    exit 0
                    ;;

                *)
                    usage
                    exit 1
                    ;;
           esac
        done
    else
        printf "NO ARGUMENTS PROVIDED!\n"
        usage
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

    # trap allows us to capture and react to specific signals sent
    # to the running program.
    #
    # https://github.com/dylanaraps/writing-a-tui-in-bash#using-stty
    # In this case we're trapping the SIGWINCH signal which is
    # sent to the terminal and the running shell on window resize.
    # Callbacks the screen_size function when SIGWINCH is
    # received, thus updating the lines and columns variables
    trap 'screen_size' WINCH

    # clear screen to use a clean slate
    clear_screen

    # reset cursor to 2,2 so it fits into the [ ] boxes
    # and stays after the prompt
    set_cursor 2 2

    # draw the TUI
    draw

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
}

screen_size() {
    # https://github.com/dylanaraps/writing-a-tui-in-bash#getting-the-window-size
    # Get terminal size ('stty' is POSIX and always available).
    # This can't be done reliably across all bash versions in pure bash.
    read -r LINES COLUMNS < <(stty size)
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

push_cursor_pos() {
    printf '\e7'
}

pop_cursor_pos() {
    printf '\e8'
}

set_cursor() {
    local row="$1"
    local col="$2"

    # https://vt100.net/docs/vt510-rm/CUP.html
    # CUP - Cursor Position
    if [[ -z "$row" || -z "$col" ]]; then
        printf '\e[H'
    else
        printf "\e[${row};${col}H"
    fi
}

cursor_up() {
    # https://vt100.net/docs/vt510-rm/CUU.html
    printf '\e[A'
}

cursor_down() {
    # https://vt100.net/docs/vt510-rm/CUD.html
    printf '\e[B'
}

cursor_left() {
    # https://vt100.net/docs/vt510-rm/CUB.html
    printf '\e[D'
}

cursor_right() {
    # https://vt100.net/docs/vt510-rm/CUF.html
    printf '\e[C'
}

underline_text() {
    # https://github.com/dylanaraps/pure-bash-bible#text-colors
    printf '\e[4m'
}

highlight_text() {
    # https://github.com/dylanaraps/pure-bash-bible#text-colors
    printf '\e[7m'
}

italic_text() {
    # https://github.com/dylanaraps/pure-bash-bible#text-colors
    printf '\e[3m'
}

reset_text() {
    # https://github.com/dylanaraps/pure-bash-bible#text-colors
    printf '\e[m'
}

#########
### control flow
#########
draw_debug() {
    local row=
    local col=

    # PRE_DRAW
    push_cursor_pos

    # 1 for the prompt, 1 for the help menu and ${TOTAL} for all options
    row=$((1 + $_TOTAL + 1 + 1))
    col=1
    set_cursor $row $col

    # DRAW
    italic_text
    printf "last key: $_INPUT | LINES: ${LINES} | COLS: ${COLUMNS}"
    reset_text

    # POST_DRAW
    pop_cursor_pos
}

draw() {
    # PRE_DRAW
    push_cursor_pos
    set_cursor 1 1

    # PROMPT
    underline_text
    printf "${_PROMPT}?\n\r"
    reset_text

    # OPTIONS
    for o in "${_OPTIONS[@]}"; do
        printf "[ ] ${o}\n\r"
    done

    # KEYBINDINGS
    highlight_text
    printf "j:up | k:down | l/enter:selects | q/h: quits\n\r"
    reset_text


    # POST_DRAW
    pop_cursor_pos
}

refresh() {
    # was supposed to do much more, but we simplified
    # the program, will however leave a refresh function
    # even if unnecssary here for future modifications
    hide_cursor
    [[ $_DEBUG -eq 1 ]] && draw_debug
    show_cursor
}

main() {
    parse "$@"
    setup
    while [[ true ]]; do
        refresh
        # The read utility shall read a single logical line from standard input
        # into one or more shell variables.
        # '-r':, do not allow backslashes to escape any characters
        # '-n NCHARS': return after reading NCHARS
        # '-s': do not echo input from incoming terminal
        local key
        read -srn 1 _INPUT
        case ${_INPUT} in
            j) # down
                if [[ ${_CUR} -lt ${_TOTAL} ]]; then
                    cursor_down
                    ((_CUR++))
                fi
               ;;

            k) # up
                if [[ ${_CUR} -gt 1 ]]; then
                    cursor_up
                    ((_CUR--))
                fi
                ;;

            l|"") # user chose/selected option
                _CHOSEN=${_OPTIONS[((_CUR - 1))]}
                restore
                break
                ;;

            h|q) # quit
                restore
                break
                ;;

            *)
                ;;
        esac

        # thanks, taken from: https://github.com/dylanaraps/fff
        # Exit if there is no longer a terminal attached.
        if [[ ! -t 1 ]]; then
            restore
            exit 1
        fi
    done
}

main "$@"
[ -n "${_CHOSEN}" ] && printf "${_CHOSEN}\n" || exit 0
