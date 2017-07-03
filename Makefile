F_CPU = 16000000UL
CC = /usr/bin/avr-gcc
#-Wall enable all warnings
#-mcall-prologues convert code of functions (binnary will be smaller)
CFLAGS = -Os -Wall -mcall-prologues -mmcu=atmega328p
#some defines
CFLAGS += -DF_CPU=$(F_CPU)
OBJ2HEX = /usr/bin/avr-objcopy
UISP = /usr/bin/avrdude
FLASHER = arduino
PORT = /dev/ttyUSB0
SPEED = 57600
TARGET = main

lib/uart.o : lib/uart.c lib/uart.h
	@echo 'uart'
	$(CC) $(CFLAGS) -c -o lib/uart.o lib/uart.c

#test
test.hex : test.elf
	@echo 'test converting'
	$(OBJ2HEX) -R .eeprom -O ihex test.elf test.hex

test.elf : test.o lib/uart.o
	@echo 'test linking'
	$(CC) $(CFLAGS) -o test.elf test.o lib/uart.o

test.o : test.c
	@echo 'test compilling'
	$(CC) $(CFLAGS) -c -o test.o test.c

test_prog : test.hex
	@echo 'test flashing'
	$(UISP) -F -V -c $(FLASHER) -P $(PORT) -b $(SPEED) -p m328p -U flash:w:test.hex:a

#test1
test1.hex : test1.elf
	@echo 'test1 converting'
	$(OBJ2HEX) -R .eeprom -O ihex test1.elf test1.hex

test1.elf : test1.o lib/uart.o
	@echo 'test1 linking'
	$(CC) $(CFLAGS) -o test1.elf test1.o lib/uart.o

test1.o : test1.c
	@echo 'test1 compilling'
	$(CC) $(CFLAGS) -c -o test1.o test1.c

test1_prog : test1.hex
	@echo 'test1 flashing'
	$(UISP) -F -V -c $(FLASHER) -P $(PORT) -b $(SPEED) -p m328p -U flash:w:test1.hex:a


#main
main.hex : $(TARGET).elf
	@echo 'converting'
	$(OBJ2HEX) -R .eeprom -O ihex $(TARGET).elf $(TARGET).hex

main.elf : $(TARGET).o lib/uart.o
	@echo 'linking'
	$(CC) $(CFLAGS) -o $(TARGET).elf $(TARGET).o lib/uart.o

main.o : $(TARGET).c
	@echo 'compilling'
	$(CC) $(CFLAGS) -c -o $(TARGET).o $(TARGET).c

prog : $(TARGET).hex
	@echo 'flashing'
	$(UISP) -F -V -c $(FLASHER) -P $(PORT) -b $(SPEED) -p m328p -U flash:w:$(TARGET).hex:a

clean :
	@echo 'cleaning'
	rm -f *.hex *.elf *.o lib/*.o

.SILENT: fuse
fuse:
	@echo -e 'get fuse bits\nhfuse\nlfuse\nefuse'
	$(UISP) -F -V -c $(FLASHER) -P $(PORT) -b $(SPEED) -p m328p -U hfuse:r:-:h -U lfuse:r:-:h -U efuse:r:-:h 2>/dev/null
