[BITS 32]; 32ビットモード用の機械語を作らせる宣言

;[FILE "naskfunc.nas"] ; ソールファイル名．nasmではエラーがでる
		GLOBAL		io_hlt
[SECTION	.text]
io_hlt: ; void io_hlt(void)
		HLT
		RET
