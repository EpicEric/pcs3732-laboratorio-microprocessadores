        .global	timer_init, timer_handler
        .text

timer_init:
	MRS	r0, cpsr
	BIC	r0, r0, #0x80
	MSR	cpsr_c, r0		@ Enabling interrupts in the cpsr
	LDR	r0, INTEN
	LDR	r1, =0x10		@ Bit 4 for timer 0 interrupt enable
	STR	r1, [r0]
	LDR	r0, TIMER0C
	LDR	r1, [r0]
	MOV	r1, #0xA0		@ Enable timer module
	STR	r1, [r0]
	LDR	r0, TIMER0V
	MOV	r1, #0xFF		@ Setting timer value
	STR	r1, [r0]
	MOV	pc, lr

timer_handler:
	LDR	r0, TIMER0X
	MOV	r1, #0x0
	STR	r1, [r0]		@ Escreve no registrador TIMER0X para limpar o pedido de interrupcao

	MOV	pc, lr

INTSEL:		.word	0x1014000C	@ Interrupt select register (0 = irq, 1 = fiq)
INTEN:		.word	0x10140010	@ Interrupt enable register
TIMER0L:	.word	0x101E2000	@ Timer 0 load register
TIMER0V:	.word	0x101E2004	@ Timer 0 value registers
TIMER0C:	.word	0x101E2008	@ Timer 0 control register
TIMER0X:	.word	0x101E200C	@ Timer 0 interrupt clear register
