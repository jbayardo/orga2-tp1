CC=gcc
CFLAGS=-Wall -Wextra -pedantic -O0 -ggdb -std=gnu11

NASM=nasm
NASMFLAGS=-f elf64 -ggdb -F DWARF

OBJS=altaLista_c.o altaLista_asm.o
TESTOBJS=tester.o


main: $(OBJS)

tester: $(TESTOBJS) $(OBJS)

%.o: %.asm
	$(NASM) $(NASMFLAGS) $< -o $@

all: tester main

clean:
	rm -f *.o
	rm -f main tester
