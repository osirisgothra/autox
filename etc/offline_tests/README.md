README.md (offline tests)
=========================

NOTE: This document uses GHF-Markdown, which isn't quite the same as regular markdown because
      it is meant to be viewed either at the repository or with a supporting text editor like
      Sublime Text 3 (or possibly 2), vim (at least large) 3.4+, nano, or Atom. Editors like
      Notepad, Write, Microsoft Works, etc **WILL NOT SHOW STUFF RIGHT**. <- that shouldve been bold! :smile:
      You don't want to miss the sparkles do you? :sparkle: Then use github!

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

	1) put it in a directory named ``zoneN`` folder, where ``N`` is
	   the next available number not being already used. Decimal (fractional)
	   numbers **ARE** allowed!!! :smile:

	2) provide a zoneN.txt inside your directory, the **first** line
	   must contain a breif descirption (no matter how pointless).

	3) provide a zoneN.id with a GUID inside of it (no newlines) in
	   this form:: "d8f95b5b-7f61-431f-8805-4764d1d44553"


:sparkle:&nbsp;Remember: things in .gitignore are not committed, so make sure your filenames are being added to the index!!

EXAMPLE
=======

No text is complete without examples!


TASK	 | RIGHT WAY			  |	WRONG WAY
=======================================================================
Make new | The last entry is zone9| the last entry is zone9 so you
Directory  | so you 'mkdir zone10'  | ``mkdir zone9`` anyway
                    | or you 'mkdir zone9.5' | or you ``mkdir zone53921``
         | then make a zone10.txt | ...and put no other files in it
         | and a zone9.6.txt in   |
         | respective dirs, along |
         | with a zone10.id and a |
         | zone 9.id file         |
-----------------------------------------------------------------------
Create   | use ax's ``makeduid``  | just use 'touch ${PWD%%*}.id'
the .id  | or use ``uuidgen >``   | or worse, dont put it there at all
file     | ``$(basename $PWD).id``|
-----------------------------------------------------------------------
Make     | use ``echo "desc" > `` | edit the zone532921.txt and write
the txt  | ``zone9.5.txt`` in the | a description, padding the top of
file     | zone9.5 folder         | the file with blank lines to make
         |                        | it look pretty
=======================================================================         



Last Revision September 16, 2015 by Gabriel Sharp
Created and Maintained (with pride) by the GNU nano text editor :sparkle:
