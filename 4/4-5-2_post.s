add	r2, r2, #20		@ muda r2 para posição 5
ldr	r0, [r2], #20		@ carrega array[5] e muda o índice para 10
add	r0, r0, r1		@ soma y (r1)
str	r0, [r2]		@ salva em array[10]
