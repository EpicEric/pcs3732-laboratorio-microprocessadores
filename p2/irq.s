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
	ADR	r1, _main
	STR	r1, irq_return_address
	LDR	sp, =process_1_stack_top
	MOV	r4, #1
	STR	r4, current_process
	ADR	r5, message_2
	BL	save_process_state

	@ Set third process state
	ADR	r1, _main
	STR	r1, irq_return_address
	LDR	sp, =process_2_stack_top
	MOV	r4, #2
	STR	r4, current_process
	ADR	r5, message_1
	BL	save_process_state

	@ Set first process state
	ADR	r1, _main
	STR	r1, irq_return_address
	LDR	sp, =process_0_stack_top
	MOV	r4, #0
	STR	r4, current_process
	ADR	r5, message_1
	BL	save_process_state

	@ Switch to first process
	MOV	r4, #-1
	STR	r4, current_process
	BL	timer_init
	B	switch_process

message_1:		.asciz "1"
message_2:		.asciz "2"

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
	MOV	r1, #68
	MUL	r1, r0, r1
	ADR	r0, process_0_table
	ADD	r0, r0, r1
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
	AND	r3, r1, #0x1f
	CMP	r3, #0x13		@ Ja em modo supervisor?
	BEQ	skip_mode_change	@ Pula mudanca de modo
	MSR     cpsr_ctl, #0b11010011   @ Supervisor, I = 1
	skip_mode_change:
	STMIA   r2!, {sp, lr}
	MSR     cpsr, r1

	CMP	r3, #0x13		@ Ja em modo supervisor?
	BEQ	save_cpsr		@ Salva cpsr em spsr da tabela de registradores
	MRS     r3, spsr                @ Carrega spsr
	save_cpsr:
	LDR     r0, irq_return_address
	STMIA   r2!, {r0, r3}		@ Salva lr original e cpsr
	LDMFD	sp!, {pc}


case_timer_interrupt:	@ Rotina de interrupcao de timer, modo IRQ
	@ Salva estado do processo
	BL	save_process_state
	BL    	timer_handler  @ scratches r0-r3
	switch_process:
	@ Muda processo
	LDR	r0, current_process
	LDR	r1, total_processes
	ADD	r0, r0, #1
	CMP	r0, r1
	MOVGE	r0, #0
	STR	r0, current_process
	BL	get_current_process_table
	ADD	r0, r0, #68  @ aponta para fim da tabela

	@ r1 = lr, r2 = spsr e restaura spsr
	LDMDB	r0!, {r1, r2}
	MSR	spsr, r2

        @ Restaura banked registers
        MRS     r1, cpsr
        MSR     cpsr_ctl, #0b11010011   @ Supervisor, I = 1
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

@ ============================================================================================================
@ 3.6 Programa principal
@ ============================================================================================================

_main:
	CMP	r4, #2
	BLEQ	main_alt
	MOV	r0, r5
	BL	main
	B	_main

.align 4
process_0_table:		.space	68
process_1_table:		.space	68
process_2_table:		.space	68
irq_return_address:		.word	0
current_process:		.word	0
total_processes:		.word	3
