 ; Nombre del estudiante: Sergie Salas Rojas
 ; Carnet: 2016138296
 ; Profesor: Kirstein Gätjens Soto
 ; Curso: Arquitectura de computadores
 ; Escuela de computación
 ; Fecha de entrega: 07/10/16
 ; Instituto tecnológico de Costa Rica
 ; Tarea: Pango
 ; Tarea de un juego en ensamblador, basado en pango
 
 ; Manual de Usuario
 ; para este programa se utilizo la maquina virtual DOS BOX, se recomienda tenerla para facilitar el empleo del programa
 ; para iniciar el programa se debe pasar el archivo a la carpeta en la que el DOS BOX esta montada
 ; se deben tener los TASM.EXE, TD.EXE y TLINK.EXE dentro de la carpeta del DOS BOX
 ; luego se debe digitar en la linea de comandos la instruccion: "tasm 16138296"
 ; esto genera el codigo objeto, luego se pone la instruccion: "tlink 16138296"
 ; para comenzar a jugar pango se digita "16138296" en la linea de comando, esto llevara al menu principal
 ; debe haber por lo menos un nivel en la misma carpeta que el juego con el formato 000.PGO el numero puede ser cualquiera entre 000 y 999
 ; para jugar se usan las flechas para mover a Teresa en la direccion que se desea
 ; con espacio se pueden patear bloques, se pateara el bloque en el que este viendo teresa
 ; el movimiento de teresa es continuo, no se detendra a menos que se cambie de direccion o se patee (no importa si hay bloques o no
 ; los bordes se consideran el fin del mundo, si algo pasa por ellos se piede para siempre
 ; para ganar el juego se deben poner los tres diamantes (X) en una linea sea horizontal o vertical, estos deben estar no deben estar en movimiento para que esto ocurra
 ; En el juego hay un oso que persigue a teresa, siempre intentara hacerlo a menos que algo le bloquee el camino
 ; Se puede aturdir al oso unos cuantos turnos si se le golpea con un diamante o con un cubo de hielo
 ; se pierde el juego si pasa lo siguiente: A) El oso alcanzo a Teresa y se la comio, B) se cayo un diamante por el fin del mundo, C) Teresa se cayo por el fin del mundo o D) Teresa fue atropellada por un cubo o un diamante 
 ; Se puede aumentar o disminuir la velocidad del juego con + y - respectivamente
 ; Para salirse de juego se puede presionar Esc en cualquier momento
 ; Para desplegar la ayuda del juego se presiona F1 mientras se juega
 ; Para ver el Acerca de se presiona Alt+A mientras se juega
 ; Se puede saltar un nivel con la tecla S, asi avanza al siguiente
 ; Los niveles son ciclicos, entonces se continua el juego hasta que se pierda o se presione Esc
 
 ;Analisis de resultados:
 ;Cargar Matriz de Archivo: A
 ;Desplegar Mapa del juego: A
 ;Mover a Teresa por el mapa: A
 ;Hacer que teresa patee bloques y diamantes: A
 ;Mover los bloques y diamantes (varios al mismo tiempo): A
 ;Armar el Oso: A
 ;Validar los niveles: A
 ;Inteligencia del Oso: A
 ;Manejo de teclado: A
 ;Aturdir al oso: A
 ;Paso de niveles de forma ciclica: A
 ;Funciones varias: A
 ;Nota en general: A
 
 
 
datos segment
		contadorNivel dw 999
		nombreArchNivel db "000.PGO",0
		handleArchPango dw ?
		matrizPango dw 2000 dup(0)
		bufferPanguito db ?
		camposRestantesMatriz dw 2000
		pangoRotulo db "              ___       ___          ___          ___          ___              "
					db "             /  /\     /  /\        /__/\        /  /\        /  /\             "
					db "            /  /::\   /  /::\       \  \:\      /  /:/_      /  /::\            "
					db "           /  /:/\:\ /  /:/\:\       \  \:\    /  /:/ /\    /  /:/\:\           "
					db "          /  /:/~/://  /:/~/::\  _____\__\:\  /  /:/_/::\  /  /:/  \:\          "
					db "         /__/:/ /://__/:/ /:/\:\/__/::::::::\/__/:/__\/\:\/__/:/ \__\:\         "
					db "         \  \:\/:/ \  \:\/:/__\/\  \:\~~\~~\/\  \:\ /~~/:/\  \:\ /  /:/         "
					db "          \  \::/   \  \::/      \  \:\  ~~~  \  \:\  /:/  \  \:\  /:/          "
					db "           \  \:\    \  \:\       \  \:\       \  \:\/:/    \  \:\/:/           "
					db "            \  \:\    \  \:\       \  \:\       \  \::/      \  \::/            "
					db "             \__\/     \__\/        \__\/        \__\/        \__\/             "
					db "                                                                                "
					db "                      Presione enter para comezar a jugar                       "
		
		Ayuda       db "                                     Ayuda                                      "
					db "    [Esc] Se sale de juego                                                      "
					db "    [Space] Teresa va a patear el cubo en la direccion en la que este viendo.   "
					db "    Tambien sirve para detenerse. Si el bloque no puede moverse y no es diamante"
					db "    Se destruye.                                                                "
					db "    [Las Flechas] dirigen la direccion de Teresa, se mueve hasta caerse del mapa"
					db "    o chocar con algun cubo.                                                    "
					db "    [F1] despliega esta ayuda                                                   "
					db "    [Alt+A] despliega el acerca de                                              "
					db "    [S] Demuestra su poca habilidad en el juego y se salta el nivel             "
					db "    [+] Aumenta la velocidad del juego                                          "
					db "    [-] Disminuye la velocidad del juego                                        "
					db "                      Presione una tecla para seguir jugando                    "
		
		AcercaDe    db "                                 Acerca De                                      "
					db "    Juego Variante de Pango                                                     "
					db "    Hecho por Sergie Salas Rojas                                                "
					db "    Carnet: 2016138296                                                          "
					db "    Curso: Arquitectura de computadores                                         "
					db "    Profesor: Kirstein Gatjens Soto                                             "
					db "    Grupo: 01                                                                   "
					db "                      Presione una tecla para seguir jugando                    "
					
		DerrotaRot  db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "          ______  _______  ______  ______  _____  _______ _______               "
					db "          |     \ |______ |_____/ |_____/ |     |    |    |_____|               "
					db "          |_____/ |______ |    \_ |    \_ |_____|    |    |     |               "
					db "                                                                                "
					db "                                                                                "
					db "                           El oso se puso libidinoso                            "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                       Presione enter para volver al menu                       "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					
		VictoriaRot db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "        _    _ _____ _______ _______  _____   ______ _____ _______              "
					db "         \  /    |   |          |    |     | |_____/   |   |_____|              "
					db "          \/   __|__ |_____     |    |_____| |    \_ __|__ |     |              "
					db "                                                                                "
					db "                                                                                "
					db "                         Teresa a reunido los cristales                         "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                  Presione enter para cargar el siguiente nivel                 "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					
		invalidoRot db "                                                                                "
					db "                .__   __.  __  ____    ____  _______  __                        "
					db "                |  \ |  | |  | \   \  /   / |   ____||  |                       "
					db "                |   \|  | |  |  \   \/   /  |  |__   |  |                       "
					db "                |  . `  | |  |   \      /   |   __|  |  |                       "
					db "                |  |\   | |  |    \    /    |  |____ |  `----.                  "
					db "                |__| \__| |__|     \__/     |_______||_______|                  "
					db "                                                                                "
					db "       __  .__   __. ____    ____  ___       __       __   _______   ______     "
                    db "      |  | |  \ |  | \   \  /   / /   \     |  |     |  | |       \ /  __  \    "
                    db "      |  | |   \|  |  \   \/   / /  ^  \    |  |     |  | |  .--.  |  |  |  |   "
                    db "      |  | |  . `  |   \      / /  /_\  \   |  |     |  | |  |  |  |  |  |  |   "
                    db "      |  | |  |\   |    \    / /  _____  \  |  `----.|  | |  '--'  |  `--'  |   "
                    db "      |__| |__| \__|     \__/ /__/     \__\ |_______||__| |_______/ \______/    "
					db "                                                                                "
					db "                                                                                "
					db "                  Presione enter para cargar el siguiente nivel                 "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
					db "                                                                                "
		camposRestantesFila dw 80
		color db 1
		contadorDiamantes db 0
		contadorPango db 0
		contadorOso db 0
		movimiento db 0
		filaPango db 0
		columnaPango db 0
		filaOso db 0
		columnaOso db 0
		colorSave db ?
		asciiSave db ?
		nops1 dw 2000
        nops2 dw 50
		ciclosBloques db 2
		contVictoria db 0
		ciclosOsete db 4
		aturdidorOso db 0
		boolDerrota db 0
		boolVictoria db 0
		boolPausa db 0
		boolMoverse db 0
