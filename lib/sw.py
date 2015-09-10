
import sys
import urllib3.util.url as url
import argparse
import logging
import shutil

from pathlib import Path
from os import system

__author__ = 'gabriel'

sys.path.append("/src/ax/lib")
if __name__ == "__main__":
	# configure the logger, since we are the parent root!
	logger = logging.getLogger("sw_application_module")
	logger.setLevel(logger.DEBUG)
	logger_filehandle = logging.FileHandler("sw_application_module.log")

	logger_filehandle.setLevel(logger.DEBUG)
	logger_console = logging.StreamHandler()
	logger_console.setLevel(logging.ERROR)
	logger_formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)')
	logger_filehandle.setFormatter(logger_formatter)
	logger_console.setFormatter(logger_formatter)
	logger.addHandler(logger_filehandle)
	logger.addHandler(logger_console)
	logger.info("started sw at ", )
else:
	logger = logging.getLogger("sw_application.module")

presets = {
	"defaults": {
		# modifier and preset to select when the user does not specify one
		"modifier": "web",
		"preset": "google",
		# modifiers shared among all presets (see notes for details)
		"modifiers": {
			"web": {
				"index": 0,
				"content": "www",
			},
			"video": {
				"index": 0,
				"content": "video"
			},
			"images": {
				"index": 0,
				"content": "images"
			},
			"search_terms": {
				"index": 2,  # only 2 can be a search term set
				"content": "search_terms",  # special value that gets replaced with the search terms
				"separator": "+"  # separators only apply to search_terms - most websites use + to separate words
			}
		}
	},
	"google": {
		"url": "http://{0}.google.com/search?{2}q={1}",
		"modifiers": {
			"lucky": {
				"index": 2,
				"content": "btnI=l&",
			},

		}
	},
	"duckduckgo": {
		"url": "http://{0}.duckduckgo.com/?q={1}{2}",
		"modifiers": {
			"lucky": {
				"index": 2,
				"content": "+!",
			}
		}
	}
}
"""
Presets control how options are applied and which binaries are used, etc. They follow
this general structure:

in code:
	[preset]:
		[url]
		[modifiers]:
			[modifier]:
				[index]
				[content]
	[preset]:
		[url]
		...

The configuration file, $CONFIG_ROOT/paradisim-enterprises/sw/swrc, and/or $SHARED_CONFIG_ROOT/swrc
$CONFIG_ROOT on linux is ~/.config, and on windows is C:\\Documents and Settings\\User\\Application Data
$SHARED_CONFIG_ROOT is /etc on linux, and C:\\Documents and Settings\\All Users\\Application Data

Preset item description:

preset
	the name used to access the preset and it's attributes. combination items use these to create 'selectors'
	that are either preconfigured, hard wired, or in the config file (see next dictionary docstring). These
	selectors also use subitems based on which preset is in use.

url
	the website to use, with formatters if needed in the format of '{0}' for the first, {1} for second, etc
	format index explanation:
		{0}     typically used to modify the subdomain (the www in www.google.com, images in images.google.com, etc)
		{1}     typically used to modify the url suffix, for features like 'feeling lucky', etc
		{2}     should always be the point in of insertion of the search terms
modifiers
	a dictionary of modifier entries, which is are strongly typed dictionaries that contain at most these
	elements:
	modifier
		the name of the contained modifier, which is used when overriding content or declaring selectors
		index
			the index number (like the '0' inside {0}) to assign the modifier to. This value should be an integer
			or convertable to an integer. Values of other bases are allowed so long as they can be translated
			with int().
		content
			the actual content string that is to replace the format specifier
		separator
			(only with index 2 items)
			the character to use when separating the search terms
			if this item is not present, the default '+' will be used

"""

"""
Selectors are used from the program's name OR the --mode switch
"""
selectors = {
	"t": {
		"type": "binary",
		"content": "links2",
		"translator": "/usr/bin/which"
	},
	"T": {
		"type": "binary",
		"content": "links2",
		"arguments": ["-g"],
		"translator": "/usr/bin/which"
	},
	"e": {
		"type": "binary",
		"content": "elinks",
		"translator": "/usr/bin/which"
	},
	"f": {
		"type": "binary",
		"content": "firefox",
		"translator": "/usr/bin/which"
	},
	"c": {
		"type": "binary",
		"content": ["google-chrome", "chromium-browser"],
		"translator": "/usr/bin/which"
	},
	"(.*-ddg|.d)": {
		"type": "preset",
		"content": "duckduckgo",
	},
	".+l$": {
		"type": "modifier",
		"content": "lucky"
	},
	".+i.*$": {
		"type": "modifier",
		"content": "images"
	},
	".+v.*$": {
		"type": "modifier",
		"content": "videos"
	},
	".+w.*$": {
		"type": "modifier",
		"content": "web"
	}
}

runInfo = {
	"target": "http://{0}.google.com/search?q={1}{2}",
	"binary": "x-www-browser",
	"params": ["www", "search_terms", "&p=1"],
}


def load_config():
	print("Loading Configuration")


def args_to_info(param, default_info):
	parser = argparse.ArgumentParser()
	parser.add_argument("--mode", "-m",
	                    help="select preset mode group manually (or use 'list' to get a list of preset modes")


def validate_run_info(info: dict) -> bool:
	passed = False
	# ## Validate Binary Executable ## #
	binary = Path(shutil.which(info["binary"]))
	if binary.exists():
		passed = True
	else:
		logger.error("binary", binary, "is not accessible from this process")
	# ## Check the URL For Validity ## #
	# ##   By Checking It's Parts   ## #
	link = url.parse_url(runInfo["target"])
	for x in [link.hostname, link.path, link.url]:
		if x is not None:
			passed = True
		else:
			passed = False
			break  # don't let other "True" values corrupt the state
	return passed


#
# synopsis
#
# pg --mode/-m[selector] | --website/w[site_template] -wilv/--images --videos --lucky --web
#


def run_args(info):
	binary = info["binary"]
	target = info["target"].format(info["params"])
	return system(binary, target)



def run(args: list = None) -> int:
	"""
	runModule runs the pg module and handles the sys.argv if no args presented
	:param args:
	:return:
	"""
	global runInfo  # type=dict
	global selectors  # type=dict
	global presets  # type=dict
	return_states = dict(error=1, ok=0)

	load_config()
	if args_to_info(sys.argv[1:] if args is None else args, runInfo):
		if validate_run_info(runInfo):
			return run_args(runInfo)
		else:
			return return_states["error"]
	else:
		print("Invalid arguments passed")
		return return_states["error"]
