default : $(APP).hrb

CC = i386-elf-gcc
CC_WITH_OPTION = i386-elf-gcc -m32 -march=i486 -nostdlib
CAPPLD = -T ./../app.ld
CAPPLD2 = -T ./../app2.ld
CFLAGS = -m32 -fno-builtin



$(APP).hrb : $(APP).o $(OBJ_LIBRARIES) ./../haribote/mysprintf.o ./../apilib/apilib.a Makefile 
ifeq ($(APP),noodle)
	$(CC_WITH_OPTION) $(CAPPLD2) -o $@ $< ./../haribote/mysprintf.o ./../apilib/apilib.a
else
	$(CC_WITH_OPTION) $(CAPPLD) -o $@ $< ./../apilib/apilib.a
endif


%.o: %.nas Makefile
	nasm -felf $< -o $@ -l $@.lst

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $*.c -o $*.o

clean:
	rm -rf *.sys *.o *.bin *.lst *.name *~ *.dmp *.hrb *.map