datos ends; termina el segmento de datos

pila segment stack 'stack'

    dw 512 dup (?) ; se define la pila
    

pila ends

codigo segment; inicio del codigo

    assume  cs:codigo, ds:datos, ss:pila

inicio:	
			mov ax, ds ; esta seccion mueve todos los datos que se necesitan y pone en cero los registros que se van a usar
			mov es, ax
			mov ax, datos
			mov ds, ax
			mov ax, pila
			mov ss, ax
			call menuPango
			mov ax, 4C00h
			int 21h 
			
menuPango proc near;rutina que despliega el menu de pango
	xor dx,dx
	mov cx,400
	mov ax, 0B800h
    mov es, ax
	xor si,si
	xor di,di
	mov dl,' '
	cargarLayoutparte1:
	mov word ptr Es:[si],dx
	inc si
	inc si
	loop cargarLayoutparte1
	mov cx,960
	mov dh,1100b
	cargarLayoutparte2:
	mov dl, byte ptr pangoRotulo[di]
	inc di
	mov word ptr Es:[si],dx
	inc si
	inc si
	loop cargarLayoutparte2
	mov cx,80
	mov dh, 10001111b
	cargarLayoutparte3:
	mov dl, byte ptr pangoRotulo[di]
	inc di
	mov word ptr Es:[si],dx
	inc si
	inc si
	loop cargarLayoutparte3
	mov cx,560
	mov dh,1111b
	mov dl,' '
	cargarLayoutparte4:
	mov word ptr Es:[si],dx
	inc si
	inc si
	loop cargarLayoutparte4
	esperarTeclaMenu:
	mov ah,0
	int 16h
	cmp al,27
	jne noSalirMenu
	mov ax, 4C00h
	int 21h
	noSalirMenu:
	cmp al,13
	jne esperarTeclaMenu
	pop ax
	call jugarPango
	
	
endp

acercaDePango proc near;rutina que despliega el acerca De del pango
	xor si,si
	xor di,di
	mov si,800
	mov dh,001011111b
	mov cx,640
	cicloAcercade:
	mov dl,byte ptr acercaDe[di]
	inc di
	mov word ptr es:[si],dx
	inc si
	inc si
	loop cicloAcercade
	noTeclaAcercade:
	mov ah,01
	int 16h
	jz noTeclaAcercade
	ret
endp

ayudaPango proc near;rutina que despliega la ayuda del pango
	xor si,si
	xor di,di
	mov si,800
	mov dh,000011111b
	mov cx,1040
	cicloAyuda:
	mov dl,byte ptr ayuda[di]
	inc di
	mov word ptr es:[si],dx
	inc si
	inc si
	loop cicloAyuda
	noTeclaAyuda:
	mov ah,01
	int 16h
	jz noTeclaAyuda
	ret
endp			
			
