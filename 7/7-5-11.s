.text
.globl main

@ Em todo o programa, r1 = IOPDATA

main:
	LDR	r0, =0x3FF5000	@ IOPMOD
	LDR	r2, =0x1FCF0	@ Escreve bits 16:10 e 7:4 do IOPMOD
	STR	r2, [r0]		@ Seta IOPMOD para uso de LEDs

	ADD	r1, r0, #8		@ IOPDATA
	MOV	r6, #0x0		@ Contador
	MOV r0, #0			@ Ciclos desde mudanca de valor
	LDR r3, =0x9FFFF	@ Numero minimo de ciclos para descartar debounce

	LDR	r5, [r1]		@ Carrega IOPDATA
	AND r5, r5, #0x8	@ DIP4 inicial em r5
	BL write_7_segment
loop:
	ADD r0, r0, #1
	LDR	r4, [r1]		@ Carrega IOPDATA
	AND r4, r4, #0x8	@ Obtem DIP4
	CMP r4, r5
	BEQ loop

	@ Valor foi atualizado, verificar quantos ciclos ficou estavel
	CMP r0, r3
	MOV r0, #0
	BLS loop

	ADD r6, r6, #1
	BL write_7_segment
	CMP	r6, #0xF		@ Para se chegar a 15
	@BEQ	fim
	MOVEQ r6, #-1

	MOV r5, r4			@ Salva novo valor da switch
	B loop

write_7_segment:  @ Escreve r6 em 7 segmentos
	ADR	r7, display		@ Mapeamento dos pinos de IOPDATA
	LDR	r8, [r7, r6, LSL #2]	@ Salva IOPDATA
	STR	r8, [r1]
	MOV	pc, lr

display:
	.word	0x17C00, 0x1800, 0xEC00, 0xBC00, 0x19800, 0x1B400, 0x1F400, 0x1C00, 0x1FC00, 0x1BC00, 0x1DC00, 0x1F000, 0x16400, 0xF800, 0x1E400, 0x1C400
