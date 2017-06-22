.text
.globl main

main:
	MOV	r1, #4

	MOV	r9, #0
	@LDR	r0, =0x4000
	LDR	r0, =ARRAY
	CMP	r1, #16
	BGE	fim
	MULS	r2, r1, r1	@ r2 = N^2
	BEQ	ok		@ ignora matrix vazia
	ADD	r2, r2, #1
	MUL	r3, r2, r1	@ r3 = (N^2 + 1) * N
	MOV	r2, r3, LSR #1  @ r2 = (N^2 + 1) * N / 2

	@ array = r0
	@ N = r1
	@ sum = r2
	@ newsum = r3

	@ Verificar diagonal NE-SO
	@
	@ for (i = 0; i < n; i++)
	@ 	diag_1 += a[0 + (n+1)*i]
	MOV	r4, #0
	ADD	r5, r1, #1
	BL	sum
	CMP	r2, r3
	BNE	fim

	@ Verificar diagonal NO-SE
	@
	@ for (i = 0; i < n; i++)
	@ 	diag_2 += a[(n-1) + (n-1)*i]
	SUB	r4, r1, #1
	MOV	r5, r4
	BL	sum
	CMP	r2, r3
	BNE	fim

	@ Verificar linhas
	@
	@ for (i = 0; i < n; i++)
	@ 	lin_X += a[(X*n) + i]
	MOV	r4, #0
	MOV	r5, #1
	MOV	r9, r1
lin_lp: BL	sum
	CMP	r2, r3
	BNE	fim
	ADD	r4, r4, r1
	SUBS	r9, r9, #1
	BNE	lin_lp

	@ Verificar colunas
	@
	@ for (i = 0; i < n; i++)
	@ 	col_X += a[X + (n*i)]
	MOV	r4, #0
	MOV	r5, r1
col_lp: BL	sum
	CMP	r2, r3
	BNE	fim
	ADD	r4, r4, #1
	CMP	r4, r1
	BLT	col_lp

ok:	MOV	r9, #1
fim:	SWI	0x123456

@ Subrotina para somar valores alinhados em uma matriz NxN
@
@ Argumentos:
@ 	r0 - array
@ 	r1 - N (dimensao matriz quadrada)
@ 	r4 - offset primeiro valor
@ 	r5 - espacamento entre valores
@
@ Retorno:
@ 	r3 - soma dos valores
@
@ Registradores auxiliares: r6 a r8
@
sum:
	MOV	r3, #0
	ADD	r7, r0, r4
	MOV	r6, r1
sum_lp: LDRB	r8, [r7], r5
	ADD	r3, r3, r8
	SUBS	r6, r6, #1
	BNE	sum_lp
	MOV	pc, lr


ARRAY:
.word 0x0D020310, 0x080B0A05, 0x0C070609, 0x010E0F04

