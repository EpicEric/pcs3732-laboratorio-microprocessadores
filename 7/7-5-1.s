	.text
	.globl main

main:
	LDR	r0, =0x3FF5000		@ IOPMOD
	LDR	r2, =0xF0		@ Escreve bits [7:4] do IOPMOD
	STR	r2, [r0]		@ Seta IOPMOD para uso de LEDs

	LDR	r1, =0x3FF5008		@ IOPDATA
	MOV	r2, #0x0		@ Contador
ascending:
	MOV	r3, r2, LSL #4		@ Configura quais LEDs serao usados
	STR	r3, [r1]		@ Envia nova informacao de LEDs
	BL	delay			@ Aguarda
	ADD	r2, r2, #1		@ Verifica se terminou sequencia
	CMP	r2, #0xF
	BLT	ascending
descending:
	MOV	r3, r2, LSL #4		@ Configura quais LEDs serao usados
	STR	r3, [r1]		@ Envia nova informacao de LEDs
	BL	delay			@ Aguarda
	SUB	r2, r2, #1		@ Verifica se terminou sequencia
	CMP	r2, #0x0
	BGT	descending
	B	ascending		@ Loop infinito
	SWI 	0x0

@ Subrotina de delay
delay:
	LDR	r0, =0xFFFFF
dl_lp:	SUBS	r0, r0, #1
	BPL	dl_lp
	MOV	pc, lr
