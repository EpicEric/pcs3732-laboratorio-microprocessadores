	.text
	.globl main

main:	adr r2, a
	mov r1, #2

	ldr	r0, [r2], #20	@ carrega array[0] em r0 e atualiza r2
	ldr	r0, [r2]	@ carrega array[5] = 5 em r0
	add	r0, r0, r1	@ soma r1 (5 + 2 = 7)
	swi	0x1

a: 	.word	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
