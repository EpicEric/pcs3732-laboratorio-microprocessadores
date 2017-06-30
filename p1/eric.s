	.text
	.globl main

main:
	@ $numero = r6
	@ $i = r7
	@ $lista = r8
	@ $tam_lista = r9
	LDR	r6, numero
	MOV	r7, #2
	ADR	r8, lista
	MOV	r9, #0
while:
	MOV	r1, r6
	MOV	r2, r7
	BL	divisao
	CMP	r5, #0
	ADDNE	r7, r7, #1
	BNE	compare
	MOV	r6, r3
	STMIA	r8!, {r7}
	ADD	r9, r9, #1
	STR	r9, size
compare:
	CMP	r7, r6
	BLE	while
fim:
	SWI 0x0

@ Subrotina de divisao
@ r3 = r1 / r2, r5 = resto
divisao:
	MOV	r3, #0
	MOV	r5, #0
	MOV	r4, r2
alinha:
	CMP	r1, r2
	MOVPL	r2, r2, LSL #1
	BPL	alinha
div_lp:
	CMP	r1, r2
	MOV	r3, r3, LSL #1
	ADDPL	r3, r3, #1
	SUBPL	r1, r1, r2
	MOV	r2, r2, LSR #1
	CMP	r2, r4
	BPL	div_lp
	MOV	r5, r1
	MOV	pc, lr


numero:	.word	100
size:	.word	1
lista:	.space	100
