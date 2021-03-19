APP = gview
STACK = 0x445C00
# 4480k(4480000) = 0x445C00

LIBPATH = ../lib/
APILIBPATH   = ../apilib/
HARIBOTEPATH = ../haribote/

MAKE = make -r
DEL = rm -f

CC = i386-elf-gcc
CFLAGS = -m32 -fno-builtin
COPTION = -march=i486 -nostdlib
COSLD = -T hrb.ld
CAPPLD = -T ../app2.ld
CC_WITH_OPTION = i386-elf-gcc -m32 -march=i486 -nostdlib

default :
	$(MAKE) $(APP).hrb

$(APP).hrb : $(APP).o bmp.o jpeg.o ../apilib/apilib.a ../app2.ld
	$(CC_WITH_OPTION) $(CAPPLD) -Wl,'--defsym=__stack=$(STACK)' -g -o $@ $< bmp.o jpeg.o ../apilib/apilib.a

# Rule
%.o : %.c
	$(CC) $(CFLAGS) -g -c $*.c -o $*.o

# -g:generate debug, -f:format, -o:outfile, -l:listfile, elf:ELF32 (i386)
%.o : %.nas
	nasm -g -f elf $*.nas -o $*.o
