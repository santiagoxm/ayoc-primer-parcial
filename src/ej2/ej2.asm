extern free

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

; void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear);
global bloquearUsuario 
bloquearUsuario: ; RDI = *USUARIO , RSI = *USUARIOABLOQUEAR

	push r12
	push r13
	sub rsp, 8

	mov r12, rdi
	mov r13, rsi

	mov r8d, [RDI + USUARIO_CANT_BLOQUEADOS_OFFSET]
	mov r9, [RDI + USUARIO_BLOQUEADOS_OFFSET] ; r9 = *USUARIO_BLOQUEADOS
	mov [r9 + r8 * 8], RSI

	inc dword [RDI + USUARIO_CANT_BLOQUEADOS_OFFSET]

	mov rdi, [r12 + USUARIO_FEED_OFFSET]
	mov RSI, [R13 + USUARIO_ID_OFFSET]
	call borrarPublicacionesDeFeed

	mov rdi, [r13 + USUARIO_FEED_OFFSET]
	mov rsi, [R12 + USUARIO_ID_OFFSET]
	call borrarPublicacionesDeFeed

	add rsp, 8
	pop r13
	pop r12

	ret

borrarPublicacionesDeFeed: ; RDI = *FEED, RSI = ID

	push r12
	push r13
	push r14

	mov R12D, ESI ; R12 = ID
	mov R13, RDI ; R13 = **PREV
	mov R14, [R13]  ; R14 = *PUB

	.whilePubNotNull:

		cmp R14, 0
		je .fin

		mov r10, [R14 + PUBLICACION_VALUE_OFFSET]
		mov r10d, dword [r10 + TUIT_ID_AUTOR_OFFSET] ; r10 = PUBLICACION_ID

		cmp r10d, R12D ; PUBLICACION_ID = ID_A_BLOQUEAR
		je .ifTrue
		jne .ifFalse

		.ifTrue:
			
			mov r11, [ R14 + PUBLICACION_NEXT_OFFSET ]
			mov [ R13 ], r11

			mov RDI, R14 
			call free ; free(PUB)

			jmp .nextIteration

		.ifFalse:

			lea r13, [ R14 + PUBLICACION_NEXT_OFFSET ]

		.nextIteration:

		mov R14, [ R13 ]

		jmp .whilePubNotNull
	
	.fin:
	pop r14
	pop r13
	pop r12

	ret
