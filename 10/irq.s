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
	BLNE	timer_handler
	LDMFD	sp!,{r0-r3, pc}^

INTPND:		.word	0x10140000	@ Interrupt status register

@ ============================================================================================================
@ 3.6 Programa principal
@ ============================================================================================================

main:
	ADR	r0, hello_world
	BL	print_uart0
	BL	timer_init		@ Initialize interrupts and timer 0
loop:
	MOV	r0, #0x200000
sleep:	SUBS	r0, r0, #1
	BNE	sleep
	ADR	r0, message_2
	BL	print_uart0
	B	loop

hello_world:	.asciz "Hello World\n"
message_2:	.asciz "2"
