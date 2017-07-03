#include <stdio.h>
#include <stdlib.h>
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "lib/uart.h"

#define IRLED PD6

uint8_t n = 0;

int main (void)
{
	uart_init(MYUBRR);

	//ir out
	DDRD |= (1<<IRLED);
	PORTD |= (1<<IRLED);

	while (1)
	{
		//led turn on/off
		PORTD ^= (1<<IRLED);

		_delay_ms(1000);

		printf("%d ir transmitt\r\n", n);
		n++;
	}
}
