#!/bin/bash -rn

# FILENAME: shellstate-checker.sh (language=bash, locale=en_US)
# CREATED: 1/3/2016, 8:36:40 AM
# CAUTION: will use the compiled .pyc after first run, if it is run (see note)
#          or otherwise; when python3 fails, untrap DEBUG -- NB:we dont run
#          this script directly, we source it to keep it at our same SHLVL + environment.
# SUMMARY: This is the shell state checker that keeps vital shell options that could
#          break completion, script behavior, and redirections to std handles
#          like stdin/stdout/stderr which are assumed to be right. There is also
#          the option to add more python3 scripts per user in lib/shellstate-checker.d/*.pyc **2
#NOTEBENA: the -rn (restricted, norun) flag for bash above is to prevent users
#          from running this file in an abusive manner! it should not be
#          executable but just in case, this -r flag has been specified to
#          prevent directory changes or chroots, and -n ensures NO commands will
#          actually be executed. It is also used this way to perform validation that
#          this file works okay, during startup, in which case it will be trapped to
#          DEBUG, if it is okay -- or -- the trap will NOT be instated if bash finds
#          any_ errors in this file!!!
# **1 - please source, dont run! (use bash NOT sh,csh,zsh, etc)
# **2 - user scripts in the lib/shellstate-checker.d/ dir MUST be
#       in advanced PRE-COMPILED, text sources will NOT be ran as they
#       introduce too much overhead (as much as 1-2 seconds per script!)
# **3 - you may wish to keep this branch of directories on a solid
#       state device (SSD) that is faster at read/writes than your
#       hard disk drive (HDD). WARN: dollar store USB sticks are
#       famously slow and are NOT reccomended for anything except
#        emergency backup storage and are restricted to ~999 read/writes :(
#        [please use a regular cd in a case for protection!]
#
#TODO: add fast security
python3 "$AX_BASE/lib/shellchecker.py" || trap DEBUG
