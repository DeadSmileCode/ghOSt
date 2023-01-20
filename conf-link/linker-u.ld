OUTPUT_FORMAT("binary")
ENTRY(_boot)
SECTIONS
{
   	. = 0x100000;
   	.text :{
		*(.text)
   	}
	.bss :{
		*(.bss)
	}
}