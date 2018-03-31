#!/bin/bash -r "dont run anymore"

#
#   name:  nano -> /autox/etc/extras/nano.termdetect.standin
#   desc: special 256-color terminal preconfiguration file
#
#   details:
#     original name (source): nano.termdetect.standin
#    name to link or copy to: nano
#              install notes: rename original to nano-binary-image
#
#
#    Copyright (C) 2003-2016 Paradisim Enterprises, LLC
#
#    (Please see the end of this text for revision history)
#
#    Written by Gabriel T. Sharp <osirisgothra@hotmail.com>
#    Latest versions of this and all other projects can be
#    obtained by visiting <https://github.com/osirisgothra>
#
#    note: gitorious is no longer available, please use github!
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#    REVISION HISTORY
#
#    Sun May 29 07:02:25 EDT 2016   osirisgothra on larnica initially created this file
#                                   with the original name, "nano.termdetect.standin"
#    WARNINGS
#       --->> NB! NB! NB! NB!
#       unless you like losing data, please do not MOVE this script over the original nano until
#       you have safely moved nano itself. Furthermore, instead of moving this script, it is advised
#       that you SOFTLINK it instead. This way the script won't be deleted upon a system update.
#       FURTHERMORE... the original binary should be kept somewhere on the system path with a different
#       name like the suggested 'nano-binary-image'. If this script disappears it means bash was upgraded
#       and you need to relink it, after setting nano-binary-image of course. A self-installer was not
#       written for this script because it is likely to be used by few. Unless it changes thats the way
#       it will stay forever. My proper home is in <autox-distro>/etc/extras ! NB ! NB ! NB <<---
#

# WARN_TIMEOUT  number of seconds before automatically proceeding during warning message
# IGNORED_TERMS_FILE    filename where a list of one-entry-per-line can be found to add(not replace!) to IGNORED_TERMS
# IGNORED_TERMS         list of terminals to ignore from warning message
# SKIP_WARNING_MSG      1=do not show warning at all (warning! defeats entire purpose of this script!)
# NANO_BINARY           true name or path to nano binary image

declare -i WARN_TIMEOUT=3
declare -g IGNORED_TERMS_FILE="/etc/nano-ignored-terms"
declare -a IGNORED_TERMS=( "linux" )
declare -i SKIP_WARNING_MSG=0
declare -g NANO_BINARY="/bin/nano-binary-image"

function sleep()
{
    # transparently preserve return value from last command (RV)
    # and last command's last argument (LC) must be on SAME LINE to work!
    local RV=$?, LC=$_
    if [[ $# -eq 0 ]]; then
        sleep $WARN_TIMEOUT
        true $LC
        return $RV
    fi
    # invalid values will be set to zero
    TMOUT=$1
    echo "[please wait or press a key to proceed]"
    read -sn1
    TMOUT=0
    echo "$@"
    true $LC
    return $RV
}

### main script ###

# 1) establish user

if [[ $USER == root ]]; then
    if [[ `tty` =~ pts ]]; then
        export TERM=xterm-256color
    elif pgrep fbterm; then
        export TERM=fbterm
    else
        export TERM=linux
    fi
    NANO_NONROOT_USER=0
else
    NANO_NONROOT_USER=1
fi

# 2) load external data

if [[ -r $IGNORED_TERMS_FILE ]]; then
    echo "found list of ignored terminals in $IGNORED_TERMS_FILE"
    IFS=$'\n'
    IGNORED_TERMS=(
            `cat $IGNORED_TERMS_FILE`
    )
    unset IFS
    echo "loaded ignored terminals: ${IGNORED_TERMS[@]}"
else
    echo "ignored terminals (defaulted to): ${IGNORED_TERMS[@]}"
fi

if ! [[ $TERM =~ 256color ]]; then
    for IGNORED_TERM_ENTRY in "${IGNORED_TERMS[@]}"; do
        if [[ $TERM == $IGNORED_TERM_ENTRY ]]; then
            SKIP_WARNING_MSG=1
        fi
    done
    export TERM=xterm-256color
    if [[ $SKIP_WARNING_MSG != 1 ]]; then
        # additional warning about linux consoles
        # you must purposely get rid of the linux exception to see this (above)
        if [[ $TERM == linux ]]; then
            echo "Warning: console/text terminals are not 256-color capable, please use an X-compatible terminal or a framebuffer terminal."
            sleep $WARN_TIMEOUT
        fi
        echo "Warning: non-256 color terminal, 256-color syntax files will operate incorrectly."
        sleep $WARN_TIMEOUT
    fi
fi
command sleep 0.475 # allow user to peek at message real quick
NANO_DEST=$(mktemp -d)
# entering critical section, dont allow these signals to succeed
trap '' SIGSTOP;trap '' SIGTERM;trap '' SIGHUP
trap '' SIGQUIT;trap '' SIGTSTP;trap '' SIGTTIN;trap '' SIGTTOU
cp "$NANO_BINARY" "$NANO_DEST/nano"
"$NANO_DEST/nano" "$@"
command sleep 1.475
rm -fr "${NANO_DEST}"
printf '[3A[2K\n[2K\n[2K'