jugarPango proc near;rutina para jugar pango, esta carga el siguiente nivel, lo valida y hace los movimientes/comandos
	nuevoNivel:
	mov boolMoverse,0
	mov boolDerrota,0
	mov boolVictoria,0
	mov movimiento,0
	mov contadorDiamantes,0
	mov contadorOso,0
	mov contadorPango,0
	call sigNivel
	call validaMapa
	call encontrarAPango
	mov columnaPango,ah
	mov filaPango,al
	call armarOso
	ciclosMovimiento:
	mov cx, nops1     
	ciclopausa1:     
	push cx
    mov cx,nops2
	ciclopausa2:
    nop 
	loop ciclopausa2
	pop cx
    loop ciclopausa1
	call verificarVictoriaHor
	call verificarVictoriaVer
	call desplegarMatriz
	cmp ciclosBloques,0
	je MoverBloques
	jmp NoMoverBloques
	MoverBloques:
	call moverDow
	call moverLef
	call moverRig
	call moverUp
	mov ciclosBloques,2
	NoMoverBloques:
	dec ciclosBloques
	cmp ciclosOsete,0
	jne osoHiberna
	call moverOso
	mov ciclosOsete,4
	osoHiberna:
	dec ciclosOsete
	mov ah,01h
	int 16h
	jz movimientoHelado
	jmp teclaMov
	movimientoHelado:
	cmp boolMoverse,0
	je ciclosMovimiento 
	cmp movimiento,0
	je ciclosMovimiento
	cmp movimiento,1
	je movRig
	cmp movimiento,2
	je movDow
	cmp movimiento,3
	je movLef
	jmp movUp
	movRig:
	mov ah,columnaPango
	mov al,filaPango
	cmp ah,79
	jne noDRig
	call derrota
	noDRig:
	inc ah
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne ignorarmovRig
	mov ah,columnaPango
	mov al,filaPango
	inc ah
	mov dh,1111b
	mov dl,'&'
	call ponerEnMatriz
	mov ah,columnaPango
	mov al,filaPango
	mov dh,1111b
	mov dl,' '
	call ponerEnMatriz
	inc columnaPango
	ignorarmovRig:
	jmp ciclosMovimiento
	movDow:
	mov ah,columnaPango
	mov al,filaPango
	cmp al,24
	jne noDDow
	call derrota
	noDDow:
	inc al
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne ignorarmovDow
	mov ah,columnaPango
	mov al,filaPango
	inc al
	mov dh,1111b
	mov dl,'&'
	call ponerEnMatriz
	mov ah,columnaPango
	mov al,filaPango
	mov dh,1111b
	mov dl,' '
	call ponerEnMatriz
	inc filaPango
	ignorarmovDow:
	jmp ciclosMovimiento
	movLef:
	mov ah,columnaPango
	mov al,filaPango
	cmp ah,0
	jne noDLef
	call derrota
	noDLef:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne ignorarmovLef
	mov ah,columnaPango
	mov al,filaPango
	dec ah
	mov dh,1111b
	mov dl,'&'
	call ponerEnMatriz
	mov ah,columnaPango
	mov al,filaPango
	mov dh,1111b
	mov dl,' '
	call ponerEnMatriz
	dec columnaPango
	ignorarmovLef:
	jmp ciclosMovimiento
	movUp:
	mov ah,columnaPango
	mov al,filaPango
	cmp al,0
	jne noDUp
	call derrota
	noDUp:
	dec al
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne ignorarmovUp
	mov ah,columnaPango
	mov al,filaPango
	dec al
	mov dh,1111b
	mov dl,'&'
	call ponerEnMatriz
	mov ah,columnaPango
	mov al,filaPango
	mov dh,1111b
	mov dl,' '
	call ponerEnMatriz
	dec filaPango
	ignorarmovUp:
	jmp ciclosMovimiento
	teclaMov:
	xor ah,ah
	int 16h
	cmp al,27
	jne continuar1
	mov ax,4C00h
	int 21h
	continuar1:
	cmp ah,77
	jne continuar2
	cmp movimiento,1
	je moverDer
	mov movimiento,1
	mov boolMoverse,0
	jmp ciclosMovimiento
	moverDer:
	mov boolMoverse,1
	jmp movRig
	continuar2:
	cmp ah,80
	jne continuar3
	cmp movimiento,2
	je moverAbajo
	mov movimiento,2
	mov boolMoverse,0
	jmp ciclosMovimiento
	moverAbajo:
	mov boolMoverse,1
	jmp movDow
	continuar3:
	cmp ah,75
	jne continuar4
	cmp movimiento,3
	je moverIzq
	mov movimiento,3
	mov boolMoverse,0
	jmp ciclosMovimiento
	moverIzq:
	mov boolMoverse,1
	jmp movLef
	continuar4:
	cmp ah,72
	jne continuar5
	cmp movimiento,4
	je moverArriba
	mov movimiento,4
	mov boolMoverse,0
	jmp ciclosMovimiento
	moverArriba:
	mov boolMoverse,1
	jmp movUp
	continuar5:
	cmp al,32
	jne continuar6
	call patearCubo
	mov movimiento,0
	jmp movimientoHelado
	continuar6:
	cmp al,'s'
	jne continuar7
	mov boolVictoria,1
	continuar7:
	cmp al,'S'
	jne continuar8
	mov boolVictoria,1
	continuar8:
	cmp ah,59
	jne continuar9
	call ayudaPango
	jmp movimientoHelado
	continuar9:
	cmp ah,30
	jne continuar10
	call acercaDePango
	jmp movimientoHelado
	continuar10:
	cmp al,'-'
	jne continuar11
	cmp nops1,5000
	je ciclosMenos
	add nops1,200
	ciclosMenos:
	jmp movimientoHelado
	continuar11:
	cmp al,'+'
	jne continuar12
	cmp nops1,400
	je ciclosMas
	sub nops1,200
	ciclosMas:
	jmp movimientoHelado
	continuar12:
	cmp boolVictoria,1
	jne seguirMovimientos
	call victoria
	seguirMovimientos:
	jmp ciclosMovimiento
endp

validaMapa proc near;rutina que valida el mapa de pango para jugar, revisa que esten los elementos necesarios en las cantidades necesarias
	cmp contadorDiamantes,3
	je DiamantesBien
	jmp errorMapa
	DiamantesBien:
	cmp contadorOso,1
	je OsoBien
	jmp errorMapa
	OsoBien:
	xor ax,ax
	cicloEncontrarOsoValida:
	call obtenerCosaEnMatriz
	cmp dl,'Q'
	je validarOso
	inc ah
	cmp ah,80
	jne soloSaltoValidaOso
	mov ah,0
	inc al
	soloSaltoValidaOso:
	jmp cicloEncontrarOsoValida
	validarOso:
	cmp ah,3
	jb errorMapa
	cmp al,24
	je errorMapa
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne errorMapa
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne errorMapa
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne errorMapa
	inc al
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne errorMapa
	inc ah
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne errorMapa
	inc ah
	call obtenerCosaEnMatriz
	cmp dl,' '
	jne errorMapa
	cmp contadorPango,1
	je pangoBien
	jmp errorMapa
	pangoBien:
	xor ax,ax
	call obtenerCosaEnMatriz
	cmp dl,'X'
	je errorMapa
	mov ah,79
	call obtenerCosaEnMatriz
	cmp dl,'X'
	je errorMapa
	mov al,24
	call obtenerCosaEnMatriz
	cmp dl,'X'
	je errorMapa
	mov ah,0
	call obtenerCosaEnMatriz
	cmp dl,'X'
	je errorMapa
	ret
	errorMapa:
	xor si,si
	xor di,di
	mov cx, 2000
	mov dh, 01011111b
	cicloDespValida:
	mov dl,invalidoRot[di]
	inc di
	mov word ptr es:[si], dx
	inc si
	inc si
	loop cicloDespValida
	esperarTeclaValida:
	mov ah,0
	int 16h
	cmp al,27
	jne noSalirValida
	mov ax,4C00h
	int 21h
	noSalirValida:
	cmp al,13
	jne esperarTeclaValida
	pop ax
	pop ax
	mov bx, handleArchPango
	mov ah, 3eh
	int 21h
	call jugarPango
