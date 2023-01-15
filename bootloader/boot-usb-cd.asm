section .text

global _boot

_boot:
jmp boot

align 8
header_start:
    dd 0xE85250D6
    dd 0
    dd header_end - header_start
    dd - (0xE85250D6 + 0 + (header_end - header_start))
header_end:

boot:
	cli
	hlt