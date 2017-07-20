.global _Reset
_Reset:
    B Reset_Handler
    B Undefined_Handler

Reset_Handler:
    LDR sp, =stack_top

    @ setup sp in undefined mode
    MRS r0, cpsr  @ save current cpsr
    MSR cpsr_ctl, #0b11011011  @ undefined mode
    LDR sp, =undefined_stack_top
    MSR cpsr, r0

    .word 0xffffffff  @ undefined instruction
    BL c_entry
    B .

Undefined_Handler:
    STMFD sp!, {r0-r12, lr}
    BL undefined_instruction_handler
    LDMFD sp!, {r0-r12, pc}^
