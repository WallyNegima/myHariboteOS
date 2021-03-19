OBJS_BOOTPACK = bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o int.o fifo.o keyboard.o mouse.o memory.o sheet.o timer.o mtask.o mystrcmp.o file.o window.o console.o
OBJS_API = api001.o api002.o api003.o api004.o api005.o api006.o \
			api007.o api008.o api009.o api010.o api011.o api012.o \
			api013.o api014.o api015.o api016.o api017.o api018.o \
			api019.o api020.o
OBJ_LIBRARIES = sprintf.o
MAKE     = make -r
DEL      = rm -f

CC = i386-elf-gcc
CC_WITH_OPTION = i386-elf-gcc -m32 -march=i486 -nostdlib
CAPPLD = -T app.ld
CAPPLD2 = -T app2.ld
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

apilib.a : $(OBJS_API)
	i386-elf-ar rcs $@ $^

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys hlt.hrb \
							 hello3.hrb \
								Makefile hello4.hrb hello5.hrb \
								winhelo.hrb winhelo2.hrb winhelo3.hrb \
								star1.hrb stars.hrb stars2.hrb \
								lines.hrb walk.hrb noodle.hrb beepdown.hrb \
								color.hrb color2.hrb
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::
	mcopy -i haribote.img hlt.hrb ::
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
	mcopy -i haribote.img beepdown.hrb ::
	mcopy -i haribote.img color.hrb ::
	mcopy -i haribote.img color2.hrb ::


hello5.hrb : hello5.o app.ld
	$(CC_WITH_OPTION) $(CAPPLD) -o $@ $<

noodle.hrb : noodle.o mysprintf.o apilib.a app2.ld
	$(CC_WITH_OPTION) $(CAPPLD2) -o $@ $< mysprintf.o apilib.a

%.hrb : %.o apilib.a app.ld
	$(CC_WITH_OPTION) $(CAPPLD) -o $@ $< apilib.a

# 一般規則
%.o:%.nas Makefile
	nasm -felf $< -o $@ -l $@.lst

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
