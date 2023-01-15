void print(const char* str, const int size, const short color){
	short* vga = (short*)0xb8000;
	for (int i = 0; i<size;++i)
		vga[i+80] = color | str[i];
}

// char read(){
// 	__asm__(R"


// 	");
// }

extern "C" void kmain() {
	const short color = 0x0F00;
	const char* hello = "Hello! You have many question: WTF? How? Who? I new OS for people like you. Do you want to continue diving?(Press Y/N)";
	print(hello , 118, color);
}
