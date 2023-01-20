#include "io.hpp"

void print_str(const char* str, const int size, const short color){
	short* vga = VIDEO_START;
	for (int i = 0; i<size;++i)
		vga[i+80] = color | str[i];
}
void print_str(char* str, const int size, const short color){
	short* vga = VIDEO_START;
	for (int i = 0; i<size;++i)
		vga[i+80] = color | str[i];
}
void print_sym(char str, const short color){
	short* vga = VIDEO_START;
	vga[80] = color | str;
}

#pragma warning
char read(){
	__asm__(R"(
		int 00H
		shl eax , al
	)");
}