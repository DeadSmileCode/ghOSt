#ifndef IO_LIB
#define IO_LIB value

#define VIDEO_START (short*)0xb8000 

void print_str(const char* str, const int size, const short color);
void print_str(char* str, const int size, const short color);
void print_sym(const char str, const short color);
void print_sym(char str, const short color);

char read();

#endif