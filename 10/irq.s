@ ============================================================================================================
@ 3.1 Definicao de vetor de interrupcoes
@ ============================================================================================================

	.global	_start
	.text
_start:
	B	_Reset				@ Posicao 0x00 - Reset
	LDR	pc, _undefined_instruction	@ Posicao 0x04 - Instrucao nao-definida
	LDR	pc, _software_interrupt		@ Posicao 0x08 - Interrupcao de software
	LDR	pc, _prefetch_abort		@ Posicao 0x0C - Prefetch abort
	LDR	pc, _data_abort			@ Posicao 0x10 - Data abort
	LDR	pc, _not_used			@ Posicao 0x14 - Nao utilizado
	LDR	pc, _irq			@ Posicao 0x18 - Interrupcao (IRQ)
	LDR	pc, _fiq			@ Posicao 0x1C - Interrupcao (FIQ)

_undefined_instruction:	.word	undefined_instruction
_software_interrupt:	.word	software_interrupt
_prefetch_abort:	.word	prefetch_abort
_data_abort:		.word	data_abort
_not_used:		.word	not_used
_irq:			.word	irq
_fiq:			.word	fiq

@ ============================================================================================================
@ 3.2 Definicao de constantes
@ ============================================================================================================

INTPND:		.word	0x10140000	@ Interrupt status register
INTSEL:		.word	0x1014000C	@ Interrupt select register (0 = irq, 1 = fiq)
INTEN:		.word	0x10140010	@ Interrupt enable register
TIMER0L:	.word	0x101E2000	@ Timer 0 load register
TIMER0V:	.word	0x101E2004	@ Timer 0 value registers
TIMER0C:	.word	0x101E2008	@ Timer 0 control register
TIMER0X:	.word	0x101E200C	@ Timer 0 interrupt clear register

@ ============================================================================================================
@ 3.3 Tratamento de interrupcoes
@ ============================================================================================================

_Reset:			LDR	sp, =stack_top
			MRS	r0, cpsr		@ Save current cpsr
			MSR	cpsr_ctl, #0b11010010	@ IRQ mode
			LDR	sp, =irq_stack_top
			MSR	cpsr, r0
			BL	main
			B	.
undefined_instruction:	B	.
software_interrupt:	B	do_software_interrupt	@ Vai para o handler de interrupcoes de software
prefetch_abort:		B	.
data_abort:		B	.
not_used:		B	.
irq:			B	do_irq_interrupt	@ Vai para o handler de interrupcoes IRQ
fiq:			B	.

do_software_interrupt:	@ Rotina de interrupcao de software
	ADD	r1, r2, r3		@ r1 = r2 + r3
	MOV	pc, r14			@ Volta p/ o endereco armazenado em r14

do_irq_interrupt:	@ Rotina de interrupcoes IRQ
	SUB	lr, lr, #4
	STMFD	sp!, {r0-r3, lr}	@ Empilha os registradores
	LDR	r0, INTPND		@ Carrega o registrador de status de interrupcao
	LDR	r0, [r0]
	TST	r0, #0x10		@ Verifica se e' uma interupcao de timer
	BNE	handler_timer		@ Vai para o rotina de tratamento da interupcao de timer
	LDMFD	sp!,{r0-r3, pc}^

@ ============================================================================================================
@ 3.4 Tratamento da interrupcao de timer
@ ============================================================================================================

handler_timer:
	LDR	r0, TIMER0X
	MOV	r1, #0x0
	STR	r1, [r0]		@ Escreve no registrador TIMER0X para limpar o pedido de interrupcao

@ >> Inserir codigo que sera executado na interrucao de timer aqui <<

	LDMFD	sp!,{r0-r3, pc}^

@ ============================================================================================================
@ 3.5 Rotina de inicializacao de timer
@ ============================================================================================================

timer_init:
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
	MRS	r0, cpsr
	BIC	r0, r0, #0x80
	MSR	cpsr_c, r0		@ Enabling interrupts in the cpsr
	MOV	pc, lr

@ ============================================================================================================
@ 3.6 Programa principal
@ ============================================================================================================

main:
	BL	timer_init		@ Initialize interrupts and timer 0
	B	.
