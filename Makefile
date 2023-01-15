BOOT_FLOOPY = boot-floopy.asm
BOOT_USB_CD = boot-usb-cd.asm
BOOT = bootloader.o

LINK_F = -T conf-link/linker-f.ld
LINK_U = -T conf-link/linker-u.ld

FLAGS = -masm=intel -nostdlib -ffreestanding -std=c++14 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra -Werror

KERNEL = kernel.bin
CPP_FILE = kernel/kmain.cpp

BOOT_DIR = bootloader
BUILD_DIR = build

floopy:
	nasm -f elf32 $(BOOT_DIR)/$(BOOT_FLOOPY) -o $(BUILD_DIR)/$(BOOT)
	g++ -m32 $(FLAGS) $(CPP_FILE) $(BUILD_DIR)/$(BOOT) -o $(BUILD_DIR)/$(KERNEL) $(LINK_F)

usb-cd:
	nasm -f elf32 $(BOOT_DIR)/$(BOOT_USB_CD) -o $(BUILD_DIR)/$(BOOT)

	ld -n -o $(BUILD_DIR)/iso/boot/$(KERNEL) $(LINK_F) $(BUILD_DIR)/$(BOOT) -m elf_i386

	#g++ -Xlinker --nmagic -m32 $(FLAGS) $(CPP_FILE) $(BUILD_DIR)/$(BOOT) -o $(BUILD_DIR)/iso/boot/$(KERNEL) $(LINK_F)

	grub2-mkrescue $(BUILD_DIR)/iso -o $(BUILD_DIR)/os.iso

qemu-fda:
	qemu-system-x86_64 -fda $(BUILD_DIR)/$(KERNEL)

qemu-cd:
	qemu-system-x86_64 -cdrom $(BUILD_DIR)/os.iso

clear:
	rm $(BUILD_DIR)/$(BOOT).o $(BUILD_DIR)/$(KERNEL)