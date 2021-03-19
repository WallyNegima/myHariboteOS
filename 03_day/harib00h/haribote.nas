CYLS		EQU		0x0ff0 ; boot sector
LEDS		EQU		0x0ff1 ;
VMODE		EQU		0x0ff2 ; 色に関する情報
SCRNX		EQU		0x0ff4 ; 解像度のX
SCRNY		EQU		0x0ff6 ; 解像度のY
VRAM		EQU		0x0ff8 ; グラフィックバッファの開始番地

		ORG		0xc200
		MOV		AL,0x13
		MOV		AH,0x00
		INT		0x10
		MOV		BYTE [VMODE],8 ; 画面モードをメモ
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM], 0x000a0000

; キーボードのLED状態をBIOSに教えてもらう
		MOV		AH,0x02
		INT		0x16
		MOV		[LEDS],AL

fin:
		HLT
		JMP		fin
