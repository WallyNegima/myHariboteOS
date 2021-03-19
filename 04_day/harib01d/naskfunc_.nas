; naskfunc
; TAB=4

;[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード ; NASMではエラーが出るのでこの行削除	
;[INSTRSET "i486p"]				; 486の命令まで使いたいという記述 ; NASMではエラーが出るのでこの行削除
[BITS 32]						; 32ビットモード用の機械語を作らせる
;[FILE "naskfunc.nas"]			; ソースファイル名情報 ; NASMではエラーが出るのでこの行削除

		;GLOBAL	_io_hlt
		GLOBAL	io_hlt			; NASMではエラーが出るので修正

[SECTION .text]

;io_hlt:	; void io_hlt(void);
io_hlt:	; void io_hlt(void);	; NASMではエラーが出るので修正
		HLT
		RET
