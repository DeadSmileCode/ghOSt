section .text
global read

read:
	mov ah , 0x01
	int 0x16
	ret