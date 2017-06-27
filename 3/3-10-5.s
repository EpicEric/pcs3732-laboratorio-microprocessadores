main:
	LDR	r0, =0x7FFFFFFF		@ Primeiro fator
	LDR	r1, =0x80000000		@ Segundo fator
	ADD	r4, r0, r0, ASR #31
	EOR	r4, r4, r0, ASR #31	@ Modulo de r0 em r4
	ADD	r5, r1, r1, ASR #31
	EOR	r5, r5, r1, ASR #31	@ Modulo de r1 em r5
	UMULL	r3, r2, r4, r5		@ r4 * r5 = r2_r3
	EORS	r6, r1, r0		@ Seta N se os dois valores tiverem sinais diferentes
	BPL	fim			@ Se nao tiverem mesmo sinal (valor do XOR positivo):
	RSB	r3, r3, #0		@ 	Inverte LSB
	ADDCS	r2, r2, #1		@ 	Considera carry da inversao de LSB no MSB
	RSB	r2, r2, #0		@ 	Inverte MSB
fim:
	SWI	#0x123456		@ Continuação do programa
