#include "io.hpp"

void print(const char* str, const int size, const short color){
	short* vga = VIDEO_START;
	for (int i = 0; i<size;++i)
		vga[i+80] = color | str[i];
}
void print(char* str, const int size, const short color){
	short* vga = VIDEO_START;
	for (int i = 0; i<size;++i)
		vga[i+80] = color | str[i];
}
void print(const char str, const short color){
	short* vga = VIDEO_START;
	vga[80] = color | str;
}
