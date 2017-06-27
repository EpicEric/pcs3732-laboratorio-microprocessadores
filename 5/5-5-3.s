.text
.globl main
main:
	@ test values
	mov	r5, #11		@ number of integers

	@ program
	ldr	r0, =dados + 4
	mov	r1, #0		@ answer
loop:
	sub	r5, r5, #1
	ldr	r2, [r0, r5, LSL #2]
	cmp	r2, r1
	movhi	r1, r2
	tst	r5, r5
	bne	loop

	str	r1, [r0, #-4]

	swi	0x123456

dados: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11

