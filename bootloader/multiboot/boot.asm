global preboot

MAGIC_NUMBER equ 0x1BADB002
FLAGS        equ 0x0 
CHECKSUM     equ -MAGIC_NUMBER 

section .text: 
align 4 
    dd MAGIC_NUMBER 
    dd FLAGS 
    dd CHECKSUM

preboot:
	mov ax, 0x2401
	int 0x15

	mov ax, 0x3
	int 0x10

	mov [disk],dl

	mov ah, 0x2
	mov al, 6
	mov ch, 0
	mov dh, 0 
	mov cl, 2
	mov dl, [disk]
	mov bx, copy_target
	int 0x13
	cli
	lgdt [gdt_pointer]
	mov eax, cr0
	or eax,0x1
	mov cr0, eax
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp CODE_SEG:boot
	
gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

disk:
	db 0x0

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

copy_target:

bits 32

boot:
	jmp .loop

.loop:
	lodsb
	or al,al
	jz halt
	or eax,0x0F00
	mov word [ebx], ax
	add ebx,2
	jmp .loop
halt:
	mov esp,kernel_stack_top ;// Tut we say what stack start from kernel_stack_top
	extern kinit
	call kinit
	cli
	hlt

section .bss
align 4
kernel_stack_bottom: equ $ ;// Staaaaaaaaaaaaaaaaaaaaack
	resb 16384 ;// 16 KB
kernel_stack_top: