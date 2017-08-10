	.global	_start
	.text
@ ============================================================================================================
@ 3.1 Definicao de vetor de interrupcoes
@ ============================================================================================================
_start:
	B	_Reset				@ Posicao 0x00 - Reset
	B	do_undefined_interrupt		@ Posicao 0x04 - Instrucao nao-definida
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
	@ spsr = Supervisor Mode (usado pelo save_process_state)
	MOV	r0, #0b00010011
	MSR     spsr, r0

	MRS	r0, cpsr		@ Salva cpsr

	@ Set IRQ mode stack
	MSR	cpsr_ctl, #0b11010010
	LDR	sp, =irq_stack_top

	@ Set undefined mode stack
	MSR	cpsr_ctl, #0b11011011
	LDR	sp, =undefined_stack_top
	MSR	cpsr, r0

	@ Set process 2 state
	ADR	r0, proc_2
	STR	r0, irq_return_address
	LDR	sp, =process_2_stack_top
	ADR	r4, message_2
	BL	save_process_state

	@ Set process 1 state
	MOV	r0, #1
	STR	r0, current_process
	ADR	r0, proc_1
	STR	r0, irq_return_address
	LDR	sp, =process_1_stack_top
	ADR	r4, message_1
	BL	save_process_state

	BL	timer_init		@ inicia o timer

	@ Switch to process 0
	MOV	r0, #0
	STR	r0, current_process
	MOV	r0, #0b00010000		@ processo 0 roda em user
	MSR	cpsr, r0		@ muda o cpsr pra user
	LDR	sp, =process_0_stack_top
	ADR	r4, message_0
	B	proc_0

message_0:		.asciz "0"
message_1:		.asciz "1"
message_2:		.asciz "2"

.align 4
do_undefined_interrupt:
	STMFD	sp!, {r0, r1, r2, lr}  @ scratch registers e $lr

	LDR	r0, current_process
	ADD	r0, r0, #0x30
	STRB	r0, message_undefined_pid
	ADR	r0, message_undefined
	BL	print_uart0

	@ Retorna sem subtrair 4 de $lr, pulando a instrucao invalida
	LDMFD	sp!, {r0, r1, r2, pc}^


undefined_return_address:	.word	0
message_undefined:		.ascii "Undefined instruction on process "
message_undefined_pid:		.asciz "X\n"

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
	LDR     r0, current_process
        CMP     r0, #0
        ADREQ   r0, process_0_table
        MOVEQ   pc, lr
        CMP     r0, #1
        ADREQ   r0, process_1_table
        MOVEQ   pc, lr
        ADR     r0, process_2_table
        MOV     pc, lr


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

	@ Salva modo, muda para modo em spsr e salva banked registers
	MRS     r0, cpsr		@ salvo modo IRQ
	MRS     r1, spsr		@ salvo modo de onde veio
	TST	r1, #0xf		@ comparo 4 bits baixos.Se todos forem 0 eh user mode
	ORREQ	r1, r1, #0xf		@ se for user, preparo setar pra modo System
	ORR	r1, r1, #0b11000000	@ preparo desabilitacoes interrupcoes
	MOV     r2, r14			@ r2 referencia tabela de registradores
	MSR     cpsr_c, r1		@ mudo para valor setado em r1
		
	STMIA   r2!, {sp, lr}
	MSR     cpsr, r0		@volto para modo IRQ

	MRS     r1, spsr                @ Carrega spsr
	LDR     r0, irq_return_address
	STMIA   r2!, {r0, r1}		@ Salva lr original e cpsr
	LDMFD	sp!, {pc}

case_timer_interrupt:	@ Rotina de interrupcao de timer, modo IRQ
	@ Salva estado do processo
	BL	save_process_state

	@ Chamo handler
	BL    	timer_handler  @ scratches r0-r3

	@ Mudanca processo

	@ Comparacao e troca
	LDR     r0, current_process
        CMP     r0, #0
        MOVEQ   r0, #1
        BEQ     troca
        CMP     r0, #1
        MOVEQ   r0, #2
        BEQ     troca
        MOV     r0, #0

        troca:
        STR     r0, current_process
        BL      get_current_process_table
        ADD     r0, r0, #68  @ aponta para fim da tabela do processo atual pra restaurar tudo

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

proc_0:
	MOV	r0, r4
	BL	print_uart0
	B	proc_0
proc_1:
        MOV     r0, r4
        BL      processo_alt
	@.word	0xf7f0a000
        B       proc_1
proc_2:
        MOV     r0, r4
        BL      print_uart0
        B       proc_2

.align 4
process_0_table:		.space 68
process_1_table:		.space 68
process_2_table:		.space 68
irq_return_address:		.word	0
current_process:		.word	2