endp

patearCubo proc near; rutina que patea los cubos de hielo de teresa
	cmp movimiento,0
	jne pateoCont1
	ret
	pateoCont1:
	cmp movimiento,1
	jne pateoCont2
	mov al, filaPango
	mov ah, columnaPango
	cmp ah,78
	ja noPateoDer
	inc ah
	call obtenerCosaEnMatriz
	cmp dl,'X'
	jne noDiamante1
	mov dh,1111b
	mov dl,'A'
	call ponerEnMatriz
	jmp noPateoDer
	noDiamante1:
	cmp dl,'0'
	jne noPateoDer
	mov colorSave,dh
	inc ah
	cmp ah,80
	je poner1
	call obtenerCosaEnMatriz
	cmp dl,' '
	je poner1
	cmp dl,'Q'
	jne noCabeza1
	add ciclosOsete,10
	noCabeza1:
	cmp dl,'W'
	jne noCuer1
	add ciclosOsete,10
	noCuer1:
	cmp dl,'L'
	jne noPata1
	add ciclosOsete,10
	noPata1:
	cmp dl,'o'
	jne noBolas1
	add ciclosOsete,10
	noBolas1:
	dec ah
	mov dl, ' '
	call ponerEnMatriz
	jmp noPateoDer
	poner1:
	dec ah
	mov dh,colorSave
	mov dl, '1'
	call ponerEnMatriz
	noPateoDer:
	ret
	pateoCont2:
	cmp movimiento,2
	jne pateoCont3
	mov al, filaPango
	mov ah, columnaPango
	cmp al,24
	ja noPateoDow
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'X'
	jne noDiamante2
	mov dh,1111b
	mov dl,'B'
	call ponerEnMatriz
	jmp noPateoDer
	noDiamante2:
	cmp dl,'0'
	jne noPateoDow
	mov colorSave,dh
	inc al
	cmp al,25
	je poner2
	call obtenerCosaEnMatriz
	cmp dl,' '
	je poner2
	cmp dl,'Q'
	jne noCabeza2
	add ciclosOsete,10
	noCabeza2:
	cmp dl,'W'
	jne noCuer2
	add ciclosOsete,10
	noCuer2:
	cmp dl,'L'
	jne noPata2
	add ciclosOsete,10
	noPata2:
	cmp dl,'o'
	jne noBolas2
	add ciclosOsete,10
	noBolas2:
	mov dl, ' '
	dec al
	call ponerEnMatriz
	jmp noPateoDer
	poner2:
	dec al
	mov al, filaPango
	mov ah, columnaPango
	inc al
	mov dh,colorSave
	mov dl, '2'
	call ponerEnMatriz
	noPateoDow:
	ret
	pateoCont3:
	cmp movimiento,3
	jne pateoCont4
	mov al, filaPango
	mov ah, columnaPango
	cmp ah,0
	je noPateoLef
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'X'
	jne noDiamante3
	mov dh,1111b
	mov dl,'C'
	call ponerEnMatriz
	jmp noPateoDer
	noDiamante3:
	cmp dl,'0'
	jne noPateoLef
	mov colorSave,dh
	dec ah
	cmp ah,255
	je poner3
	call obtenerCosaEnMatriz
	cmp dl,' '
	je poner3
	cmp dl,'Q'
	jne noCabeza3
	add ciclosOsete,10
	noCabeza3:
	cmp dl,'W'
	jne noCuer3
	add ciclosOsete,10
	noCuer3:
	cmp dl,'L'
	jne noPata3
	add ciclosOsete,10
	noPata3:
	cmp dl,'o'
	jne noBolas3
	add ciclosOsete,10
	noBolas3:
	mov dl, ' '
	inc ah
	call ponerEnMatriz
	jmp noPateoLef
	poner3:
	inc ah
	mov dh,colorSave
	mov dl, '3'
	call ponerEnMatriz
	noPateoLef:
	ret
	pateoCont4:
	cmp movimiento,4
	jne noPateoUp
	mov al, filaPango
	mov ah, columnaPango
	cmp al,0
	je noPateoUp
	dec al
	call obtenerCosaEnMatriz
	cmp dl,'X'
	jne noDiamante4
	mov dh,1111b
	mov dl,'D'
	call ponerEnMatriz
	jmp noPateoDer
	noDiamante4:
	cmp dl,'0'
	jne noPateoUp
	mov colorSave,dh
	dec al
	cmp al,255
	je poner4
	call obtenerCosaEnMatriz
	cmp dl,' '
	je poner4
	cmp dl,'Q'
	jne noCabeza4
	add ciclosOsete,10
	noCabeza4:
	cmp dl,'W'
	jne noCuer4
	add ciclosOsete,10
	noCuer4:
	cmp dl,'L'
	jne noPata4
	add ciclosOsete,10
	noPata4:
	cmp dl,'o'
	jne noBolas4
	add ciclosOsete,10
	noBolas4:
	mov dl, ' '
	inc al
	call ponerEnMatriz
	jmp noPateoLef
	poner4:
	inc al
	mov dh,colorSave
	mov dl, '4'
	call ponerEnMatriz
	noPateoUp:
	ret
endp


