volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200C;
volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
    while (*s) {
        *UART0DR = (unsigned int)(*s);
        s++;
    }
}

void timer_handler() {
        *TIMER0X = 0;
        print_uart0("1\n");
}
