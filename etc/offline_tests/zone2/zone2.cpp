#include <stdio.h>
#include <stdlib.h>
#include <ncurses.h>

int main(int argc, char**,char**)
{
	printf("returning %d arguments!\n",argc);	
	// this test program just returns the number of arguments given to it
	return argc;
}
