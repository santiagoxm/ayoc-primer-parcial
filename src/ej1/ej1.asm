extern malloc
extern strcpy

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

; tuit_t *publicar(char *mensaje, usuario_t *usuario);
global publicar
publicar:
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rdi ; char mensaje*
	mov r13, rsi ; usuario_t usuario*
	
	mov rdi, TUIT_SIZE
	call malloc
	mov r14, rax ; tuit_t*

	mov rdi, r14
	mov rsi, r12
	call strcpy

	mov word [r14 + TUIT_FAVORITOS_OFFSET], 0
	mov word [r14 + TUIT_RETUITS_OFFSET], 0
	mov r10d, dword [r13 + USUARIO_ID_OFFSET]
	mov dword [r14 + TUIT_ID_AUTOR_OFFSET], r10d

	mov rdi, r14
	mov rsi, qword [r13 + USUARIO_FEED_OFFSET]

	call agregarTuitAFeed

	xor r15, r15 ; i
	mov rbx, [r13 + USUARIO_SEGUIDORES_OFFSET]
	.iterarSobreSeguidores:
	cmp r15d, dword [r13 + USUARIO_CANT_SEGUIDORES_OFFSET]
	je .return
	mov r11, qword [rbx + r15*8]
	mov rdi, r14 
	mov rsi, qword [r11 + USUARIO_FEED_OFFSET]
	call agregarTuitAFeed
	inc r15d
	jmp .iterarSobreSeguidores

	.return:

	mov rax, r14 

	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	ret

agregarTuitAFeed:
	push r12
	push r13
	push r14

	mov r12, rdi ; tweet_t
	mov r13, rsi ; feed_t

	mov rdi, PUBLICACION_SIZE
	call malloc
	mov r14, rax ; publicacion_t

	mov qword [r14 + PUBLICACION_VALUE_OFFSET], r12

	mov r10, qword [r13 + FEED_FIRST_OFFSET]
	mov qword [r14 + PUBLICACION_NEXT_OFFSET], r10
	mov qword [r13 + FEED_FIRST_OFFSET], r14

	pop r14
	pop r13
	pop r12
	ret
