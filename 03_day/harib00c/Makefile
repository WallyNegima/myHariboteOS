MAKE     = make -r
NASM     = nasm
EDIMG    = cat
DEL      = rm -f

# デフォルト動作

default :
	$(MAKE) img

# ファイル生成規則

ipl.bin : ipl.nas Makefile
	$(NASM) ipl.nas -o ipl.bin -l ipl.lst

haribote.img : ipl.bin Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::

# コマンド

asm :
	$(MAKE) ipl.bin

img :
	$(MAKE) haribote.img

run :
	$(MAKE) img
	qemu-system-i386 -drive file=haribote.img,format=raw,if=floppy -boot a

clean :
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst
	-$(DEL) tail.bin
	-$(DEL) tail.lst

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img
