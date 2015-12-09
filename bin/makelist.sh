#!/bin/bash -H - 
#===============================================================================
#
#          FILE: makelist.sh
# 
#         USAGE: ./makelist.sh 
# 
#   DESCRIPTION: Create Agnostic Perl Library
#                [for developer browsing/content editing only]
#
# 
#       OPTIONS: in-program setup allows for customized perl/version
#  REQUIREMENTS: perl needs to be in PATH, setting PERL5LIB couldnt hurt either
#                however it is not required as far as I can tell; mostly.
#                also: grep sed stat *sleep cp mktemp *true *false
#                *=bash builtins take over the binary in most cases
#          BUGS: waitforkeys and indexof limited to 254 return values
#         NOTES: workaround for above: using echo to return results too
#				 big for the shell's script 'return' values (0-255) 
#                255 is always used as the 'error' code on functions
#                that give back a numeric result (like an offset) since
#                in these cases 0 cannot be an error!
#        AUTHOR: Gabriel Thomas Sharp (gts), etherial_raine@outlook.com
#  ORGANIZATION: Paradisim Enterprises, LLC, PA/PGH/USA
#       CREATED: 03/12/2015 15:45 (3:45 PM) EDT
#      REVISION: 03/29/2015 01:23 (1:23 AM) EDT ADDED HEADER+AUTODETECT
#                                               ADDED TO REPOSITORY -> GXB/T
#===============================================================================


# a few options need set - the first being self explanitory :)

#set -o nounset                              # Treat unset variables as an error
shopt -s interactive_comments
set +Hxv						# turn off: history expansion with !, debug and trace OFF by default
shopt -s extglob				# turn on: extended glob handling (ie, !(all_except_this_file))
shopt -s extdebug				# turn on: extended debugging features (see below)
shopt -s nullglob			    # turn on: return NOTHING when a glob matches nothing
#shopt -s globstar
#shopt -s dotglob

IFS=$'\n'						# field separator: newline (for find and array ops)

shopt -s dotglob
[[ $WANTDEBUG -eq 1 ]] && set +xv # turn debugging back on if user wants it

if stat makelist.sh &> /dev/null; then
	echo
echo "[3m"
echo "WARNING: makelist.sh is in the same directory,          [    WARNING    ]"
echo "         you may wish to abort and try it from          [  press CTRL+C ]"
echo "         an empty folder - proceeding in 6 seconds...   [   to abort!   ]"
echo "[0m"
	sleep 6	
fi	

if stat !(makelist.sh) &> /dev/null ; then
	echo "ERROR: The following files are in this directory: " **	
	echo "The directory MUST BE EMPTY, you can't do this unless you are in one!!!"
	echo "I will not delete files for you, you must do this on your own (dont delete mklist.sh!)"
	exit 1
fi

# POS indexof(CHAR STRING) = finds CHAR in string and returns its POS
indexof() { I=$2; for ((i=0;i<${#I};i++)); do if [[ ${I: i:${#1}} == $1 ]]; then declare -g indexof=$i;	return $i; fi; done; declare -g indexof="nil"; return -1; }
# BOOL waitforkeys(STRING) = waits for a letter in STRING to be pressed, returns TRUE if normal press happened
waitforkeys() { unset REPLY; declare -g REPLY=""; until [[ $REPLY =~ ^[$1]$ ]]; do read -sn1; done; echo $REPLY; return 0; }


PERLVER=5.18
PERLVERL=${PERLVER}.2
echo "We can use the built-in version, $PERLVERL, what do you"
echo "want to do:"
echo
echo " [o]  Specify Your Own Version"
echo " [k]  Keep the Default $PERLVERL [DEFAULT]"
echo
echo -ne "[o,k]:"
waitforkeys ok

[[ $REPLY == o ]] && {
	while true; do
		echo -n " Enter full version number > "
		read PERLVERL
		PERLVER="${PERLVERL%.*}"
		echo "Target Version Set:"
		echo "    - Full Version (Long) = $PERLVERL"
		echo "    - Short Version (Maj.Min) = $PERLVER"
		echo "Is this okay? [y/n]"
		waitforkeys yn			
		[[ $REPLY == y ]] && break
	done
}

if which perl &> /dev/null; then
	
	echo
	echo "This script has builtin locations for libraries, which would you"
	echo "like to use:"
	echo
	echo " [p] Get perl from ($(which perl)) (more accurate)"
	echo " [b] Use Builtin (more secure)"
	echo 
	echo "[p,b]:"
	waitforkeys pb
else
	REPLY=b
fi

echo

[[ $REPLY == p ]] && {
	echo "getting items from perl..."
	ITEMS=( $(perl -V | perl -wne 'BEGIN { our @DEST }; if (/\@INC\:/ .. /^\./m) { push @DEST,$_ } END { print( (@DEST)[1..$#DEST-1] ); }') )
} || {	
	echo "using builtin items..."

ITEMS=( 	/etc/perl
			/usr/local/lib/perl/$PERLVERL
			/usr/local/share/perl/$PERLVERL
			/usr/lib/perl5
			/usr/share/perl5
			/usr/lib/perl/$PERLVER
			/usr/share/perl/$PERLVER
			/usr/local/lib/site_perl )
			
}

echo "The following directories will be scanned: "
echo
for x in "${ITEMS[@]}"; do echo $x; done
echo
echo "note: a 'no' answer here will abort the procedure!"
echo
echo "Is this okay [y,n]: "
waitforkeys yn

if [[ $REPLY != y ]]; then
	exit 1
fi
echo "Great! starting procedure [3 seconds], press CTRL+C anytime to stop..."
sleep 2.5
echo -ne "creating logfile..."
LOG=$(mktemp)
echo "$LOG"
sleep 1
echo "starting parse..."						
SUBITEMS=( )
declare -i TOTAL=${#ITEMS[@]}
declare -i CUR=0
declare -i PERC=0
declare -i SICNT=$TOTAL
for I in ${ITEMS[@]}; do
	let CUR++
	PERC=$(( (TOTAL*100)/(CUR*100) ))	
	SUBITEMS=( $I/* $I/.[^.]* )
	SICNT+=${#SUBITEMS[@]}
	cp --symbolic-link --verbose --recursive --no-clobber "${SUBITEMS[@]}" . &>> "$LOG"
	echo -ne "\e[s\e[K$PERC % done...\e[u"
done	
echo -e "\e[K100 % -- done ($SICNT subitems under $TOTAL items)!"





