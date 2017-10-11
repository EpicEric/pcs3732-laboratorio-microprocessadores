ldr	r0, [r2, #20]!	@ carrega array[5] e muda o índice para 5
add	r0, r0, r1	@ soma y (r1)
str	r0, [r2, #20]	@ salva em array[10]
