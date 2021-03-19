OBJS_BOOTPACK = bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o int.o fifo.o keyboard.o mouse.o memory.o sheet.o timer.o mtask.o mystrcmp.o file.o window.o console.o

CC = i386-elf-gcc
CFLAGS = -m32 -fno-builtin

default:
	$(MAKE) ipl20.bin
	$(MAKE) convHankakuTxt
	$(MAKE) naskfunc.o
	$(MAKE) haribote.sys

# convHankakuTxt.c は標準ライブラリが必要なので、macOS標準のgccを使う
convHankakuTxt : convHankakuTxt.c
	gcc $< -o $@

bootpack.hrb : $(OBJS_BOOTPACK) hrb.ld
	$(CC) $(CFLAGS) -march=i486 -nostdlib -Wl,-Map=bootpack.map -T hrb.ld -g $(OBJS_BOOTPACK) -o $@
 
hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

ipl20.bin : ipl20.nas
	nasm $< -o $@ -l ipl10.lst
asmhead.bin : asmhead.nas
	nasm $< -o $@ -l asmhead.lst
naskfunc.o : naskfunc.nas
	nasm -g -f elf $< -o $@ -l naskfunc.lst
%.o : %.c
	$(CC) $(CFLAGS) -c $*.c -o $*.o
