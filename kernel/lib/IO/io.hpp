#ifndef IO_LIB
#define IO_LIB value

#define VIDEO_START (short*)0xb8000 
#define R_PRINT 0
#define R_NOPRINT 1

void print(const char* str, const int size, const short color);
void print(char* str, const int size, const short color);
void print(const char str, const short color);

void read(int len);

#endif