#!/usr/bin/python3

__author__ = "Gabriel Thomas Sharp"

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


# namespace imports
import os
import sys
import argparse
import time
import re
import shutil

# namespace symbol imports
from logging import log, DEBUG
from pathlib import Path

# Function Definitions


def separator(char: str='-')->None:
	""" 
	:param char:str or Any: simple character(s) to print
	:return: None
	-Zero length or 'None' is printed as '='
	-Objects are printed as str(obj)
	-Non-printable chars are replaced with '-'s
	-Length is Divided Up To Fill > 1 char strings too
	-If Length isn't enough, then the remaining chars are filled with as many chars from the string as possibly can fit.
	"""
	if char is None or not len(char):
		char = '='
	if type(char) is not str:
		char = str(char)
	elif not char.isprintable():
		char = '-' * len(char)
	cols = shutil.get_terminal_size().columns   # zero based from one based
	leftover = len(char) % cols
	print(char * (cols // len(char)))
	if leftover and len(char) > 1:
		print(char[:leftover])


def show_listing(pd: dict, sd: dict) -> None:
	"""
	show_listing(pd,sd)
	:param pd = dict pf prefix modifiers
	:param sd = dict of suffix modifiers
	:return: None
	Display listing of possible binaries that can either be
	symlinks to program name, or, used with the -b/--binary
	flag.
	"""
	suffixes = {'': ''}
	prefixes = {'': ''}    # allow blanks into combination pair to account for absent entries
	if 'none' in sd:
		del(sd['none'])
	if 'none' in pd:
		del (pd['none'])
	if len(sd) == 0 or len(pd) == 0:
		raise ValueError("Must not pass either argument empty. traceback obj set to pd/sd").with_traceback(show_listing)
	for s in sd.keys():
		(suffixes if s.startswith('.') else prefixes)[re.sub('[\.\[\]]', '', s)] = sd[s]
	combinations = [x + ('-' if len(y + z) > 0 else "") + (y[1] if len(y) > 1 else y) + z for x in pd.keys()
																	for y in prefixes.keys() for z in suffixes.keys()]
	combinations.sort()
	combinations.reverse()
	print('combinations')
	separator('_')
	print("%10s | %-20s %-40s %-20s" % ("--binary", "binary", "urlstring", "pos\turl-modifiers"))
	separator('_')
	for c in combinations:
		combos = translate(c)
		print("%10s | %-20s %-40s %-20s" %
								(c, combos['binary'], combos['url'],
									re.sub("[\[\]']", '', str(combos['siteAttributes']).replace('|', '\t'))))
	separator('_')
	print("pos meanings: 1 = site-prefix modifier (www,images,etc)  S = suffix modifier (appended)*")
	print("              NONE = default prefix (www) and suffix (nothing) are used when not specified.")
	separator('-')
	print("* to conserve list length, modifiers from different 'pos' indexes can be combined but are not shown here!")
	separator(' ')
	return


def translate(base: str) -> dict:
	global sites, binaries, modifiers, defaultSite
	(program, modifier) = base.split('-', 1) if '-' in base else (base, "none")
	attributes = [modifiers[k] for k in modifiers.keys() if re.search(k, modifier, regexFlags) is not None]
	binary = binaries.get(program, binaries['pgoo'])
	order = [s for s in attributes if s in sites.keys()]
	site = order[0] if len(order) is not 0 else defaultSite
	site_attributes = [sites[site][sa] for sa in sites[site].keys() if sa in attributes]
	return dict(progname=program, modifier=modifier, attribs=attributes, binary=binary, site=site,
													url=sites[site]['url'], siteAttributes=site_attributes)


def get_base_name(args):
	if type(args.binary) is str and len(args.binary) > 0:
		if args.binary.lower() == 'list':
			show_listing(binaries, modifiers)
			return None
		else:
			return args.binary
	else:
		path = re.match('[^.]+', Path(sys.argv[0]).name)
		log(DEBUG, "%20s : %-20s" % ("pm", path))
		if path is None:
			return binaries.get("default", __name__)
		else:
			return path.group(0)


def format_url(url: str, site_modifiers: list, search_strings: list) -> str:
	len(re.search("{[0-9]}",url).group())
	positionals = [''] * url.count("%s")        # we will need them whether they get used or not
	for (pos, item) in [str(x).split('|') for x in site_modifiers]:
		positionals[int(pos) if pos != "S" else 0] = item
	positionals.insert(1, search_strings)
	return url.format(*positionals)


# Global Variables (Access them with pgoo.variable_name outside this module)

defaultBinary = "g"
regexFlags = re.IGNORECASE | re.UNICODE
binaries = {
	__name__: defaultBinary,
	'none': defaultBinary,
	'pgoo': "x-www-browser",
	'goo': "x-www-browser",
	'g': "x-www-browser",
	't': "www-browser",
	'T': "links2 -g",
	'f': "firefox",
	'c': "chrome",
	'e': "elinks"
}
modifiers = {
	".l": "lucky",
	".v": "video",
	"[Dd]": "duckduckgo",
	"none": "none",
	".i": "images",
	"[Gg]": "google",
}
defaultSite = "google"
sites = {
	"google":
		dict(
			url="P|http://{0}.google.com/search?q={1}",
			lucky="S|&btnI=l",
			video="1|video",
			images="1|images",
			none="1|www",
		),
	"duckduckgo":
		dict(
			url="P|http://{0}.duckduckgo.com/?q={1}",
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
program_description = "Relay Links to DuckDuckGo, Google and other search engines"
program_copyright = "(C)2014-2016 Gabriel Thomas Sharp, All Rights Reserve\n" + \
	"Licensed under the GNU GPL3, see http://gpl.gnu.org/gpl for details."


def main(argv=sys.argv)->int:
	"""
	Main Program - Execution Order, Descriptions, Notes and Other Comments
	--------------------------------------------------------------------------------------------------
	Key: *=complete -=incomplete ..=continued from previous line 0=optional
	--------------------------------------------------------------------------------------------------
	* assert performs verifications on variables to guarantees defaults work
	* configure the command line parser switches and names
	* parse command line arguments and put the results in 'args'
	* get the base name and pass it to translator to get the 'index'
	* produce list if '--binary list' present or show '--help' if no search strings present
	--------------------------------------------------------------------------------
	0 The following happens only if search strings are present on the command line AND
	..the '--binary list' command was NOT on the command line:
	--------------------------------------------------------------------------------
	* url,modifiers, and search terms are passed to format_url() to create the final_url
	- the final_url is passed with the program's name to 'execute' and returns the programs' return value
	- the program's return value is returned as an integer in main, with a mask of 127 to set it apart
	..from other return codes. A value of '127' means no error happened, but that the execution ran.
	- values lower than 127 mean some internal error
	- 1 means that the command line given prevented the executor from ever running
	- if this is the __main__ module, then the return code is passed back to the calling process
	..outside of the program, back to python's executor shim, or whoever launched it in the first place.
	--------------------------------------------------------------------------------------------------
	Parameter/Return Explanation (Begin Linter Inference, Do Not Edit These Lines!)
	--------------------------------------------------------------------------------------------------
	:param argv:list    list of strings to be passed in place of sys.argv
	:return:int         return code of program (documented in main()'s docstring above this text)
	"""
	global debugging
	global parser
	assert (__name__ in binaries.keys())
	assert ('none' in modifiers.keys())
	assert (defaultSite in sites.keys())

	parser.add_argument('-v', '--version', action='version', version=VERSION_STRING)
	parser.add_argument('-d', '--debug', action='store_true')
	parser.add_argument('-b', '--binary', action='store')
	parser.add_argument('searchStrings', nargs='*', action='append')
	args = parser.parse_args(argv)
	index = translate(get_base_name(args))
	if len(args.searchStrings[0]) < 1 or index is None:
		if index is not None:
			parser.print_help()
		exit(1)
	log(DEBUG, args, args.searchStrings)
	log(DEBUG, str(["%20s : %-20s" % (r, index[r]) for r in index.keys()]))
	url = format_url(index['url'], index['siteAttributes'], args.searchStrings)
	print(url)

if __name__ == '__main__':
	exit(main(sys.argv[1:].copy()))     # don't use original in case it is modified later
else:
	if bool(os.environ.get("PGOO_SILENT_LOAD", "0")) is False:
		print("pgoo", program_description, program_copyright, VERSION_STRING, "use .main(args) to run", sep='\n')
