
; ESTUDIANTE
	global estudianteCrear
	global estudianteBorrar
	global menorEstudiante
	global estudianteConFormato
	global estudianteImprimir

; ALTALISTA y NODO
	global nodoCrear
	global nodoBorrar
	global altaListaCrear
	global altaListaBorrar
	global altaListaImprimir

; AVANZADAS
	global edadMedia
	global insertarOrdenado
	global filtrarAltaLista

; OPCIONALES
	global string_longitud
	global string_copiar
	global string_menor

; YA IMPLEMENTADAS EN C
	extern string_iguales
	extern insertarAtras

; DEFINES
	%define NULL 	0x0
	%define TRUE 	0x1
	%define FALSE 	0x0

	%define ALTALISTA_SIZE     		0x10
	%define OFFSET_PRIMERO 			0x0
	%define OFFSET_ULTIMO  			0x8

	%define NODO_SIZE     			0x18
	%define OFFSET_SIGUIENTE   		0x0
	%define OFFSET_ANTERIOR   		0x8
	%define OFFSET_DATO 			0x10

	%define ESTUDIANTE_SIZE  		0x14
	%define OFFSET_NOMBRE 			0x0
	%define OFFSET_GRUPO  			0x8
	%define OFFSET_EDAD 			0x10

; FUNCIONES STANDARD QUE USO
	extern malloc
	extern free
	extern fprintf
	extern fopen
	extern fclose

section .rodata
	estImprFormat: DB '%s', 10, 9, '%s', 10, 9, '%d', 10, 0
	fopenMode: DB 'a', 0
	emptyImprFormat: DB '<vacia>', 10, 0
section .data


