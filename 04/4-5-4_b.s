	.text
	.globl main

main:
	adr	r1, a
	mov	r2, #5

	mov	r5, #0
	add	r4, r1, r2
loop:
	cmp	r1, r4
	bge	loop_end

	strb	r5, [r1], #1
	b	loop
loop_end:
	swi	0x1

a:	.byte	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
