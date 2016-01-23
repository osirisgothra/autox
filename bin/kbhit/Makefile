# Makefile for kbhit
# 1-21-2016
#

kbhit: kbhit.o
	c++ kbhit.o -o kbhit

kbhit.o: kbhit.cpp
	c++ -c kbhit.cpp -o kbhit.o


.PHONY: clean install

clean:
	rm kbhit.o kbhit -v

install: kbhit
	sudo cp kbhit /usr/bin


