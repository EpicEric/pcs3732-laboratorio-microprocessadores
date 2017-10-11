	LDR	r0, #0xFFFFFFFF
	LDR	r1, #0x80000000
	BL	firstfunc
firstfunc:
	MULS	r2, r0, r1
	MOV	pc, lr
