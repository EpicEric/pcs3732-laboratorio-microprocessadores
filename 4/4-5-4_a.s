	.text
	.globl main

main:	adr	r1, a
	mov	r2, #5
	mov	r3, #0
	mov	r4, #0
loop:	cmp	r3, r2		@ compara i e s
	bge	done		@ se i==s acaba
	strb	r4, [r1], #1	@ faz array[i] = 0
	add	r3, r3, #1	@ i++
	b	loop			
done:	swi	0x123456

a:	.byte	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
