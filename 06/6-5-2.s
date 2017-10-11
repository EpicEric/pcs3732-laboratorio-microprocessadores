.text
.globl main

main:
	LDR	r0, =0x4000
	LDRB	r1, [r0], #1	@ r0 = primeiro elemento, r1 = numero de itens
	CMP	r1, #1
	BLS	fim
	ADD	r1, r1, r0	@ r1 = um elemento apos ultimo
iloop:
	ADD	r2, r0, #1	@ r2 = segundo elemento
jloop:
	BL	sort_pair
	ADD	r2, r2, #1
	CMP	r2, r1
	BLT	jloop
	SUBS	r1, r1, #1
	BNE	iloop
fim:	SWI	0x123456

sort_pair:
	@ inverte [r2, #-1] e [r2] se o anterior for maior
	LDRB	r7, [r2, #-1]
	LDRB	r8, [r2]
	CMP	r7, r8
	MOVLE	pc, lr
	STRB	r7, [r2]
	STRB	r8, [r2, #-1]
	MOV	pc, lr

