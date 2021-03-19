[BITS 32]; 32ビットモード用の機械語を作らせる宣言

;[FILE "naskfunc.nas"] ; ソールファイル名．nasmではエラーがでる
		GLOBAL		io_hlt,write_mem8

[SECTION	.text]

io_hlt: ; void io_hlt(void)
		HLT
		RET

write_mem8: ; void write_mem8(int addr, int data);
		MOV		ECX,[ESP+4] ; ESP+4にaddrが入っているのでそれをECXに読み込む
		MOV		AL,[ESP+8] ; ESP+8にdataが入ってるので読み込む
		MOV		[ECX],AL
		RET
