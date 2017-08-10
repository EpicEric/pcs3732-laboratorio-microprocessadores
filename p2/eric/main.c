int main(char *str) {
	int i;
	while(1) {
		for (i = 0x1ffff; i--;);
		print_uart0(str);
	}
	return 0;
}

void imprime(int n) {
	char str[16];

	if (n <= 0) return;
	if (n >= 100) return;
	if (n >= 10) {
		str[0] = '0' + ((char) ((n / 10) % 10));
		str[1] = '0' + ((char) (n % 10));
		str[2] = ' ';
		str[3] = '\0';
	} else if (n >= 1) {
		str[0] = '0' + ((char) (n % 10));
		str[1] = ' ';
		str[2] = '\0';
	}
	print_uart0(str);
	imprime(n - 1);
}

int main_alt() {
	int i;
	while(1) {
		for (i = 0x1ffff; i--;);
		imprime(15);
	}
	return 0;
}

