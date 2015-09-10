#!/bin/bash

if [[ $- =~ i ]]; then
	echo "commencing live test"
else
	echo "live function test cant proceed non-interactively"
	echo "usage: source \"$0\""
	exit 1
fi


livefunc__zone.test()
{
	echo "This is some text, edit me in  another editor, and then come back to see if it worked"
}

