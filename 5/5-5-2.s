	.text
	.globl main
main:
	MOV	r6, #0xA	@ valor de entrada
	MOV	r4, r6		@ copia entrada para r4
loop:
	SUBS	r4, r4, #1	@ decrementa multiplicador
	MULNE	r2, r6, r4	@ produto atual x multiplicador (se r4 != 0)
	MOVNE	r6, r2		@ copia produto para reg final (se r4 != 0)
	BNE	loop		@ realiza novamente (se r4 != 0)
fim:
	SWI	0x123456
