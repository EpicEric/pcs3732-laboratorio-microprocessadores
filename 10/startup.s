.global _start
.text
_start:
b _Reset @posicao 0x00 - Reset
ldr pc, _undefined_instruction @posição 0x04 -nstrucao nao-definida
ldr pc, _software_interrupt @posição 0x08 - Interrcao de Software
ldr pc, _prefetch_abort @posicao 0x0C - Prefetch Abort
ldr pc, _data_abort @posicao 0x10 - Data Abort
ldr pc, _not_used @posicao 0x14 - Nao utilizado
ldr pc, _irq @posicao 0x18 - Interrupcao (IRQ)
ldr pc, _fiq @posicao 0x1C - Interrupcao(FIQ)

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq

INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 interrupt clear register

_Reset:
bl main
 b .

undefined_instruction:
 b .

software_interrupt:
 b do_software_interrupt @vai para o handler de interrupcoes de software

prefetch_abort:
 b .

data_abort:
 b .

not_used:
 b .

irq:
b do_irq_interrupt @vai para o handler de interrupcoes IRQ

fiq:
 b .

do_software_interrupt: @Rotina de Interrupcao de software
add r1, r2, r3 @r1 = r2 + r3
mov pc, r14 @volta p/ o endereço armazenado em r14

do_irq_interrupt: @Rotina de interrupcoes IRQ
STMFD sp!, {r0 - r3, LR} @Empilha os registradores
LDR r0, INTPND @Carrega o registrador de status de interrupcao
LDR r0, [r0]
TST r0, #0x0010 @verifica se e' uma interupcao de timer
BNE handler_timer @vai para o rotina de tratamento da interupcao de timer
LDMFD sp!, {r0 - r3,lr} @retorna
mov pc, r14

handler_timer:
LDR r0, TIMER0X
MOV r1, #0x0
STR r1, [r0] @Escreve no registrador TIMER0X para limpar o pedido de interrupcao

@ Inserir codigo que sera executado na interrucao de timer aqui (chaveamento de processos, ou alternar LED por exemplo)

LDMFD sp!, {r0 - r3,lr}
mov pc, r14 @retorna

timer_init:
mrs r0, cpsr
bic r0,r0,#0x80
msr cpsr_c,r0 @enabling interrupts in the cpsr
LDR r0, INTEN
LDR r1,=0x10 @bit 4 for timer 0 interrupt enable
STR r1,[r0]
LDR r0, TIMER0C
LDR r1, [r0]
MOV r1, #0xA0 @enable timer module
STR r1, [r0]
LDR r0, TIMER0V
MOV r1, #0xff @setting timer value
STR r1,[r0]
mov pc, lr

main:
bl timer_init @initialize interrupts and timer 0
stop: b stop
