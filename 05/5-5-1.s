	.text
	.globl main
main:
	ADR	r5, vetorB
	ADR	r6, vetorA
	MOV	r1, #0			@ i = 0
loop:	CMP	r1, #8			@ i = 8?
	BGE	done			@ sim, chega
	RSB	r2, r1, #7		@ [7-i]
	LDR	r3, [r5, r2, LSL #2]	@ r3 = b[7-i] sem writeback
	STR	r3, [r6, r1, LSL #2]	@ a[i] = r3
	ADD	r1, r1, #1		@ i++
	B	loop			@ fecha loop
done:	SWI	0x123456
vetorB:	.word	0, 1, 2, 3, 4, 5, 6, 7   
vetorA:	.word	0, 0, 0, 0, 0, 0, 0, 0

