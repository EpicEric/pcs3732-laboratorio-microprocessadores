#include "segment.h"

// Mapeamento do microcontrolador
#define SYSCFG 0x03ff0000
#define IOPMOD ((volatile unsigned *)(SYSCFG+0x5000))
#define IOPDATA ((volatile unsigned *)(SYSCFG+0x5008))

static unsigned int numeric_display [16] =
{
    DISP_0, DISP_1, DISP_2, DISP_3, DISP_4, DISP_5, DISP_6, DISP_7, DISP_8, DISP_9,
    DISP_A, DISP_B, DISP_C, DISP_D, DISP_E, DISP_F
};

void init_display() {
    *IOPMOD |= SEG_MASK;
    *IOPDATA |= SEG_MASK;
}

void imprime(unsigned n) {
    __asm__(
        "ldr	r3, [fp, #-16]\n\t"
    	"cmp	r3, #15\n\t"
    	"bhi	asm_end\n\t"
    	"mov	r2, #66846720\n\t"
    	"add	r2, r2, #217088\n\t"
    	"add	r2, r2, #8\n\t"
    	"mov	r3, #66846720\n\t"
    	"add	r3, r3, #217088\n\t"
    	"add	r3, r3, #8\n\t"
    	"ldr	r3, [r3, #0]\n\t"
    	"bic	r3, r3, #130048\n\t"
    	"str	r3, [r2, #0]\n\t"
    	"mov	r2, #66846720\n\t"
    	"add	r2, r2, #217088\n\t"
    	"add	r2, r2, #8\n\t"
    	"mov	r3, #66846720\n\t"
    	"add	r3, r3, #217088\n\t"
    	"add	r3, r3, #8\n\t"
    	"ldr	ip, numeric_display_pointer\n\t"
    	"ldr	r1, [fp, #-16]\n\t"
    	"ldr	r0, [r3, #0]\n\t"
    	"ldr	r3, [ip, r1, asl #2]\n\t"
    	"orr	r3, r0, r3\n\t"
    	"str	r3, [r2, #0]\n\t"
    	"b      asm_end\n\t"
        "numeric_display_pointer:\n\t"
        ".word	numeric_display\n\t"
        "asm_end:\n\t"
    );
}
