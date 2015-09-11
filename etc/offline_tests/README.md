README.md (offline tests)
=========================

This directory is strictly for tests that have no real use to others than the ones who created them.
They verify nothing, do nothing, install nothing <usually>, and, can blow up your house. Use at risk!

THE ONLY IMPORTANT FILES
=======================

This directory and its stuff may be useless, but, the README.md (this file), MANIFEST and 
the globally unique identifier assignment id (offline_tests.id) must stay. Also, the
MANIFEST may be recreated by using the provided generate-manifest.pl script. It is to be
run whenever this tree is cloned to a new location by users or admins because it deals
in absolute paths. If you have not yet done this, the MANIFEST included is a sample of
what it should look like. No editing of any files is needed.

YOU WANT TO TEST?
=================
If you wish to make your own test, all I ask is:
	
	1) put it in a numbered (in sequence with the last) zoneN folder, where N
	   is the next available number. (ie, 'zone6' if zone5 is the last in the dir)
	2) provide a zoneN.txt inside your directory, along with a zoneN.id with a GUID
	   inside of it generated, hopefully, by guidgen, or equivalent tool.
	3) the first line of zoneN.txt (must be FIRST line) should contain a breif descirption
	   of the directory's contents regardless of how unhelpful, understable, etc. it is.
	   
Remember: things in .gitignore are not committed, so make sure your filenames are being added to the index!!


	   