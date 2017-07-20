.global _Reset
_Reset:
    B Reset_Handler
    B undefined_instruction_handler

Reset_Handler:
    LDR sp, =stack_top
    BL c_entry
    B .
