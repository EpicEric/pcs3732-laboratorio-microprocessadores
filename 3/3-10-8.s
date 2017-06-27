	EOR	r2, r2, r2
	MOV	r3, #4
loop1:
	MOV	r2, r2, LSL #3
	MOV	r1, r1, ROR #2
	ORR	r2, r2, r1, LSR #30
	SUBS	r3, r3, #1
	BNE	loop1

	MOV	r3, #4
loop2:
	MOV	r2, r2, LSL #3
	ORR	r2, r2, r1, LSR #30
	ORR	r2, r2, #4
	MOV	r1, r1, LSL #2
	SUBS	r3, r3, #1
	BNE	loop2
	SWI	0x123456
