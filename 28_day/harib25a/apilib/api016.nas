GLOBAL	api_alloctimer

[SECTION .text]

api_alloctimer: ; int api_alloctimer (void);
	mov		edx, 16
	int		0x40
	ret

