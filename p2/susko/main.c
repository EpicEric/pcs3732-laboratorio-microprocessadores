int main(char *str) {
	int i;
	while(1) {
		for (i = 0x1ffff; i--;);
		print_uart0(str);
	}
	return 0;
}

int main_alt() {
	int i;
	char *custom_str = "1";
	while(1) {
		for (i = 0x1ffff; i--;);
		print_uart0(custom_str);
		if (custom_str[0] >= '5') {
			custom_str[0] = '1';	
		} else {
			custom_str[0]++;
		}
	}
	return 0;
}
