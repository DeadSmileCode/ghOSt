BOOT_FLOOPY = boot-floopy.asm
BOOT_USB_CD = boot-usb-cd.asm
BOOT = bootloader.o

LINK_F = -T conf-link/linker-f.ld
LINK_U = -T conf-link/linker-u.ld

FLAGS = -masm=intel -nostdlib -ffreestanding -std=c++17 -mno-red-zone -fno-exceptions -fno-rtti -Wall -Wextra -Werror

KERNEL = kernel.bin
CPP_KERNEL = kernel/kmain.cpp
CPP_LIB = kernel/lib/*/*.cpp
LIB = lib.o

BOOT_DIR = bootloader
BUILD_DIR = build

lib:
	g++ -m32 $(FLAGS) $(CPP_LIB) -o $(BUILD_DIR)/$(LIB)

floopy: lib
	nasm -f elf32 $(BOOT_DIR)/$(BOOT_FLOOPY) -o $(BUILD_DIR)/$(BOOT)
	g++ -m32 $(FLAGS) $(CPP_KERNEL) $(BUILD_DIR)/$(LIB) $(BUILD_DIR)/$(BOOT) -o $(BUILD_DIR)/$(KERNEL) $(LINK_F)

usb-cd:
	nasm -f elf32 ./bootloader/boot-usb-cd.asm -o ./build/kernel.o
	ld -melf_i386 -T ./conf-link/linker-u.ld ./build/kernel.o -o ./build/kernel

qemu-fda: floopy
	qemu-system-x86_64 -fda $(BUILD_DIR)/$(KERNEL)

qemu-cd: usb-cd 
	qemu-system-x86_64 -kernel ./build/kernel

clear:
	rm $(BUILD_DIR)/$(BOOT) $(BUILD_DIR)/$(KERNEL) $(BUILD_DIR)/$(LIB)