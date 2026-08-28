extern malloc

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
TUIT_MENSAJE_OFFSET EQU 0
TUIT_FAVORITOS_OFFSET EQU 140
TUIT_RETUITS_OFFSET EQU 142
TUIT_ID_AUTOR_OFFSET EQU 144
TUIT_SIZE EQU 148

PUBLICACION_NEXT_OFFSET EQU 0
PUBLICACION_VALUE_OFFSET EQU 8
PUBLICACION_SIZE EQU 16

FEED_FIRST_OFFSET EQU 0 
FEED_SIZE EQU 8

USUARIO_FEED_OFFSET EQU 0;
USUARIO_SEGUIDORES_OFFSET EQU 8; 
USUARIO_CANT_SEGUIDORES_OFFSET EQU 16; 
USUARIO_SEGUIDOS_OFFSET EQU 24; 
USUARIO_CANT_SEGUIDOS_OFFSET EQU 32; 
USUARIO_BLOQUEADOS_OFFSET EQU 40; 
USUARIO_CANT_BLOQUEADOS_OFFSET EQU 48; 
USUARIO_ID_OFFSET EQU 52; 
USUARIO_SIZE EQU 56

; tuit_t **trendingTopic(usuario_t *usuario, uint8_t (*esTuitSobresaliente)(tuit_t *));
global trendingTopic 
trendingTopic:
	push R12
	push R13
	push R14
	push R15
	push RBX

	xor R15, R15

	mov R12, RDI
	mov R13, RSI

	call cantidadTuitsSobresalientes
	mov R14D, EAX
	cmp R14D, 0
	je .return

	mov EDI, R14D
	inc EDI
	lea EDI, [EDI*8]
	call malloc
	mov R15, RAX

	mov QWORD [R15 + R14*8], 0

	mov RBX, [R12 + USUARIO_FEED_OFFSET] ; RBX = user->feed
	mov RBX, [RBX + FEED_FIRST_OFFSET] ; RBX = feed->first

	mov R12D, [R12 + USUARIO_ID_OFFSET]

	.whileSobresalientes:
		cmp R14, 0
		je .return

		mov RDI, [RBX + PUBLICACION_VALUE_OFFSET]

		cmp [RDI + TUIT_ID_AUTOR_OFFSET], R12D
		jne .ifFalse

		call R13
		cmp EAX, 0
		je .ifFalse

		mov RDI, [RBX + PUBLICACION_VALUE_OFFSET]
		lea RDX, [R14 - 1]
		mov [R15 + RDX*8], RDI
		dec R14

		.ifFalse:

		mov RBX, [RBX + PUBLICACION_NEXT_OFFSET]

		jmp .whileSobresalientes

	.return:
	mov RAX, R15
	pop RBX
	pop R15
	pop R14
	pop R13
	pop R12
	ret

; uint32_t cantidadTuitsSobresalientes(usuario_t *user, uint8_t (*esTuitSobresaliente)(tuit_t *))
; RDI usuario_t *user, RSI uint8_t *esTuitSobresaliente(tuit_t *)
cantidadTuitsSobresalientes:
	push R12
	push R13
	push R14
	push R15
	sub RSP, 8

	mov R12D, [RDI + USUARIO_ID_OFFSET] ; R12 = user->id
	mov R13, [RDI + USUARIO_FEED_OFFSET] ; R13 = user->feed
	mov R13, [R13 + FEED_FIRST_OFFSET] ; R13 = feed->first

	xor R14, R14
	mov R15, RSI

	.whileNotNull:
		cmp R13, 0
		je .endWhile

		mov R10, [R13 + PUBLICACION_VALUE_OFFSET]
		cmp [R10 + TUIT_ID_AUTOR_OFFSET], R12D
		jne .ifFalse

		mov RDI, R10
		call R15

		add R14D, EAX

		.ifFalse:

		mov R13, [R13 + PUBLICACION_NEXT_OFFSET]

		jmp .whileNotNull

		.endWhile:

	mov EAX, R14D

	add RSP, 8
	pop R15
	pop R14
	pop R13
	pop R12
	ret
