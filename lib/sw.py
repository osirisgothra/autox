from platform import system
import os
import sys
import urllib
import argparse
import collections
import logging


from pathlib import Path

__author__ = 'gabriel'
sys.path.append("/src/ax/lib")

#
# synopsis
#
# pg --mode/-m[selector] | --website/w[site_template] -wilv/--images --videos --lucky --web
#
#


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
	"binary": Path("x-www-browser"),
	"params": ["www", "search_terms", "&p=1"],
}


def load_config():
	print("Loading Configuration")


def args_to_info(param, default_info):
	parser = argparse.ArgumentParser()
	parser.add_argument()

	
	pass


def validate_run_info(info):

	return True

#
# synopsis
#
# pg --mode/-m[selector] | --website/w[site_template] -wilv/--images --videos --lucky --web
#

def run_args(info):
	pass


def run(args: list=None) -> int:
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