moverDow proc near;rutina que mueve los cubos y diamantes hacia abajo
	xor ax,ax
	mov al,24
	mov ah,79
	cicloMueveBloquesDow:
	call obtenerCosaEnMatriz
	mov colorSave,dh
	mov asciiSave,dl
	cmp dl,'B'
	je noAumentarDow
	cmp dl,'2'
	je noAumentarDow
	jmp aumentarYSeguirDow
	noAumentarDow:
	cmp al,24
	jne noUltFilaDow
	cmp asciiSave,'B'
	jne NoFinDow
	call derrota
	NoFinDow:
	mov dl,' '
	call ponerEnMatriz
	jmp aumentarYSeguirDow
	noUltFilaDow:
	inc al
	call obtenerCosaEnMatriz
	dec al
	cmp dl,'&'
	jne noMuereTeresaDow
	call derrota
	noMuereTeresaDow:
	cmp dl,' '
	jne destruirDow
	call ponerEnMatriz
	inc al
	mov dh,colorSave
	mov dl,asciiSave
	call ponerEnMatriz
	dec al 
	jmp aumentarYSeguirDow
	destruirDow:
	cmp dl,'Q'
	jne noCabezaDow
	add ciclosOsete,10
	noCabezaDow:
	cmp dl,'W'
	jne noCuerDow
	add ciclosOsete,10
	noCuerDow:
	cmp dl,'L'
	jne noPataDow
	add ciclosOsete,10
	noPataDow:
	cmp dl,'o'
	jne noBolasDow
	add ciclosOsete,10
	noBolasDow:
	cmp	asciiSave,'B'
	je ponerXB
	mov dh, colorSave
	mov dl,'0'
	call ponerEnMatriz
	jmp aumentarYSeguirDow
	ponerXB:
	mov dh, 1111b
	mov dl,'X'
	call ponerEnMatriz
	aumentarYSeguirDow:
	dec ah
	cmp ah,255
	jne noOFDow
	dec al
	mov ah,79
	noOFDow:
	cmp al,255
	je terminarMoverDow
	jmp cicloMueveBloquesDow
	terminarMoverDow:
	ret
endp

moverLef proc near;rutina que mueve los cubos y diamantes hacia la izquierda
	xor ax,ax
	cicloMueveBloquesLef:
	call obtenerCosaEnMatriz
	mov colorSave,dh
	mov asciiSave,dl
	cmp dl,'C'
	je noAumentarLef
	cmp dl,'3'
	je noAumentarLef 
	jmp aumentarYSeguirLef
	noAumentarLef:
	cmp ah,0
	jne noColumLef
	cmp asciiSave,'C'
	jne NoFinLef
	call derrota
	NoFinLef:
	mov dl,' '
	call ponerEnMatriz
	jmp aumentarYSeguirLef
	noColumLef:
	dec ah
	call obtenerCosaEnMatriz
	inc ah
	cmp dl,'&'
	jne noMuereTeresaLef
	call derrota
	noMuereTeresaLef:
	cmp dl,' '
	jne destruirLef
	call ponerEnMatriz
	dec ah
	mov dh,colorSave
	mov dl,asciiSave
	call ponerEnMatriz
	jmp aumentarYSeguirLef
	destruirLef:
	cmp dl,'Q'
	jne noCabezaLef
	add ciclosOsete,10
	noCabezaLef:
	cmp dl,'W'
	jne noCuerLef
	add ciclosOsete,10
	noCuerLef:
	cmp dl,'L'
	jne noPataLef
	add ciclosOsete,10
	noPataLef:
	cmp dl,'o'
	jne noBolasLef
	add ciclosOsete,10
	noBolasLef:
	cmp asciiSave,'C'
	je ponerXC
	mov dh, colorSave
	mov dl,'0'
	call ponerEnMatriz
	jmp aumentarYSeguirLef
	ponerXC:
	mov dh, 1111b
	mov dl,'X'
	call ponerEnMatriz
	aumentarYSeguirLef:
	inc ah
	cmp ah,80
	jne noOFLef
	inc al
	mov ah,0
	noOFLef:
	cmp al,25
	je terminarMoverLef
	jmp cicloMueveBloquesLef
	terminarMoverLef:
	ret
endp

moverRig proc near;rutina que mueve los cubos y diamantes hacia la derecha
	xor ax,ax
	mov ah, 79
	cicloMueveBloquesRig:
	call obtenerCosaEnMatriz
	mov colorSave,dh
	mov asciiSave,dl
	cmp dl,'A'
	je noAumentarRig
	cmp dl,'1'
	je noAumentarRig 
	jmp aumentarYSeguirRig
	noAumentarRig:
	cmp ah,79
	jne noColumRig
	cmp asciiSave,'A'
	jne NoFinRig
	call derrota
	NoFinRig:
	mov dl,' '
	call ponerEnMatriz
	jmp aumentarYSeguirRig
	noColumRig:
	inc ah
	call obtenerCosaEnMatriz
	dec ah
	cmp dl,'&'
	jne noMuereTeresaRig
	call derrota
	noMuereTeresaRig:
	cmp dl,' '
	jne destruirRig
	call ponerEnMatriz
	inc ah
	mov dh,colorSave
	mov dl,asciiSave
	call ponerEnMatriz
	jmp aumentarYSeguirRig
	destruirRig:
	cmp dl,'Q'
	jne noCabezaRig
	add ciclosOsete,10
	noCabezaRig:
	cmp dl,'W'
	jne noCuerRig
	add ciclosOsete,10
	noCuerRig:
	cmp dl,'L'
	jne noPataRig
	add ciclosOsete,10
	noPataRig:
	cmp dl,'o'
	jne noBolasRig
	add ciclosOsete,10
	noBolasRig:
	cmp asciiSave,'A'
	je ponerXA
	mov dh, colorSave
	mov dl,'0'
	call ponerEnMatriz
	jmp aumentarYSeguirRig
	ponerXA:
	mov dh, 1111b
	mov dl,'X'
	call ponerEnMatriz
	aumentarYSeguirRig:
	dec ah
	cmp ah,255
	jne noOFRig
	inc al
	mov ah,79
	noOFRig:
	cmp al,25
	je terminarMoverRig
	jmp cicloMueveBloquesRig
	terminarMoverRig:
	ret
endp

moverUp proc near;rutina que mueve los cubos y diamantes hacia arriba
	xor ax,ax
	cicloMueveBloquesUp:
	call obtenerCosaEnMatriz
	mov colorSave,dh
	mov asciiSave,dl
	cmp dl,'D'
	je noAumentarUp
	cmp dl,'4'
	jne aumentarYSeguirUp
	noAumentarUp:
	cmp al,0
	jne noFilaUp
	cmp asciiSave,'D'
	jne NoFinUP
	call derrota
	NoFinUp:
	mov dl,' '
	call ponerEnMatriz
	jmp aumentarYSeguirRig
	noFilaUp:
	dec al
	call obtenerCosaEnMatriz
	inc al
	cmp dl,'&'
	jne noMuereTeresaUp
	call derrota
	noMuereTeresaUp:
	cmp dl,' '
	jne destruirUp
	call ponerEnMatriz
	dec al
	mov dh, colorSave
	mov dl, asciiSave
	call ponerEnMatriz
	jmp aumentarYSeguirUp
	destruirUp:
	cmp dl,'Q'
	jne noCabezaUp
	add ciclosOsete,10
	noCabezaUp:
	cmp dl,'W'
	jne noCuerUp
	add ciclosOsete,10
	noCuerUp:
	cmp dl,'L'
	jne noPataUp
	add ciclosOsete,10
	noPataUp:
	cmp dl,'o'
	jne noBolasUp
	add ciclosOsete,10
	noBolasUp:
	cmp asciiSave,'D'
	je ponerXD
	mov dh, colorSave
	mov dl,'0'
	call ponerEnMatriz
	jmp aumentarYSeguirUp
	ponerXD:
	mov dh, 1111b
	mov dl,'X'
	call ponerEnMatriz
	aumentarYSeguirUp:
	inc ah
	cmp ah,80
	jne noOFUp
	inc al
	mov ah,0
	noOFUp:
	cmp al,25
	je terminarMoverUp
	jmp cicloMueveBloquesUp
	terminarMoverUp:
	ret
