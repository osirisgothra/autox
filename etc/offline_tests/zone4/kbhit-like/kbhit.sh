#!/bin/bash
# still testing (NB!)

#
# kbhit.sh
# autox test phase document
# purpose: will either use a precompiled kbhit binary, a previously compiled C++ from
#          this script's last call defined in, or defined externally by some other means
#          (ie, a perl script) bound to AX_KBHIT, or, will fresh-compile, if a C++ compiler
#          is present, a new binary on-the-fly, to detect keyboard presses w/o having to empty
#          the keyboard's buffer.
#
# requires: one of:   1) a GNU compatible ($PATH/g++) C++ compiler supports at least ''classic'' C++ code
#                     2) a previously compiled binary or a equivalent script that polls the keyboard, named in AX_KBHIT
#                     3) already has ran this script one time w/o error, so that method 2) can be used (AX_KBIT stores its value)
#
# AX_KBHIT should be only set if it is valid, but will not be executed it if it is not executable, even if the file does exist!
# In that case, the AX_KBHIT may be overwritten (but not the file it pointed to). mktemp is responsible for coming up with new
# filenames for AX_KBHIT!
#
# binary dependencies:  (as they should appear with 'whatis')
#
#                       g++ (1)              - GNU project C and C++ compiler
#                       which (1)            - locate a command
#                       mktemp (1)           - create a temporary file or directory
# code dependencies:
#                       termios (3)
#                       tcgetattr (3)
#                       tcsetattr (3)        - get and set terminal attributes, line control, get and set baud rate
#
#                       setbuf (3)           - stream buffering operations
#                       bash: unistd: command not found
unistd: nothing appropriate.





if [[ -x $AX_KBHIT ]]; then
    eval "$AX_KBHIT" "$@"
    case $- in
        *i*) return $?;;
        *) exit $?;;
    esac
fi

if which gcc &> /dev/null; then
    TF=$(mktemp)".cpp"
    OF=$(mktemp)".out"
    g++ /dev/stdin -o "$OF" > $TF <<EOF
#include <stdio.h>
#include <sys/select.h>
#include <termios.h>
#include <stropts.h>
#include <asm-generic/ioctls.h>
#include <unistd.h>

int __kbhit()
{
	static const int STDIN = 0;
//	static bool initialized = false;
//	if (! initialized)
//	{         // Use termios to turn off line buffering
		termios term;
		tcgetattr(STDIN, &term);
		term.c_lflag &= ~ICANON;
		tcsetattr(STDIN, TCSANOW, &term);
//		setbuf(stdin, NULL);
//		initialized = true;
//	}

	int bytesWaiting;
	ioctl(STDIN, FIONREAD, &bytesWaiting);
	return bytesWaiting;
}


int main(int argc, char** argv)
{
	return __kbhit();
}

EOF
    if [[ $? -eq 0 ]]; then
        set -xv
        eval "$OF" "$@"
        set +xv
        # future calls to kbhit can go here
        export AX_KBHIT="$OF"
    else
        echo "compile failed"
    fi
else
    if which kbhit &> /dev/null; then
        kbhit "$@"
    else
        echo "no compiler and no 'kbhit' binary found, keystroke polling dependant features are not available!"