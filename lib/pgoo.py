#!/usr/bin/env python3

__author__ = "gabriel sharp"

#
# pgoo.py
#
# syntax: pgoo [search text]
#
# <one line to give the program's name and a brief idea of what it does.>
# Copyright (C) <year>  <name of author>
#
# executable name table                   | suffix table      * = current value
# ----------------------------------------------------------------------------------------
# script/link name(s)	binary			  | suffix letter(s)  <website>-[modifier]
# ----------------------------------------------------------------------------------------
# 	pgoo,goo,g			x-www-browser	  | [none]            google-*
#   t 					www-browser       | d/D               duckduckgo-*
#   T                   links2 -g         | i                 *-imagesearch
#   f                   firefox			  | v                 *-video
#   c                   chrome			  |
#   e                   elinks            |
#   l                   links2            | l                 *-lucky
#                                         | [none]            *-web
#
# website table
# --------------------------------------------------------------------------------------
# url modifier          website <S1>=stridx 1, <S2>=stridx 2 (%s=term)      default?
# --------------------------------------------------------------------------------------
#  google               http://<S1>.google.com/search?<S2>q=%s              YES
#  duckduckgo           http://<S1>.duckduckgo.com/?q=%s<S2>                NO
#
# modifier table
# --------------------------------------------------------------------------------------
# url modifier
# video                 images              lucky       video           web
# --------------------------------------------------------------------------------------
#  google               S1=images           S2=BtnI=l   S1=video        S1=www
#  duckduckgo           S1=images           S2=+!       S1=video        S1=www
#
# --------------------------------------------------------------------------------------
# NOTES
# --------------------------------------------------------------------------------------
# 1) Command Parsing
#      * use the --debug for extra information        * the debugging variable must be
#        display during normal run time.                set to False in order for the
#                                                       feature to be turned off!!
#      * all other arguments are search terms
#      * help is generated automatically via --help
# 2) Developers/Forkers
#      * it is advised that all Python programming standards/checkers/validators be
#        used at all times. This file is to conform to the PEP standard as well as pylint,
#        pychecker, etc are also good choices. If forking, make sure you change the contact
#        information because I cannot support bugs in software *I* didnt write!
# 3) Testing
#      * Testing needed.  I was in a hurry to make this program, so feel free to submit any
#        bugs or lack of bugs in the program. Especially total failures!
#
# --------------------------------------------------------------------------------------
# LICENSE
# --------------------------------------------------------------------------------------
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Also add information on how to contact you by electronic and paper mail.
#
# If the program does terminal interaction, make it output a short notice like this
# when it starts in an interactive mode:
#
#    <program>  Copyright (C) <year>  <name of author>
#    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
#    This is free software, and you are welcome to redistribute it
#    under certain conditions; type `show c' for details.
#

#

import os
import sys
import argparse
import time
import re
from pathlib import Path
import math


# Generics
def separator(char: str='-') -> None:
	"""
	:param char:str or Any: simple character(s) to print
	:return: None
	The function is protected by division by zero errors when zero-length
	items are given. It also compensates for more than one char by dividing
	down. Nonprintable strings are replaced with dashes of equal length. Ie,
	the string: "\0\0\0" is changed to "---".
	...
	The variable 'char' is first converted from it's native type to str if needed
	This allows for non-str items to be sent (like numbers, lists, etc) though might not be pretty!
	...
	No string is printed at all if one of the following is True:
		- the RESULTING string is empty or zero length
		- the object type of 'char' is None
		- an exception is thrown before print is reached (not in our hands!)
	"""
	if char is None or len(char) < 1:
		return
	elif char is not str:
		char = str(char)
	else:
		pass
	try:
		print(char if char.isprintable() else ('-' * len(char)) * (
			int(math.floor(os.environ.get('COLUMNS', '80')) / len(char))))
	except Exception as e:
		print("separator(%s) threw exception (msg=%s)" % (char, str(e)))
		yield char
		yield e


# Variables

reflags = re.IGNORECASE | re.UNICODE
binaries = dict(
	pgoo="x-www-browser",
	goo="x-www-browser",
	g="x-www-browser",
	t="www-browser",
	T="links2 -g",
	f="firefox",
	c="chrome",
	e="elinks",
)
modifiers = {
	".l": "lucky",
	".v": "video",
	".[Dd]": "duckduckgo",
	"none": "none",
	".i": "images",
}
defaultsite = "google"
sites = {
	"google":
		dict(
			url="P|http://%s.google.com/search?q=%s",
			lucky="S|&btnI=l",
			video="1|video",
			images="1|images",
			none="1|www",
		),
	"duckduckgo":
		dict(
			url="P|http://%s.duckduckgo.com/?q=%s",
			lucky="S|+!",
			video="1|video",
			images="1|images",
			none="1|www",
		),
}
ver = {'major': 1, 'minor': 0, 'revision': 0, 'stage': "alpha", 'date': (time.ctime(os.path.getmtime(__file__)))}
VERSION_STRING = '%s version %d.%d-%d [%s] (%s)' % (
	"%(prog)s", ver['major'], ver['minor'], ver['revision'], ver['stage'], ver['date'])
debugging = True
parser = argparse.ArgumentParser()

# Intelligent Command Line Processor /w Auto-Help Generation

parser.add_argument('-v', '--version', action='version', version=VERSION_STRING)
parser.add_argument('-d', '--debug', action='store_true')
parser.add_argument('searchStrings', nargs='*', action='append')
args = parser.parse_args()
debugging = args.debug if debugging is False else debugging


# Setup/Preparations

if debugging is False:
	basename = Path(sys.argv[0]).name.split('.', 1)[0]
else:
	basename = 't-ddgl'
	print(args.searchStrings)
	separator()

(progname, modifier) = basename.split('-', 1) if '-' in basename else (basename, "none")
attribs = [modifiers[k] for k in modifiers.keys() if re.search(k, modifier, reflags) is not None]
binary = binaries.get(progname, binaries['pgoo'])

# force a site if none is specified
# [pseudocode: if not attribs in sites]
#   if not [a for a in attribs if a in sites.keys()] : attribs.append(defaultsite)
#
# step one, get site key and remove it from attributes to prevent confusion
#

site = [s for s in attribs if s in sites.keys()][0]

# step two, figure out attributes from related site

siteattribs = [sites[site][sa] for sa in sites[site].keys() if sa in attribs]

# step three, print out debug information, if debug is on

print("progname:", progname)
print("binary:", binary)
print("attribs:", attribs)
print("site: ", site)
print("siteattribs:", siteattribs)
