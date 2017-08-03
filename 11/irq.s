	.global	_start
	.text
@ ============================================================================================================
@ 3.1 Definicao de vetor de interrupcoes
@ ============================================================================================================
_start:
	B	_Reset				@ Posicao 0x00 - Reset
	B	.				@ Posicao 0x04 - Instrucao nao-definida
	B	.				@ Posicao 0x08 - Interrupcao de software
	B	.				@ Posicao 0x0C - Prefetch abort
	B	.				@ Posicao 0x10 - Data abort
	B	.				@ Posicao 0x14 - Nao utilizado
	B	do_irq_interrupt		@ Posicao 0x18 - Interrupcao (IRQ)
	B	.				@ Posicao 0x1C - Interrupcao (FIQ)

@ ============================================================================================================
@ 3.3 Tratamento de interrupcoes
@ ============================================================================================================
_Reset:
	@ Set IRQ mode stack
	MRS	r0, cpsr		@ Save cpsr
	MSR	cpsr_ctl, #0b11010010	@ IRQ mode
	LDR	sp, =irq_stack_top
	MSR	cpsr, r0

	@ Set second process state
	ADR	r1, main
	STR	r1, irq_return_address
	LDR	sp, =process_1_stack_top
	MOV	r0, #0x32
	BL	save_process_state

	@ Switch to first process
	MOV	r0, #0
	STR	r0, current_process
	LDR	sp, =process_0_stack_top

	BL	timer_init

	MOV	r0, #0x31
	B	main

.align 4
do_irq_interrupt:
	@ Empilha scratch registers e lr, salva lr em irq_return_address
	SUB	lr, lr, #4
	STR	lr, irq_return_address

	@ Verifica se interrupcao de timer
	LDR	r14, INTPND
	LDR	r14, [r14]
	TST	r14, #0x10
	BNE	case_timer_interrupt
	B	.	@ Interrupcao nao definida


get_current_process_table:
	@ Retorna em r0 uma referencia a tabela de registradores do processo atual
	LDR	r0, current_process
	CMP	r0, #0
	ADR	r0, process_0_table
	MOVEQ	pc, lr
	ADD	r0, r0, #68
	MOV	pc, lr


save_process_state:
	@ Salva tabela de registradores do processo atual.
	@ O valor salvo de lr e' pego de irq_return_address.

	@ Aponta r14 para tabela de registradores do processo atual
	STMFD   sp!, {r0, lr}
	BL	get_current_process_table
	MOV 	r14, r0
	LDMFD	sp!, {r0}

	@ Salva registradores
	STMIA   r14!, {r0-r12}

	@ Salva modo, muda para supervisor e salva banked registers
	MOV     r2, r14                 @ r2 referencia tabela de registradores
	MRS     r1, cpsr
	MSR     cpsr_ctl, #0b11010011   @ Supervisor, I = 0
	STMIA   r2!, {sp, lr}
	MSR     cpsr, r1

	MRS     r1, spsr                @ Carrega spsr/IRQ (main cpsr)
	LDR     r0, irq_return_address
	STMIA   r2!, {r0, r1}          @ Salva lr original e cpsr

	LDMFD	sp!, {pc}


case_timer_interrupt:	@ Rotina de interrupcao de timer, modo IRQ
	@ Salva estado do processo
	BL	save_process_state
	BL    	timer_handler  @ scratches r0-r3

	@ Muda processo
	LDR	r0, current_process
	EOR	r0, r0, #1
	STR	r0, current_process
	BL	get_current_process_table
	ADD	r0, r0, #68  @ aponta para fim da tabela

	@ r1 = lr, r2 = spsr e restaura spsr
	LDMDB	r0!, {r1, r2}
	MSR	spsr, r2
	STR	r1, irq_return_address

        @ Restaura banked registers
        MRS     r1, cpsr
        MSR     cpsr_ctl, #0b11010011   @ Supervisor, I = 0
	LDMDB	r0!, {sp, lr}
	MSR	cpsr, r1

	@ Restaura r0-r12
	MOV	r14, r0
	LDMDB	r14!, {r0-r12}

	@ Retorno a processo
	LDR	lr, [r14, #60]
	STMFD	sp!, {lr}
	LDMFD	sp!, {pc}^  @ Retorna da IRQ


INTPND:		.word	0x10140000	@ Interrupt status register
UART0DR:	.word	0x101f1000

@ ============================================================================================================
@ 3.6 Programa principal
@ ============================================================================================================

main:
	LDR	r1, UART0DR
	print_loop:
		STR	r0, [r1]
	B	print_loop
	@ BL	print_uart0

.align 4
process_0_table:		.space 68
process_1_table:		.space 68
irq_return_address:	.word	0
current_process:	.word	1
