	.text
	.globl main
main:	ldr	r0, =0x4000	@ addr = &array[] na pos. 0x4000 da memoria
	add	r5, r0, #9	@ MAX_ADDR = addr+9
	mov	r1, #0		@ fib(0) = 0
	strb	r1, [r0]	@ array[0] = mem[addr+0] = fib(0)
	mov	r1, #1		@ fib(1) = 1
	strb	r1, [r0, #1]	@ array[1] = mem[addr+1] = fib(1)
loop:	cmp	r0, r5		@ while (addr <= MAX_ADDR):
	bgt	done
	ldrb	r2, [r0, #0]	@ 	fib(n) = mem[addr]
	ldrb	r3, [r0, #1]	@ 	fib(n+1) = mem[addr+1]
	add	r4, r2, r3	@ 	fib(n+2) = fib(n) + fib(n+1)
	strb	r4, [r0, #2]	@ 	mem[addr+2] = fib(n+2)
	add	r0, r0, #1	@ 	addr++
	b	loop
done:	swi	0x123456
