section .text

global boot

align 8
header_start:
    dd 0xE85250D6
    dd 0
    dd header_end - header_start
    dd - (0xE85250D6 + 0 + (header_end - header_start))
tag_i386:
	dw 8
	dw 0
	dd tag_i_end - tag_i386
	dd boot
tag_i_end:
header_end:

boot:
	cli
	hlt

section .bss
align 4
kernel_stack_bottom: equ $
	resb 16384 ; 16 KB
kernel_stack_top: