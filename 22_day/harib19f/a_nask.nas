[BITS 32]
    GLOBAL    api_putchar,api_putstr0
    GLOBAL    api_openwin, api_putstrwin, api_boxfilwin
    GLOBAL    api_end

[SECTION .text]
api_putchar:
    MOV   EDX,1
    MOV   AL,[ESP+4]
    INT   0x40
    RET

api_putstr0:
    PUSH    EBX
    MOV     EDX,2
    MOV     EBX,[ESP+8]
    INT     0x40
    POP     EBX
    RET

api_end:
    MOV     EDX,4
    INT     0x40

api_openwin:
    PUSH    EDI
    PUSH    ESI
    PUSH    EBX
    MOV		EDX,5
    MOV		EBX,[ESP+16]	; buf
    MOV		ESI,[ESP+20]	; xsiz
    MOV		EDI,[ESP+24]	; ysiz
    MOV		EAX,[ESP+28]	; col_inv
    MOV		ECX,[ESP+32]	; title
    INT		0x40
    POP		EBX
    POP		ESI
    POP		EDI
    RET

api_putstrwin:	; void api_putstrwin(int win, int x, int y, int col, int len, char *str);
		PUSH	EDI
		PUSH	ESI
		PUSH	EBP
		PUSH	EBX
		MOV		EDX,6
		MOV		EBX,[ESP+20]	; win
		MOV		ESI,[ESP+24]	; x
		MOV		EDI,[ESP+28]	; y
		MOV		EAX,[ESP+32]	; col
		MOV		ECX,[ESP+36]	; len
		MOV		EBP,[ESP+40]	; str
		INT		0x40
		POP		EBX
		POP		EBP
		POP		ESI
		POP		EDI
		RET

api_boxfilwin:	; void api_boxfilwin(int win, int x0, int y0, int x1, int y1, int col);
		PUSH	EDI
		PUSH	ESI
		PUSH	EBP
		PUSH	EBX
		MOV		EDX,7
		MOV		EBX,[ESP+20]	; win
		MOV		EAX,[ESP+24]	; x0
		MOV		ECX,[ESP+28]	; y0
		MOV		ESI,[ESP+32]	; x1
		MOV		EDI,[ESP+36]	; y1
		MOV		EBP,[ESP+40]	; col
		INT		0x40
		POP		EBX
		POP		EBP
		POP		ESI
		POP		EDI
		RET