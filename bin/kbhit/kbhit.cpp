#include <stdio.h> 
#include <sys/select.h> 
#include <termios.h> 
#include <stropts.h> 
#include <asm-generic/ioctls.h>

int __kbhit() 
{     
	static const int STDIN = 0;     
//	static bool initialized = false;     
//	if (! initialized) 
//	{         // Use termios to turn off line buffering         
		termios term;
		tcgetattr(STDIN, &term);
		term.c_lflag &= ~ICANON;         
		tcsetattr(STDIN, TCSANOW, &term);         
//		setbuf(stdin, NULL);         
//		initialized = true;     
//	}
     
	int bytesWaiting;     
	ioctl(STDIN, FIONREAD, &bytesWaiting);     
	return bytesWaiting; 
} 
////////////////////////////////////////////// 
// Simple demo of _kbhit() 

#include <unistd.h> 
//#include <ncurses.h>

int main(int argc, char** argv) 
{     
	return __kbhit();
}

//	initscr();

//if (! _kbhit()) { return 0; }
//getch();
//return 1;
//	if (has_key('s')) {
//	return 0;
//	}
//	else return 1;

//	endwin();
//}
