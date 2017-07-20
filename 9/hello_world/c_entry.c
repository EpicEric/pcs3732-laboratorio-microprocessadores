volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
    while (*s) {
        *UART0DR = (unsigned int)(*s);
        s++;
    }
}

__attribute__((noreturn)) void undefined_instruction_handler() {
    print_uart0("Invalid instruction!\n");
    for (;;) ;
}

void c_entry() {
    print_uart0("Hello world!\n");
}
