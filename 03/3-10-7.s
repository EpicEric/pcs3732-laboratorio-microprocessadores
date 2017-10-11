main:
	LDR	r1, =0x00000004   		 
	LDR	r2, =0x00000002
	LDR	r3, =0x00000000
	CMP	r3, r2
	BEQ	erro
	MOV	r4, r2
alinha:
	CMP	r1, r2
	MOVPL	r2, r2, LSL #1
	BPL	alinha
loop:
	CMP	r1, r2
	MOV	r3, r3, LSL #1
	ADDPL	r3, r3, #1
	SUBPL	r1, r1, r2
	MOV	r2, r2, LSR #1
	CMP	r2, r4
	BPL	loop
	MOV	r5, r1
	SWI	0x123456
erro:
	...	@ Jogar exceção de divisão por zero