endp

verificarVictoriaHor proc near;rutina que revisa la matriz y verifica si ya se gano
	xor ax,ax
	cicloGanador:
	call obtenerCosaEnMatriz
	cmp dl,'X'
	jne noDiamanteVictoria
	inc contVictoria
	cmp contVictoria,3
	jne noHaGanado
	pop ax
	call victoria
	noDiamanteVictoria:
	mov contVictoria,0
	noHaGanado:
	inc ah
	cmp ah,80
	jne noCambioFila
	mov ah,0
	inc al
	mov contVictoria,0
	noCambioFila:
	cmp al,25
	jne seguirVictoria
	ret
	seguirVictoria:
	jmp cicloGanador
endp

verificarVictoriaVer proc near;rutina que revisa la matriz y verifica si ya se gano
	xor ax,ax
	cicloGanador2:
	call obtenerCosaEnMatriz
	cmp dl,'X'
	jne noDiamanteVictoria2
	inc contVictoria
	cmp contVictoria,3
	jne noHaGanado2
	pop ax
	call victoria
	noDiamanteVictoria2:
	mov contVictoria,0
	noHaGanado2:
	inc al
	cmp al,25
	jne noCambioColumna
	mov al,0
	inc ah
	mov contVictoria,0
	noCambioColumna:
	cmp ah,80
	jne seguirVictoria2
	ret
	seguirVictoria2:
	jmp cicloGanador2
endp

encontrarAPango proc near;rutina que devuelve la posicion actual de pango en la matriz, devuelve en el ah la columna y en el al la fila
	push bx
	push si
	xor si,si
	xor ax,ax
	cicloEncontrarAPango:
	mov bx,word ptr matrizPango[si]
	cmp bl,'&'
	jne noEsPango
	pop si
	pop bx
	ret
	noEsPango:
	inc si
	inc si
	inc ah
	cmp ah,80
	jb noFila
	inc al
	mov ah,0
	cmp al,25
	jb noFila
	call derrota
	noFila:
	jmp cicloEncontrarAPango
endp

ponerEnMatriz proc near; rutina que pone un elemento en la matriz de una coordenada, ah es la columna y al la fila, y y pone lo que esta en dx
	push ax
	push bx
	push di
	push dx
	mov bl,ah
	xor ah,ah
	mov bh,80
	mul bh
	xor bh,bh
	add ax,bx
	mov bx, 2
	mul bx
	mov di,ax
	pop dx
	mov word ptr matrizPango[di],dx
	pop di
	pop bx
	pop ax
	ret
endp

obtenerCosaEnMatriz proc near; rutina que obtiene el elemento en la matriz de una coordenada, ah es la columna y al la fila, y lo retorna en el dx
	push ax
	push bx
	push di
	mov bl,ah
	xor ah,ah
	mov bh,80
	mul bh
	xor bh,bh
	add ax,bx
	mov bx, 2
	mul bx
	mov di,ax
	mov dx, word ptr matrizPango[di]
	pop di
	pop bx
	pop ax
	ret
endp

derrota proc near; rutina que se llama cuando se pierde, depliega el mensaje de derrota y reinicia el juego
	mov contadorNivel,999
	xor si,si
	xor di,di
	mov cx, 2000
	mov dh, 01001111b
	cicloDespDerrota:
	mov dl,derrotaRot[di]
	inc di
	mov word ptr es:[si], dx
	inc si
	inc si
	loop cicloDespDerrota
	esperarTeclaDerrota:
	mov ah,0
	int 16h
	cmp al,27
	jne noSalirDerrota
	mov ax,4C00h
	int 21h
	noSalirDerrota:
	cmp al,13
	jne esperarTeclaDerrota
	pop ax
	pop ax
	mov bx, handleArchPango
	mov ah, 3eh
	int 21h
	call menuPango
endp

armarOso proc near; rutina que arma el Oso y define donde esta en la matriz
	xor ax,ax
	cicloArmarOso:
	call obtenerCosaEnMatriz
	cmp dl,'Q'
	jne noArmarOso
	mov columnaOso,ah
	mov filaOso,al
	mov dh,1111b
	mov dl,'W'
	dec ah
	call ponerEnMatriz
	dec ah 
	call ponerEnMatriz
	dec ah
	call ponerEnMatriz
	inc al 
	mov dl,'L'
	call ponerEnMatriz
	inc ah
	inc ah
	call ponerEnMatriz
	dec ah
	mov dl,'o'
	call ponerEnMatriz
	ret
	noArmarOso:
	inc ah
	cmp ah,80
	jne NoOverFlowOsito
	mov ah,0
	inc al
	NoOverFlowOsito:
	cmp al,25
	jne continuarBuscandoAlOso
	ret
	continuarBuscandoAlOso:
	jmp cicloArmarOso
endp

victoria proc near;rutina de victoria que pasa al siguiente nivel y despliega en la pantalla que se gano este nivel
	xor si,si
	xor di,di
	mov cx, 2000
	mov dh, 00111111b
	cicloDespVic:
	mov dl,victoriaRot[di]
	inc di
	mov word ptr es:[si], dx
	inc si
	inc si
	loop cicloDespVic
	esperarTeclaVic:
	mov ah,0
	int 16h
	cmp al,27
	jne noSalirVic
	mov ax,4C00h
	int 21h
	noSalirVic:
	cmp al,13
	jne esperarTeclaVic
	pop ax
	pop ax
	mov bx, handleArchPango
	mov ah, 3eh
	int 21h
	call jugarPango
endp

