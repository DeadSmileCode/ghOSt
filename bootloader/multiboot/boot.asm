global start

MAGIC_NUMBER equ 0x1BADB002
FLAGS        equ 0x0 
CHECKSUM     equ -MAGIC_NUMBER 

section .text: 
align 4 
    dd MAGIC_NUMBER 
    dd FLAGS 
    dd CHECKSUM

start:  
	mov ebx, 0xb8000
	mov ecx, 80*25

	mov edx, 0x0020
clear_loop:
	extern kmain
	call kmain

.loop:
    jmp .loop