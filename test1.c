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

	//setup timer
	//	generate carrier frequency
	TCCR0A |= ((1<<COM0A0)|(1<<WGM01));
	TCCR0B |= (1<<CS00); //set devide 1  FREQ=16MHz
	OCR0A = 211; //FREQ=75829Hz  - toggle /2 = 37914Hz ~ 38KHz

	while (1)
	{
		//led turn on/off
		TCCR0B ^= (1<<CS00);

		_delay_ms(1000);

		printf("%d ir transmitt\r\n", n);
		n++;
	}
}
