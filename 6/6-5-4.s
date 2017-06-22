.text
.globl main

main:
	LDR	sp, =stack_top
	MOV 	r0, #4
	MOV 	r1, #0x14000000
	BL	custom_push
	MOV 	r0, #2
	MOV 	r1, #0x1500
	BL	custom_push
	MOV 	r0, #1
	MOV 	r1, #0x16
	BL	custom_push
	SWI	0x123456

custom_push:
	@ r0 = data size (1, 2, 4)
	@ r1 = data
	SUB sp, sp, r0
	MOVS r0, r0, ASR #1
	STRCSB r1, [sp]
	MOVS r0, r0, ASR #1
	STRCSH r1, [sp]
	MOVS r0, r0, ASR #1
	STRCS r1, [sp]
	MOV pc, lr

	.align 4
stack:
	.fill 8, 1, 0
stack_top:
