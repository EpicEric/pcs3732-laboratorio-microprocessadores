	.file	"imprime.c"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	mov	r0, #5
	bl	imprime
	mov	r3, #0
	mov	r0, r3
	ldmfd	sp, {fp, sp, pc}
	.size	main, .-main
	.section	.rodata
	.align	2
.LC0:
	.ascii	"Imprimi %d\n\000"
	.text
	.align	2
	.global	imprime
	.type	imprime, %function
imprime:
	@ args = 0, pretend = 0, frame = 4
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #4
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bgt	.L3
	b	.L2
.L3:
	ldr	r0, .L4
	ldr	r1, [fp, #-16]
	bl	printf
	ldr	r3, [fp, #-16]
	sub	r3, r3, #1
	mov	r0, r3
	bl	imprime
.L2:
	ldmfd	sp, {r3, fp, sp, pc}
.L5:
	.align	2
.L4:
	.word	.LC0
	.size	imprime, .-imprime
	.ident	"GCC: (GNU) 3.4.3"
