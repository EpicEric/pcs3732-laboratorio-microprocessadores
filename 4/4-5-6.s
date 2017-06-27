	.text
	.globl main
main:	mov	r1, #40		@ INPUT: n = 40

	mov	r0, #0		@ fib(0) = 0
	mov	r2, #1		@ fib(1) = 1
loop:	cmp	r1, #0		@ while (n > 0)
	ble	done
	add	r3, r2, r0	@ fib(iter) = fib(iter-1) + fib(iter-2)
	mov	r2, r0		@ novo iter-2 = velho iter-1
	mov	r0, r3		@ novo iter-1 = velho iter
	sub	r1, r1, #1	@ n--
	b	loop
done:	swi	0x123456
