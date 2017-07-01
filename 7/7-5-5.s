	.text
	.globl main

main:
	LDR	r0, =0x3FF5000		@ IOPMOD
	LDR	r2, =0xF0		@ Escreve bits [7:0] do IOPMOD
	STR	r2, [r0]		@ Seta IOPMOD para uso de LEDs e DIPs

	LDR	r1, =0x3FF5008		@ IOPDATA
loop:	LDR	r4, [r1]		@ Carrega IOPDATA
	AND	r3, r4, #0xFFFFFF0F	@ Limpa LEDs
	AND	r4, r4, #0xF		@ Obtem DIPs da memoria
	ORR	r4, r3,	r4, LSL #4	@ Substitui LEDs
	STR	r4, [r1]		@ Salva na memoria
	B	loop			@ Loop infinito
	SWI 	0x0
