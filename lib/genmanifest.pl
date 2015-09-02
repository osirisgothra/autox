#/usr/bin/bash
(echo /ax/**/ | while read -d ' '; do cd $REPLY;echo "Directory: $REPLY"; echo;echo -ne "\tFiles: "; ls -1C; echo -e "\tCount: $(ls -C1|grep '.*' -c)"; echo -e "\tUUID: $(cat $(basename $REPLY).id)";echo; done) > MANIFEST
