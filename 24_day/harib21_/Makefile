OBJS_BOOTPACK = bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o int.o fifo.o keyboard.o mouse.o memory.o sheet.o timer.o mtask.o mystrcmp.o file.o window.o console.o

MAKE     = make -r
DEL      = rm -f

CC = i386-elf-gcc
CFLAGS = -m32 -fno-builtin

# デフォルト動作

default :
	$(MAKE) img

# ファイル生成規則

# convHankakuTxt.c は標準ライブラリが必要なので、macOS標準のgccを使う
convHankakuTxt : convHankakuTxt.c
	gcc $< -o $@

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

ipl10.bin : ipl10.nas
	nasm $< -o $@ -l ipl10.lst

asmhead.bin : asmhead.nas
	nasm $< -o $@ -l asmhead.lst

naskfunc.o : naskfunc.nas
	nasm -g -f elf $< -o $@ -l naskfunc.lst

bootpack.hrb : $(OBJS_BOOTPACK) hrb.ld
	$(CC) $(CFLAGS) -march=i486 -nostdlib -Wl,-Map=bootpack.map -T hrb.ld -g $(OBJS_BOOTPACK) -o $@
 
hlt.hrb: hlt.nas
	nasm $< -o $@ -l hlt.lst

a_nask.o: a_nask.nas
	nasm -g -f elf $< -o $@ -l a_nask.lst

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys hlt.hrb \
							 hello.hrb hello2.hrb hello3.hrb \
								Makefile hello4.hrb hello5.hrb \
								winhelo.hrb winhelo2.hrb winhelo3.hrb \
								star1.hrb stars.hrb stars2.hrb \
								lines.hrb walk.hrb noodle.hrb
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::
	mcopy -i haribote.img hlt.hrb ::
	mcopy -i haribote.img hello.hrb ::
	mcopy -i haribote.img hello2.hrb ::
	mcopy -i haribote.img hello3.hrb ::
	mcopy -i haribote.img hello4.hrb ::
	mcopy -i haribote.img hello5.hrb ::
	mcopy -i haribote.img int.c ::
	mcopy -i haribote.img winhelo.hrb ::
	mcopy -i haribote.img winhelo2.hrb ::
	mcopy -i haribote.img winhelo3.hrb ::
	mcopy -i haribote.img star1.hrb :: 
	mcopy -i haribote.img stars.hrb ::
	mcopy -i haribote.img stars2.hrb ::
	mcopy -i haribote.img lines.hrb ::
	mcopy -i haribote.img walk.hrb ::
	mcopy -i haribote.img noodle.hrb ::


winhelo.hrb: a_nask.o winhelo.o
	$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o winhelo.o -o $@
winhelo2.hrb: a_nask.o winhelo2.o
	$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o winhelo2.o -o $@
winhelo3.hrb: a_nask.o winhelo3.o
	$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o winhelo3.o -o $@

star1.hrb: a_nask.o star1.o
		$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o star1.o -o $@
stars.hrb: a_nask.o stars.o
		$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o stars.o -o $@
stars2.hrb: a_nask.o stars2.o
		$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o stars2.o -o $@

lines.hrb: a_nask.o lines.o
		$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o lines.o -o $@

walk.hrb: a_nask.o walk.o
		$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o walk.o -o $@

noodle.hrb: a_nask.o noodle.o mysprintf.o
		$(CC) $(CFLAGS) -march=i486 -nostdlib -T app2.ld -g a_nask.o noodle.o mysprintf.o -o $@
hello.hrb: hello.nas
	nasm $< -o $@ -l hello.lst

hello2.hrb: hello2.nas
	nasm $< -o $@ -l hello2.lst

hello4.hrb: hello4.o a_nask.o
	$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o hello4.o -o $@

hello3.hrb: a_nask.o app.ld hello3.o
	$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g a_nask.o hello3.o -o $@

hello5.o: hello5.nas
	nasm -g -f elf $< -o $@ -l hello5.lst
hello5.hrb: hello5.o
	$(CC) $(CFLAGS) -march=i486 -nostdlib -T app.ld -g hello5.o -o $@


# 一般規則

%.o : %.c
	$(CC) $(CFLAGS) -c $*.c -o $*.o

# コマンド

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy -boot a

clean :
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.o
	-$(DEL) *.sys
	-$(DEL) *.hrb
	-$(DEL) hankaku.c
	-$(DEL) convHankakuTxt

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img
