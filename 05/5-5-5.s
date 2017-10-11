	MOV	r1, #0x0        @ Saida (comeca em zero -- paridade par)
loop:	MOVS	r0, r0, LSL #1  @ Move MSB para Carry
	EORCS	r1, r1, #0x1    @ Se digito for 1, troca estado da paridade
	BNE	loop            @ Sai do loop quando r0 == 0
fim:	SWI	0x123456
