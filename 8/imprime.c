#include <stdio.h>

void imprime(int i);

int main() {
	imprime(5);
	return 0;
}

void imprime(int i) {
	if (i <= 0) {
		return;
	}
	printf("Imprimi %d\n", i);
	imprime(i - 1);
}
