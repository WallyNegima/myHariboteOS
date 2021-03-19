; naskfunc
; TAB=4

;[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード ; NASMではエラーが出るのでこの行削除	
;[INSTRSET "i486p"]				; 486の命令まで使いたいという記述 ; NASMではエラーが出るのでこの行削除
[BITS 32]						; 32ビットモード用の機械語を作らせる
;[FILE "naskfunc.nas"]			; ソースファイル名情報 ; NASMではエラーが出るのでこの行削除

		; 以下、アンダーバー付き関数名からアンダーバー除いた関数名に修正する
		; _io_hlt →　io_hlt など
		GLOBAL	io_hlt, io_cli, io_sti, io_stihlt
		GLOBAL	io_in8,  io_in16,  io_in32
		GLOBAL	io_out8, io_out16, io_out32
		GLOBAL	io_load_eflags, io_store_eflags
		GLOBAL	load_gdtr, load_idtr
		GLOBAL	load_cr0, store_cr0
		GLOBAL	load_tr
		GLOBAL	asm_inthandler20, asm_inthandler21, asm_inthandler27, asm_inthandler2c, asm_inthandler0d
		GLOBAL	memtest_sub
		GLOBAL	farjmp
		GLOBAL	asm_hrb_api
		GLOBAL	farcall
		GLOBAL	start_app
		EXTERN	inthandler20, inthandler21
		EXTERN  inthandler27, inthandler2c
		EXTERN	inthandler0d
		EXTERN	hrb_api

[SECTION .text]

io_hlt:	; void io_hlt(void);
		HLT
		RET

io_cli:	; void io_cli(void);
		CLI
		RET

io_sti:	; void io_sti(void);
		STI
		RET

io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

io_in8:	; int io_in8(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AL,DX
		RET

io_in16:	; int io_in16(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AX,DX
		RET

io_in32:	; int io_in32(int port);
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

io_out16:	; void io_out16(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

io_out32:	; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

io_load_eflags:	; int io_load_eflags(void);
		PUSHFD		; PUSH EFLAGS という意味
		POP		EAX
		RET

io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD		; POP EFLAGS という意味
		RET

load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

load_cr0:
		MOV		EAX,CR0
		RET

store_cr0:
		MOV		EAX,[ESP+4]
		MOV		CR0,EAX
		RET

load_tr:
		LTR		[ESP+4]
		RET

asm_inthandler20:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler20
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler27
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler2c
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler0d:
		STI
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler0d
		CMP		EAX,0		; ���������Ⴄ
		JNE		end_app		; ���������Ⴄ
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		ADD		ESP,4			; INT 0x0d �ł́A���ꂪ�K�v
		IRETD

memtest_sub:
		PUSH		EDI
		PUSH		ESI
		PUSH		EBX
		MOV			ESI, 0xaa55aa55
		MOV			EDI, 0x55aa55aa
		MOV			EAX,[ESP+12+4]

mts_loop:
		MOV		EBX,EAX
		ADD		EBX, 0xffc
		MOV		EDX,[EBX]
		MOV		[EBX],ESI
		XOR		DWORD [EBX], 0xffffffff;
		CMP		EDI,[EBX]
		JNE		mts_fin
		XOR		DWORD [EBX], 0xffffffff;
		CMP		ESI,[EBX]
		JNE		mts_fin
		MOV		[EBX],EDX
		ADD		EAX,0x1000
		CMP		EAX,[ESP+12+8]
		JBE		mts_loop
		POP		EBX
		POP		ESI
		POP		EDI
		RET

mts_fin
		MOV		[EBX],EDX
		POP		EBX
		POP		ESI
		POP		EDI
		RET

farjmp:
		JMP		FAR		[ESP+4]
		RET

farcall:
		CALL	FAR [ESP+4]
		RET

asm_hrb_api:
		STI
		PUSH	DS
		PUSH	ES
		PUSHAD		; �ۑ��̂��߂�PUSH
		PUSHAD		; hrb_api�ɂ킽�����߂�PUSH
		MOV		AX,SS
		MOV		DS,AX		; OS�p�̃Z�O�����g��DS��ES�ɂ����
		MOV		ES,AX
		CALL	hrb_api
		CMP		EAX,0		; EAX��0�łȂ���΃A�v���I������
		JNE		end_app
		ADD		ESP,32
		POPAD
		POP		ES
		POP		DS
		IRETD
end_app:
;	EAX��tss.esp0�̔Ԓn
		MOV		ESP,[EAX]
		POPAD
		RET		; ���̖��߂�������STI���Ă����

start_app:		; void start_app(int eip, int cs, int esp, int ds, int *tss_esp0);
		PUSHAD		; 32�r�b�g���W�X�^��S���ۑ����Ă���
		MOV		EAX,[ESP+36]	; �A�v���p��EIP
		MOV		ECX,[ESP+40]	; �A�v���p��CS
		MOV		EDX,[ESP+44]	; �A�v���p��ESP
		MOV		EBX,[ESP+48]	; �A�v���p��DS/SS
		MOV		EBP,[ESP+52]	; tss.esp0�̔Ԓn
		MOV		[EBP  ],ESP		; OS�p��ESP��ۑ�
		MOV		[EBP+4],SS		; OS�p��SS��ۑ�
		MOV		ES,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
;	�ȉ���RETF�ŃA�v���ɍs�����邽�߂̃X�^�b�N����
		OR		ECX,3			; �A�v���p�̃Z�O�����g�ԍ���3��OR����
		OR		EBX,3			; �A�v���p�̃Z�O�����g�ԍ���3��OR����
		PUSH	EBX				; �A�v����SS
		PUSH	EDX				; �A�v����ESP
		PUSH	ECX				; �A�v����CS
		PUSH	EAX				; �A�v����EIP
		RETF