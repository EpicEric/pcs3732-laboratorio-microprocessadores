	.text
	.globl main

main:
	ADR	r3, data		@ Acessa a memoria de input
	LDR	r4, [r3]		@ Pega valor da memoria
	CMP	r4, #0xF		@ Verifica se o valor e' valido
	BHI	fim

	LDR	r0, =0x3FF5000		@ IOPMOD
	LDR	r2, =0x1FC00		@ Escreve bits [16:10] do IOPMOD
	STR	r2, [r0]		@ Seta IOPMOD para uso de 7 segmentos

	LDR	r5, =0x3FF5008		@ IOPDATA
	ADR	r6, display		@ Mapeamento dos pinos de IOPDATA
	LDR	r7, [r6, r4, LSL #2]	@ Muda os pinos de IOPDATA de acordo com valor
	STR	r7, [r5]
fim:
	b fim

@ Input
data:
	.word	0x4

@ Tabela com os pinos IOPDATA[16:10] para 7 segmentos, de 0 a F
@ Fonte: Evaluator-7T User Guide, pg. 32
display:
	.word	0x17C00, 0x1800, 0xEC00, 0xBC00, 0x19800, 0x1B400, 0x1F400, 0x1C00, 0x1FC00, 0x1BC00, 0x1DC00, 0x1F000, 0x16400, 0xF800, 0x1E400, 0x1C400