sigNivel proc near;rutina que pone en la variable del nivel de pango el ascii de los niveles, pone el siguiente nivel
	otraVez:
	mov camposRestantesMatriz,2000
	mov camposRestantesFila,80
	inc contadorNivel
	cmp contadorNivel,1000
	jne noEsElUltimoNivel
	mov contadorNivel,0
	noEsElUltimoNivel:
	push si
	mov ax, contadorNivel
	call ConvChar
	pop si
	mov al,0
	mov ah, 3dh
	mov cx, 0
	lea dx, nombreArchNivel
	int 21h; se crea el archivo de salida
	jc otraVez; no se encontro el nivel
	mov handleArchPango, ax
	call rellanarMatrizPango
	ret
endp

rellanarMatrizPango proc near; rutina que con el handle del archivo carga la matriz del archivo de pango
	xor di,di
	lecturaHielo:
	mov ah,3fh
	mov bx,handleArchPango
	mov cx,1
	lea dx,bufferPanguito
	int 21h
	cmp ax, 0; comparacion si se termino el archivo
	jne norellenarMatrizVacio
	jmp rellenarMatrizVacio
	norellenarMatrizVacio:
	mov bl, bufferPanguito
	cmp bl,10
	je lecturaHielo
	cmp bl, 13
	jne meterMatriz
	cmp camposRestantesFila,0
	jne meterVacio
	mov camposRestantesFila,80
	jmp lecturaHielo
	meterVacio:
	call FilaVacio
	mov camposRestantesFila,80
	cmp camposRestantesMatriz,0
	jne lecturaHielo
	jmp terminarMatriz
	meterMatriz:
	cmp camposRestantesFila,0
	je ignorarlinea
	cmp bl,'X'
	jne noXminuscula
	inc contadorDiamantes
	noXminuscula:
	cmp bl,'x'
	jne noXmayus
	mov bl,'X'
	inc contadorDiamantes
	noXmayus:
	cmp bl,'Q'
	jne noEsElOso
	inc contadorOso
	noEsElOso:
	cmp bl,'&'
	jne noEsPangoA
	inc contadorPango
	noEsPangoA:
	cmp bl,'0'
	jne noColor
	mov bh,color
	inc color
	cmp color,15
	ja reseteoColor
	jmp meterColor
	reseteoColor:
	mov color,1
	jmp meterColor
	noColor:
	mov bh,1111b
	meterColor:
	mov matrizPango[di],bx
	inc di
	inc di
	dec camposRestantesMatriz
	dec camposRestantesFila
	cmp camposRestantesMatriz,0
	ja verificarFila
	jmp terminarMatriz
	verificarFila:
	cmp camposRestantesFila,0
	jb nolecturaHielo
	jmp lecturaHielo
	nolecturaHielo:
	ignorarlinea:
	mov ah,3fh
	mov bx,handleArchPango
	mov cx,1
	lea dx,bufferPanguito
	int 21h
	cmp ax, 0; comparacion si se termino el archivo
	je rellenarMatrizVacio
	mov bl,bufferPanguito
	cmp bl,13
	jne ignorarlinea
	mov camposRestantesFila,80
	jmp lecturaHielo
	rellenarMatrizVacio:
	call matrizVacio
	terminarMatriz:
	ret
endp 

FilaVacio proc near; rutina que rellena una fila con espacios hasta que tenga los 80 espacios
	mov cx,camposRestantesFila
	mov bh,1111b
	mov bl,' '
	cicloFilaBlanco:
	mov matrizPango[di],bx
	inc di
	inc di
	dec camposRestantesFila
	dec camposRestantesMatriz
	loop cicloFilaBlanco
	ret
	
endp


desplegarMatriz proc near; rutina que despliega la matriz de pango a la pantalla
	mov ax, 0B800h
    mov es, ax
	xor si,si
	xor di,di
	mov cx,2000
	cicloDesp:
	mov ax, word ptr matrizPango[di]
	cmp al,'W'
	jne noEsW
	mov al,'0'
	noEsW:
	cmp al,'1'
	jne noEs1
	mov al,'0'
	noEs1:
	cmp al,'2'
	jne noEs2
	mov al,'0'
	noEs2:
	cmp al,'3'
	jne noEs3
	mov al,'0'
	noEs3:
	cmp al,'4'
	jne noEs4
	mov al,'0'
	noEs4:
	cmp al,'A'
	jne noEsA
	mov al,'X'
	noEsA:
	cmp al,'B'
	jne noEsB
	mov al,'X'
	noEsB:
	cmp al,'C'
	jne noEsC
	mov al,'X'
	noEsC:
	cmp al,'D'
	jne noEsD
	mov al,'X'
	noEsD:
	mov word ptr Es:[si], Ax
	inc si
	inc si
	inc di
	inc di
	loop cicloDesp
	ret
	
endp

matrizVacio proc near; rellena lo que falte de la matriz con espacios
	mov cx,camposRestantesMatriz
	mov bh,1111b
	mov bl,' '
	cicloMatrizBlanco:
	mov matrizPango[di],bx
	inc di
	inc di
	dec camposRestantesMatriz
	loop cicloMatrizBlanco
	ret

endp
moverOso proc near; rutina que decide a donde mover el oso y si se mueve llama a las rutinas de movimiento
	mov al, filaOso
	mov ah, filaPango
	cmp al,ah
	ja moverOsoArriba
	jb moverOsoAbajo
	jmp verColumna
	moverOsoArriba:
	mov al,filaOso
	mov ah,columnaOso
	dec al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale1
	cmp dl,' '
	je noverColumna
	jmp verColumna
	noverColumna:
	teresaVale1:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale2
	cmp dl,' '
	jne verColumna
	teresaVale2:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale3
	cmp dl,' '
	jne verColumna
	teresaVale3:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaValecomodin1
	cmp dl,' '
	jne verColumna
	teresaValecomodin1:
	call Osoarriba
	ret
	moverOsoAbajo:
	mov al, filaOso
	mov ah, filaPango
	inc al
	cmp al,ah
	je verColumna
	mov al,filaOso
	mov ah,columnaOso
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale4
	cmp dl,' '
	jne verColumna
	teresaVale4:
	inc al
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale5
	cmp dl,' '
	jne verColumna
	teresaVale5:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale6
	cmp dl,' '
	jne verColumna
	teresaVale6:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaValecomodin3
	cmp dl,' '
	jne verColumna
	teresaValecomodin3:
	call Osoaabajo
	ret
	verColumna:
	mov al, columnaOso
	mov ah, columnaPango
	cmp al,ah
	jbe moverOsoDerecha
	ja moverOsoIzquierda
	ret
	moverOsoDerecha:
	mov al,filaOso
	mov ah,columnaOso
	inc ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale7
	cmp dl,' '
	jne noSeMuevaOso
	teresaVale7:
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale8
	cmp dl,' '
	jne noSeMuevaOso
	teresaVale8:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaValecomodin2
	cmp dl,' '
	jne noSeMuevaOso
	teresaValecomodin2:
	call Osoderecha
	ret
	moverOsoIzquierda:
	mov al,columnaPango
	mov ah,columnaOso
	sub ah,3
	cmp al,ah
	jae noSeMuevaOso
	mov al,filaOso
	mov ah,columnaOso
	sub ah,3
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale9
	cmp dl,' '
	jne noSeMuevaOso
	teresaVale9:
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	je teresaVale10
	cmp dl,' '
	jne noSeMuevaOso
	teresaVale10:
	call Osoizquierda
	noSeMuevaOso:
	ret
