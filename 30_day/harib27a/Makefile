OBJS_BOOTPACK = bootpack.o graphic.o dsctbl.o naskfunc.o hankaku.o mysprintf.o int.o fifo.o keyboard.o mouse.o memory.o sheet.o timer.o mtask.o mystrcmp.o file.o window.o console.o
OBJ_LIBRARIES = mysprintf.o

MAKE     = make -r
DEL      = rm -f

CC = i386-elf-gcc
CC_WITH_OPTION = i386-elf-gcc -m32 -march=i486 -nostdlib
CAPPLD = -T app.ld
CAPPLD2 = -T app2.ld
CFLAGS = -m32 -fno-builtin
TARGET = haribote

.PHONY:	run 


OBJ_FILES =
OBJ_FILES += haribote/bootpack.o
OBJ_FILES += haribote/graphic.o
OBJ_FILES += haribote/dsctbl.o
OBJ_FILES += haribote/int.o
OBJ_FILES += haribote/naskfunc.o
OBJ_FILES += haribote/hankaku.o
OBJ_FILES += haribote/sprintf.o
OBJ_FILES += haribote/fifo.o
OBJ_FILES += haribote/keyboard.o
OBJ_FILES += haribote/mouse.o
OBJ_FILES += haribote/memory.o
OBJ_FILES += haribote/memtest.o
OBJ_FILES += haribote/sheets.o
OBJ_FILES += haribote/timer.o
OBJ_FILES += haribote/mtask.o
OBJ_FILES += haribote/console.o
OBJ_FILES += haribote/file.o

HRB_FILES =
HRB_FILES += hello3/hello3.hrb
HRB_FILES += hello4/hello4.hrb
HRB_FILES += hello5/hello5.hrb
HRB_FILES += winhelo/winhelo.hrb
HRB_FILES += winhelo2/winhelo2.hrb
HRB_FILES += winhelo3/winhelo3.hrb
HRB_FILES += star1/star1.hrb
HRB_FILES += stars/stars.hrb
HRB_FILES += stars2/stars2.hrb
HRB_FILES += lines/lines.hrb
HRB_FILES += walk/walk.hrb
HRB_FILES += noodle/noodle.hrb
HRB_FILES += beepdown/beepdown.hrb
HRB_FILES += color/color.hrb
HRB_FILES += color2/color2.hrb
HRB_FILES += sosu/sosu.hrb
HRB_FILES += sosu2/sosu2.hrb
HRB_FILES += typeipl/typeipl.hrb
HRB_FILES += type/type.hrb
HRB_FILES += iroha/iroha.hrb
HRB_FILES += chklang/chklang.hrb
HRB_FILES += notrec/notrec.hrb
HRB_FILES += bball/bball.hrb
HRB_FILES += invader/invader.hrb
HRB_FILES += calc/calc.hrb
HRB_FILES += tview/tview.hrb
HRB_FILES += gview/gview.hrb


full:
	$(MAKE) -C haribote
	$(MAKE) -C lib
	$(MAKE) -C apilib
	$(MAKE) -C hello3
	$(MAKE) -C hello4
	$(MAKE) -C hello5
	$(MAKE) -C winhelo
	$(MAKE) -C winhelo2
	$(MAKE) -C winhelo3
	$(MAKE) -C star1
	$(MAKE) -C stars
	$(MAKE) -C stars2
	$(MAKE) -C lines
	$(MAKE) -C walk
	$(MAKE) -C noodle
	$(MAKE) -C beepdown
	$(MAKE) -C color
	$(MAKE) -C color2
	$(MAKE) -C sosu
	$(MAKE) -C sosu2
	$(MAKE) -C typeipl
	$(MAKE) -C type
	$(MAKE) -C iroha
	$(MAKE) -C chklang
	$(MAKE) -C notrec
	$(MAKE) -C bball
	$(MAKE) -C invader
	$(MAKE) -C calc
	$(MAKE) -C tview
	$(MAKE) -C gview
	$(MAKE) $(TARGET)


$(TARGET).img : haribote/ipl20.bin haribote/haribote.sys $(HRB_FILES)
	mformat -f 1440 -C -B haribote/ipl20.bin -i haribote.img ::
	mcopy -i haribote.img haribote/haribote.sys ::
	mcopy -i $(TARGET).img haribote/ipl20.nas ::
	mcopy -i $(TARGET).img test.txt ::
	mcopy -i $(TARGET).img test2.txt ::
	mcopy -i $(TARGET).img euc.txt ::
	mcopy -i $(TARGET).img $(HRB_FILES) ::
	mcopy -i $(TARGET).img nihongo/nihongo.fnt ::
	mcopy -i $(TARGET).img pictdata/fujisan.jpg ::
	mcopy -i $(TARGET).img pictdata/night.bmp ::


apilib.a : $(OBJS_API)
	i386-elf-ar rcs $@ $^

%.o : %.c
	$(CC) $(CFLAGS) -c $*.c -o $*.o

%.o:%.nas Makefile
	nasm -felf $< -o $@ -l $@.lst



# %.hrb: %.o apilib.lib Makefile
# 	ld -m elf_i386 -e HariMain -n -Thrb.ld -static -o $@ $< apilib.lib
# %.hrb: %.nas
# 	nasm -felf32 $^ -o tmp.o -l $@.lst
# 	ld -m elf_i386 -e HariMain -n -Thrb.ld -static -o $@ tmp.o


asmhead.o: asmhead.nas
	nasm $^ -o $@ -l $^.lst

naskfunc.o: naskfunc.nas
	nasm -felf32 $^ -o $@ -l $^.lst

$(TARGET).bin: $(OBJ_FILES)
	ld -Map bootpack.map -m elf_i386 -e HariMain -n -Tharibote/hrb.ld -static -o $(TARGET).bin $^
	hexdump -C $(TARGET).bin > $(TARGET).bin.dmp

hankaku.c : hankaku.txt Makefile
	./hankaku.py

$(TARGET).sys: haribote/asmhead.o $(TARGET).bin
	cat $^ > $@

ipl10.bin: ipl10.nas
	nasm -fbin -o $@ $^ -l ipl10.lst

diff: $(TARGET).diff haribote_reference.diff
	diff -y -W200 $^

%.diff: %.img
	hexdump -C $^ > $@

run: $(TARGET).img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy -boot a

full_run:
	$(MAKE) full
	$(MAKE) run

clean:
	rm -rf *.sys $(TARGET).img *.o */*.o */*.bin *.bin */*.lst *.lib *.name *~ */*.dmp */*.hrb */*.map