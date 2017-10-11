int main(char *str) {
	int i;
	while(1) {
		for (i = 0x1ffff; i--;);
		print_uart0(str);
	}
	return 0;
}

void imprime(int n) {
	int i, j, pot, digitos;
	char str[16], *ptr, c;

	if (n <= 0) return;

	i = n / 10;
	digitos = 1;
	while (i > 0) {
		i = i / 10;
		digitos++;
	} 

	ptr = str;
	while (digitos > 0) {
		i = n;
		for (j = 1; j < digitos; j++) {
			i = n / 10;
		}
		c = '0' + (char) (i % 10);
		*ptr++ = c;
		pot = pot / 10;
		digitos--;
	}
	*ptr++ = ' ';
	*ptr++ = '\0';

	print_uart0(str);
	imprime(n - 1);
}

int main_alt() {
	int i;
	while(1) {
		for (i = 0x1ffff; i--;);
		imprime(18);
	}
	return 0;
}

