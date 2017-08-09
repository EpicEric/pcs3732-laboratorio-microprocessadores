ENTRY(_start)
SECTIONS
{
	. = 0x0;
	.startup . : { irq.o(.text) }
	.text : { * (.text) }
	.data : { *(.data) }
	.bss : { *(.bss COMMON) }
	. = ALIGN(8);
	. = . + 0x1000; /* 4kB of stack memory */
	process_0_stack_top = .;
	. = . + 0x1000; /* 4kB of stack memory */
	process_1_stack_top = .;
	. = . + 0x1000; /* 4kB of stack memory */
	process_2_stack_top = .;
	. = . + 0x1000; /* 4kB of IRQ stack memory */
	irq_stack_top = .;
}