section .text
	;unsigned char string_longitud( char *s )
	string_longitud:
		mov rax, 0x0

	_string_longitud_loop:
		cmp byte [rdi + rax], 0x0
		je _string_longitud_end
		inc rax
		jmp _string_longitud_loop

	_string_longitud_end:
		ret

	;char *string_copiar( char *s );
	string_copiar:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		sub rsp, 8

		mov r12, rdi
		call string_longitud

		mov r13, rax
		mov rdi, rax
		add rdi, 1
		call malloc

		cmp rax, NULL
		je _string_copiar_end

		mov rcx, r13

	_string_copiar_loop:
		mov bl, [r12 + rcx]
		mov [rax + rcx], bl
		loop _string_copiar_loop

		mov bl, [r12 + rcx]
		mov [rax + rcx], bl

	_string_copiar_end:
		add rsp, 8
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	;bool string_menor( char *s1, char *s2 );
	string_menor:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14

		mov rax, 0x0
		mov r12, rdi
		mov r13, rsi
		mov r14, 0x0
	_string_menor_loop:
		mov al, [r12 + r14]
		mov bl, [r13 + r14]

		cmp al, bl
		jne _string_menor_end

		cmp al, 0x0
		je _string_menor_end

		inc r14
		jmp _string_menor_loop

	_string_menor_end:
		cmp al, bl
		jge _string_menor_false
		mov rax, TRUE
		jmp _string_menor_out
	_string_menor_false:
		mov rax, FALSE
	_string_menor_out:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; estudiante *estudianteCrear( char *nombre, char *grupo, unsigned int edad );
	estudianteCrear:
		push rbp
		mov rbp, rsp
		push r12
		push r13
		push r14
		sub rsp, 8

		mov r12, rdi
		mov r13, rsi ; r13 = grupo
		mov r14, rdx ; r14 = edad

		mov rdi, r12
		call string_copiar
		mov r12, rax; r12 = strcpy(nombre)

		mov rdi, r13
		call string_copiar
		mov r13, rax ; r13 = strcpy(grupo)

		mov rdi, ESTUDIANTE_SIZE ; Cantidad de bytes para la estructura
		call malloc
		cmp rax, NULL ; Si devuelve NULL, es que hubo un error
		je _estudianteCrear_end ; Devolvemos NULL

		mov [rax + OFFSET_NOMBRE], r12
		mov [rax + OFFSET_GRUPO], r13
		mov [rax + OFFSET_EDAD], r14d

	_estudianteCrear_end:
		add rsp, 8
		pop r14
		pop r13
		pop r12
		pop rbp
		ret

	; void estudianteBorrar( estudiante *e );
	estudianteBorrar:
		push rbp
		mov rbp, rsp
		push r12
		sub rsp, 8

		mov r12, rdi

		mov rdi, [r12 + OFFSET_NOMBRE]
		call free

		mov rdi, [r12 + OFFSET_GRUPO]
		call free

		mov rdi, r12
		call free

		add rsp, 8
		pop r12
		pop rbp
		ret

	; bool menorEstudiante( estudiante *e1, estudiante *e2 ){
	menorEstudiante:
		push rbp
		mov rbp, rsp
		push r12
		push r13

		mov r12, rdi
		mov r13, rsi

		mov rdi, [r12 + OFFSET_NOMBRE]
		mov rsi, [r13 + OFFSET_NOMBRE]
		call string_menor

		cmp rax, TRUE
		je _menorEstudiante_true

		mov rdi, [r12 + OFFSET_NOMBRE]
		mov rsi, [r13 + OFFSET_NOMBRE]
		call string_iguales

		cmp rax, FALSE
		je _menorEstudiante_false

		mov r8d, [r13 + OFFSET_EDAD]
		cmp [r12 + OFFSET_EDAD], r8d
		jg _menorEstudiante_false

	_menorEstudiante_true:
		mov rax, TRUE
		jmp _menorEstudiante_end

	_menorEstudiante_false:
		mov rax, FALSE

	_menorEstudiante_end:
		pop r13
		pop r12
		pop rbp
		ret

	; void estudianteConFormato( estudiante *e, tipoFuncionModificarString f )
	estudianteConFormato:
		push rbp
		mov rbp, rsp
		push r12
		push r13

		mov r12, rdi
		mov r13, rsi

		mov rdi, [r12 + OFFSET_NOMBRE]
		call r13

		mov rdi, [r12 + OFFSET_GRUPO]
		call r13

		pop r13
		pop r12
		pop rbp
		ret

	; void estudianteImprimir( estudiante *e, FILE *file )
	estudianteImprimir:
		mov rax, 0x0
		mov rdx, [rdi + OFFSET_NOMBRE]
		mov rcx, [rdi + OFFSET_GRUPO]
		mov r8d, [rdi + OFFSET_EDAD]
		mov rdi, rsi
		mov rsi, estImprFormat
		call fprintf

		ret


; FUNCIONES DE ALTALISTA Y NODO
;--------------------------------------------------------------------------------------------------------

	; nodo *nodoCrear( void *dato )
	nodoCrear:
		push rbp
		mov rbp, rsp
		push r12
		sub rsp, 8

		mov r12, rdi

		mov rdi, NODO_SIZE
		call malloc
		cmp rax, NULL
		je _nodoCrear_end

		mov qword [rax + OFFSET_SIGUIENTE], NULL
		mov qword [rax + OFFSET_ANTERIOR], NULL
		mov [rax + OFFSET_DATO], r12

	_nodoCrear_end:
		add rsp, 8
		pop r12
		pop rbp
		ret

	; void nodoBorrar( nodo *n, tipoFuncionBorrarDato f )
	nodoBorrar:
		push rbp
		mov rbp, rsp
		push r12
		push r13

		mov r12, rdi
		mov r13, rsi

		cmp qword [r12 + OFFSET_ANTERIOR], NULL
		jne _nodoBorrar_anterior

	_nodoBorrar_back:
		cmp qword [r12 + OFFSET_SIGUIENTE], NULL
		jne _nodoBorrar_siguiente

		jmp _nodoBorrar_end

	_nodoBorrar_anterior:
		mov r8, [r12 + OFFSET_ANTERIOR]
		mov r9, [r12 + OFFSET_SIGUIENTE]
		mov qword [r8 + OFFSET_SIGUIENTE], r9
		jmp _nodoBorrar_back

	_nodoBorrar_siguiente:
		mov r8, [r12 + OFFSET_SIGUIENTE]
		mov r9, [r12 + OFFSET_ANTERIOR]
		mov qword [r8 + OFFSET_ANTERIOR], r9

	_nodoBorrar_end:
		mov rdi, [r12 + OFFSET_DATO]
		call r13

		mov rdi, r12
		call free

		pop r13
		pop r12
		pop rbp
		ret

	; altaLista *altaListaCrear( void )
	altaListaCrear:
		mov rdi, ALTALISTA_SIZE
		call malloc
		cmp rax, NULL
		je _altaListaCrear_end

		mov qword [rax + OFFSET_PRIMERO], NULL
		mov qword [rax + OFFSET_ULTIMO], NULL

	_altaListaCrear_end:
		ret

	; void altaListaBorrar( altaLista *l, tipoFuncionBorrarDato f )
	altaListaBorrar:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		sub rsp, 8

		mov r12, rdi
		mov r13, rsi
		mov rbx, [r12 + OFFSET_PRIMERO]

		mov rbx, [r12 + OFFSET_PRIMERO]

	_altaListaBorrar_loop:
		cmp rbx, NULL
		je _altaListaBorrar_end

		mov rdi, rbx
		mov rbx, [rbx + OFFSET_SIGUIENTE]

		mov rsi, r13
		call nodoBorrar

		jmp _altaListaBorrar_loop

	_altaListaBorrar_end:
		mov rdi, r12
		call free

		add rsp, 8
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void altaListaImprimir( altaLista *l, char *archivo, tipoFuncionImprimirDato f )
	altaListaImprimir:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14

		mov r12, rdi
		mov r13, rsi
		mov r14, rdx

		mov rdi, r13
		mov rsi, fopenMode
		call fopen
		mov r13, rax

		cmp r13, NULL
		je _altaListaImprimir_reallyEnd

		cmp qword [r12 + OFFSET_PRIMERO], NULL
		je _altaListaImprimir_empty

		mov rbx, [r12 + OFFSET_PRIMERO]

	_altaListaImprimir_loop:
		; Imprimo
		mov rdi, [rbx + OFFSET_DATO]
		mov rsi, r13
		call r14

		mov rbx, [rbx + OFFSET_SIGUIENTE]
		cmp rbx, NULL
		je _altaListaImprimir_close
		jmp _altaListaImprimir_loop

	_altaListaImprimir_empty:
		; Imprimo fin de lista
		mov rdi, r13
		mov rsi, emptyImprFormat
		call fprintf
	_altaListaImprimir_close:
		; Cierro el archivo
		mov rdi, r13
		call fclose
	_altaListaImprimir_reallyEnd:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret


; FUNCIONES AVANZADAS
;----------------------------------------------------------------------------------------------

	; float edadMedia( altaLista *l )
	edadMedia:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14

		cmp qword [rdi + OFFSET_PRIMERO], NULL
		je _edadMedia_reallyEnd

		mov r12, rdi
		mov rbx, [rdi + OFFSET_PRIMERO]

		mov r13, 0x0
		mov r14, 0x0

	_edadMedia_loop:
		mov r8, [rbx + OFFSET_DATO]
		add r13d, [r8 + OFFSET_EDAD]
		inc r14d

		mov rbx, [rbx + OFFSET_SIGUIENTE]

		cmp rbx, NULL
		je _edadMedia_end
		jmp _edadMedia_loop

	_edadMedia_end:
		xorps xmm0, xmm0
		xorps xmm1, xmm1
		cvtsi2ss xmm0, r13d
		cvtsi2ss xmm1, r14d
		divss xmm0, xmm1

	_edadMedia_reallyEnd:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )
	insertarOrdenado:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
		push r15
		sub rsp, 0x8

		mov r12, rdi ; r12 = l
		mov r13, rsi ; r13 = dato
		mov r14, rdx ; r14 = f

		mov rdi, r13
		call nodoCrear
		mov r15, rax ; r15 = nodoCrear(dato)

		cmp qword [r12 + OFFSET_PRIMERO], NULL
		je _insertarOrdenado_empty

		mov rbx, [r12 + OFFSET_PRIMERO]

	_insertarOrdenado_loop:
		cmp rbx, NULL
		je _insertarOrdenado_sig

		mov rdi, [r15 + OFFSET_DATO]
		mov rsi, [rbx + OFFSET_DATO]
		call r14

		cmp rax, TRUE
		je _insertarOrdenado_sig

		mov rbx, [rbx + OFFSET_SIGUIENTE]
		jmp _insertarOrdenado_loop

	_insertarOrdenado_sig:
		cmp rbx, NULL
		je _insertarOrdenado_final

		cmp qword [rbx + OFFSET_ANTERIOR], NULL
		je _insertarOrdenado_principio

		mov r8, [rbx + OFFSET_ANTERIOR]
		mov [r15 + OFFSET_ANTERIOR], r8
		mov [r15 + OFFSET_SIGUIENTE], rbx

		mov r8, [rbx + OFFSET_ANTERIOR]
		mov [r8 + OFFSET_SIGUIENTE], r15
		mov [rbx + OFFSET_ANTERIOR], r15
		jmp _insertarOrdenado_end

	_insertarOrdenado_principio:
		mov [rbx + OFFSET_ANTERIOR], r15
		mov [r15 + OFFSET_SIGUIENTE], rbx
		mov [r12 + OFFSET_PRIMERO], r15
		jmp _insertarOrdenado_end

	_insertarOrdenado_final:
		mov r8, [r12 + OFFSET_ULTIMO]
		mov [r8 + OFFSET_SIGUIENTE], r15
		mov [r15 + OFFSET_ANTERIOR], r8
		mov [r12 + OFFSET_ULTIMO], r15
		jmp _insertarOrdenado_end

	_insertarOrdenado_empty:
		mov [r12 + OFFSET_PRIMERO], r15
		mov [r12 + OFFSET_ULTIMO], r15

	_insertarOrdenado_end:
		add rsp, 0x8
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

	; void filtrarAltaLista( altaLista *l, tipoFuncionCompararDato f, void *datoCmp )
	filtrarAltaLista:
		push rbp
		mov rbp, rsp
		push rbx
		push r12
		push r13
		push r14
		push r15
		sub rsp, 8

		mov r12, rdi
		mov r13, rsi
		mov r14, rdx

	 	mov rbx, [r12 + OFFSET_PRIMERO]

	_filtrarAltaLista_loop:
		cmp rbx, NULL
		je _filtrarAltaLista_end

		mov rdi, [rbx + OFFSET_DATO]
		mov rsi, r14
		call r13

		cmp rax, TRUE
		je _filtrarAltaLista_skip

		mov r15, [rbx + OFFSET_SIGUIENTE]

		cmp rbx, [r12 + OFFSET_PRIMERO]
		je _filtrarAltaLista_primero

	_filtrarAltaLista_back:
		cmp rbx, [r12 + OFFSET_ULTIMO]
		je _filtrarAltaLista_ultimo

	_filtrarAltaLista_back2:
		mov rdi, rbx
		mov rsi, estudianteBorrar
		call nodoBorrar

		mov rbx, r15

		jmp _filtrarAltaLista_loop

	_filtrarAltaLista_skip:
		mov rbx, [rbx + OFFSET_SIGUIENTE]
		jmp _filtrarAltaLista_loop

	_filtrarAltaLista_primero:
		mov r8, [rbx + OFFSET_SIGUIENTE]
		mov [r12 + OFFSET_PRIMERO], r8

		cmp r8, NULL
		je _filtrarAltaLista_back

		mov qword [r8 + OFFSET_ANTERIOR], NULL
		jmp _filtrarAltaLista_back

	_filtrarAltaLista_ultimo:
		mov r8, [rbx + OFFSET_ANTERIOR]
		mov [r12 + OFFSET_ULTIMO], r8

		cmp r8, NULL
		je _filtrarAltaLista_back2

		mov qword [r8 + OFFSET_SIGUIENTE], NULL
		jmp _filtrarAltaLista_back2

	_filtrarAltaLista_end:
		add rsp, 8
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret

