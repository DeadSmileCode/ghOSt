#* Kernel code directories for different architecture
DIR_KERNEL_X86 = kernel/arch/x86
DIR_KERNEL_ARM = kernel/arch/arm
DIR_KERNEL_AVR = kernel/arch/avr

#* Bootloader directories
BOOT_FLOOPY = bootloader/floopy
BOOT_MULTI = bootloader/multiboot

#* Runtime modules
DIR_MODULES = kernel/modules

#* Directory for interim compilation files
DIR_INTER_FILE = build/inter-file
DIR_BUILD = build

#* Flags for compilators
ASM_FLAGS = -f elf32
CXX_FLAGS = -m32 -masm=intel -nostdlib -ffreestanding -std=c++17 -mno-red-zone -fno-exceptions -fno-rtti -Wall -Wextra -Werror -fstack-protector-all

NAME_KERNEL = kernel

modules:

boot-x86-f:
	nasm $(ASM_FLAGS) $(BOOT_FLOOPY)/boot.asm -o $(DIR_INTER_FILE)/bootloader.o

boot-x86-m:
	nasm $(ASM_FLAGS) $(BOOT_MULTI)/boot.asm -o $(DIR_INTER_FILE)/bootloader.o

build-x86-f: boot-x86-f
	g++ $(CXX_FLAGS) $(DIR_KERNEL_X86)/kernel/kernel.cpp $(DIR_INTER_FILE)/bootloader.o -o $(DIR_BUILD)/$(NAME_KERNEL) -T $(BOOT_FLOOPY)/conf-linker.ld

build-x86-m: boot-x86-m
	g++ $(CXX_FLAGS) $(DIR_KERNEL_X86)/kernel/kernel.cpp $(DIR_INTER_FILE)/bootloader.o -o $(DIR_BUILD)/$(NAME_KERNEL) -T $(BOOT_MULTI)/conf-linker.ld

build-arm:
	echo "Coming soon ..."

build-avr:
	echo "Coming soon ..."

emu-x86-f: build-x86-f
	qemu-system-x86_64 -fda $(DIR_BUILD)/$(NAME_KERNEL)

emu-x86-m: build-x86-m
	qemu-system-x86_64 -kernel $(DIR_BUILD)/$(NAME_KERNEL)

emu-arm:
	echo "Coming soon ..."

clear:
	rm $(DIR_INTER_FILE)/* 

