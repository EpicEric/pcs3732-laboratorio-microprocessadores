.text
.globl main
main:
	@ (4 * 2) + 3
	MOV    r0, #3
	MOV    r1, #2
	MOV    r2, #4
	STMFD  sp!, {r0-r2}
	BL     func1

done:	B done

Func1:
	@ recupera registradores
	LDMFD  sp!, {r0-r2}

	MUL    r3,  r1, r2

	@ Prepara para chamada
	STMFD  sp!, {r0, r3, lr}
	BL	   func2
	@ Recupera lr
	LDR	   lr, [sp], #4
	MOV    pc,  lr
func2:
	LDMFD  sp!, {r0, r1}
	ADD	   r4, r0, r1
	MOV    pc,  lr
