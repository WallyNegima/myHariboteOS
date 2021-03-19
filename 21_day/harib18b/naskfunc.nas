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
		GLOBAL	asm_inthandler20, asm_inthandler21, asm_inthandler27, asm_inthandler2c
		GLOBAL	memtest_sub
		GLOBAL	farjmp
		GLOBAL	asm_hrb_api
		GLOBAL	farcall
		GLOBAL	start_app
		EXTERN	inthandler20, inthandler21
		EXTERN  inthandler27, inthandler2c
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
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler20
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler20
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS��A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP��A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler21
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler21
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS��A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP��A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler27
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler27
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS��A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP��A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
;	OS�������Ă���Ƃ��Ɋ��荞�܂ꂽ�̂łقڍ��܂łǂ���
		MOV		EAX,ESP
		PUSH	SS				; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		PUSH	EAX				; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler2c
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
;	�A�v���������Ă���Ƃ��Ɋ��荞�܂ꂽ
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; ���荞�܂ꂽ�Ƃ���SS��ۑ�
		MOV		[ECX  ],ESP		; ���荞�܂ꂽ�Ƃ���ESP��ۑ�
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler2c
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SS��A�v���p�ɖ߂�
		MOV		ESP,ECX			; ESP��A�v���p�ɖ߂�
		POPAD
		POP		DS
		POP		ES
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
		PUSH	DS
		PUSH	ES
		PUSHAD		; �ۑ��̂��߂�PUSH
		MOV		EAX,1*8
		MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
		MOV		ECX,[0xfe4]		; OS��ESP
		ADD		ECX,-40
		MOV		[ECX+32],ESP	; �A�v����ESP��ۑ�
		MOV		[ECX+36],SS		; �A�v����SS��ۑ�

; PUSHAD�����l��V�X�e���̃X�^�b�N�ɃR�s�[����
		MOV		EDX,[ESP   ]
		MOV		EBX,[ESP+ 4]
		MOV		[ECX   ],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+ 4],EBX	; hrb_api�ɓn�����߃R�s�[
		MOV		EDX,[ESP+ 8]
		MOV		EBX,[ESP+12]
		MOV		[ECX+ 8],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+12],EBX	; hrb_api�ɓn�����߃R�s�[
		MOV		EDX,[ESP+16]
		MOV		EBX,[ESP+20]
		MOV		[ECX+16],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+20],EBX	; hrb_api�ɓn�����߃R�s�[
		MOV		EDX,[ESP+24]
		MOV		EBX,[ESP+28]
		MOV		[ECX+24],EDX	; hrb_api�ɓn�����߃R�s�[
		MOV		[ECX+28],EBX	; hrb_api�ɓn�����߃R�s�[

		MOV		ES,AX			; �c��̃Z�O�����g���W�X�^��OS�p�ɂ���
		MOV		SS,AX
		MOV		ESP,ECX
		STI			; ����Ɗ��荞�݋���

		CALL	hrb_api

		MOV		ECX,[ESP+32]	; �A�v����ESP��v���o��
		MOV		EAX,[ESP+36]	; �A�v����SS��v���o��
		CLI
		MOV		SS,AX
		MOV		ESP,ECX
		POPAD
		POP		ES
		POP		DS
		IRETD		; ���̖��߂�������STI���Ă����

start_app:
		PUSHAD
		MOV		EAX,[ESP+36]
		MOV		ECX,[ESP+40]
		MOV		EDX,[ESP+44]
		MOV		EBX,[ESP+48]
		MOV		[0xfe4],ESP
		CLI
		MOV		ES,BX
		MOV		SS,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
		MOV		ESP,EDX
		STI
		PUSH	ECX
		PUSH	EAX
		CALL	FAR [ESP]
		;アプリが終了したら戻ってくる
		MOV		EAX,1*8
		CLI
		MOV		ES,AX
		MOV		SS,AX
		MOV		DS,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		ESP,[0xfe4]
		STI
		POPAD
		RET