endp

Osoizquierda proc near; mueve al oso hacia la izquierda
	mov ah,columnaOso
	mov al,filaOso
	sub ah,4
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverLef1
	call derrota
	soloMoverLef1:
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverLef2
	call derrota
	soloMoverLef2:
	mov dh,1111b
	mov dl,'L'
	call ponerEnMatriz
	inc ah
	mov dl,'o'
	call ponerEnMatriz
	inc ah
	mov dl,'L'
	call ponerEnMatriz
	inc ah
	mov dl,' '
	call ponerEnMatriz
	sub ah,3
	dec al
	mov dl,'W'
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	mov dl,'Q'
	call ponerEnMatriz
	inc ah
	mov dl,' '
	call ponerEnMatriz
	dec columnaOso
	ret
endp

Osoderecha proc near; mueve al oso hacia la derecha
	mov ah,columnaOso
	mov al,filaOso
	inc ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverRig1
	call derrota
	soloMoverRig1:
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverRig2
	call derrota
	soloMoverRig2:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverRig3
	call derrota
	soloMoverRig3:
	mov dh,1111b
	mov dl,'L'
	call ponerEnMatriz
	dec ah
	mov dl,'o'
	call ponerEnMatriz
	dec ah
	mov dl,'L'
	call ponerEnMatriz
	dec ah
	mov dl,' '
	call ponerEnMatriz
	dec al
	call ponerEnMatriz
	inc ah
	mov dl,'W'
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	mov dl,'Q'
	call ponerEnMatriz
	inc columnaOso
	ret
endp

Osoaabajo proc near ; mueve al oso hacia abajo
	mov ah,columnaOso
	mov al,filaOso
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverDow0
	call derrota
	soloMoverDow0:
	inc al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverDow1
	call derrota
	soloMoverDow1:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverDow2
	call derrota
	soloMoverDow2:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverDow3
	call derrota
	soloMoverDow3:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverDow4
	call derrota
	soloMoverDow4:
	dec al
	dec al
	mov dl,' '
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	sub ah,3
	inc al
	mov dh,1111b
	mov dl,'W'
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	mov dl,'Q'
	inc ah
	call ponerEnMatriz
	inc al
	dec ah
	mov dl,'L'
	call ponerEnMatriz
	dec ah
	dec ah
	call ponerEnMatriz
	inc ah
	mov dl,'o'
	call ponerEnMatriz
	inc filaOso
	ret
endp

Osoarriba proc near; mueve al oso hacia arriba
	mov ah,columnaOso
	mov al,filaOso
	dec al
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverUp1
	call derrota
	soloMoverUp1:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverUp2
	call derrota
	soloMoverUp2:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverUp3
	call derrota
	soloMoverUp3:
	dec ah
	call obtenerCosaEnMatriz
	cmp dl,'&'
	jne soloMoverUp4
	call derrota
	soloMoverUp4:
	mov dh,1111b
	mov dl,'W'
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	mov dl,'Q'
	inc ah
	call ponerEnMatriz
	mov dl,' '
	inc al
	call ponerEnMatriz
	dec ah
	mov dl,'L'
	call ponerEnMatriz
	dec ah
	dec ah
	call ponerEnMatriz
	inc ah
	mov dl,'o'
	call ponerEnMatriz
	dec ah
	inc al
	mov dl,' '
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	inc ah
	call ponerEnMatriz
	dec filaOso
	ret
endp

ConvChar Proc near;el numero empieza en ax, esta rutina convierte el numero en ax en un strin, y lo mete a la variable para imprimir
	xor si,si
	cmp ax,100
	jae normalConChar
	mov byte ptr nombreArchNivel[si],'0'
	inc si
	normalConChar:
	jmp ConvHexaProces
	vuelta:
	call charts
	mov byte ptr nombreArchNivel[si],bl
	inc si
	pop ax
	cmp ax,'+'
	jne vuelta
	ret
	ConvHexaProces:
		mov bx,'+'
		push bx
		xor bx, bx
		xor cx, cx
		xor dx, dx
		mov bl, 10
		inicioHexadecer:
		xor dx, dx
		Idiv bx
		push dx
		cmp ax, bx
		jae inicioHexadecer
		jmp vuelta
	endp
	
charts proc near; rutina que dependiendo del numero que haya en ax, metera en bx su correpondiente ascii (del 0 a la F)
	cmp ax,0
	je hex0
	cmp ax,1
	je hex1
	cmp ax,2
	je hex2
	cmp ax,3
	je hex3
	cmp ax,4
	je hex4
	cmp ax,5
	je hex5
	cmp ax,6
	je hex6
	cmp ax,7
	je hex7
	cmp ax,8
	je hex8
	cmp ax,9
	je hex9
	cmp ax,10
	je hexaA
	cmp ax,11
	je hexB
	cmp ax,12
	je hexC
	cmp ax,13
	je hexD
	cmp ax,14
	je hexE
	jmp hexF
	hex0: mov bx,'0'
	ret
	hex1: mov bx,'1'
	ret
	hex2: mov bx,'2'
	ret
	hex3: mov bx,'3'
	ret
	hex4: mov bx,'4'
	ret
	hex5: mov bx,'5'
	ret
	hex6: mov bx,'6'
	ret
	hex7: mov bx,'7'
	ret
	hex8: mov bx,'8'
	ret
	hex9: mov bx,'9'
	ret
	hexaA: mov bx,'A'
	ret
	hexB: mov bx,'B'
	ret
	hexC: mov bx,'C'
	ret
	hexD: mov bx,'D'
	ret
	hexE: mov bx,'E'
	ret
	hexF: mov bx,'F'
	ret
	ENDP


codigo ends
 end inicio