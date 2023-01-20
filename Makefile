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

usb-cd: lib
	nasm -f elf32 $(BOOT_DIR)/$(BOOT_USB_CD) -o $(BUILD_DIR)/$(BOOT)
	ld -n -o $(BUILD_DIR)/iso/boot/$(KERNEL) $(LINK_F) $(BUILD_DIR)/$(BOOT) -m elf_i386
	#g++ -Xlinker --nmagic -m32 $(FLAGS) $(CPP_KERNEL) $(BUILD_DIR)/$(BOOT) -o $(BUILD_DIR)/iso/boot/$(KERNEL) $(LINK_F)
	grub2-mkrescue $(BUILD_DIR)/iso -o $(BUILD_DIR)/os.iso

qemu-fda: floopy
	qemu-system-x86_64 -fda $(BUILD_DIR)/$(KERNEL)

qemu-cd: usb-cd 
	qemu-system-x86_64 -cdrom $(BUILD_DIR)/os.iso

clear:
	rm $(BUILD_DIR)/$(BOOT) $(BUILD_DIR)/$(KERNEL) $(BUILD_DIR)/$(LIB)