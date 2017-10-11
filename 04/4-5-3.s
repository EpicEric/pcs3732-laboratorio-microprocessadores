	.text
	.globl main

main:	adr	r1, a
	adr	r2, b
	mov	r4, #3

	eor	r3, r3, r3
loop:	cmp	r3, #10
	bgt	done

	ldr	r5, [r2, r3, LSL #2]
	add	r5, r5, r4
	str	r5, [r1, r3, LSL #2]

	add	r3, r3, #1
	b	loop
done:	swi	0x1

a:	.space	44
b:	.word	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
