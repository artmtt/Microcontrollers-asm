.include "m16adef.inc"     
   
;******************
;Registros (aquí pueden definirse)
;.def temporal=r19

;Palabras claves (aquí pueden definirse)
;.equ LCD_DAT=DDRC
;******************

.org 0x0000
;Comienza el vector de interrupciones.
jmp RESET ; Reset Handler
jmp EXT_INT0 ; IRQ0 Handler
jmp EXT_INT1 ; IRQ1 Handler
jmp TIM2_COMP ; Timer2 Compare Handler
jmp TIM2_OVF ; Timer2 Overflow Handler
jmp TIM1_CAPT ; Timer1 Capture Handler
jmp TIM1_COMPA ; Timer1 CompareA Handler
jmp TIM1_COMPB ; Timer1 CompareB Handler
jmp TIM1_OVF ; Timer1 Overflow Handler
jmp TIM0_OVF ; Timer0 Overflow Handler
jmp SPI_STC ; SPI Transfer Complete Handler
jmp USART_RXC ; USART RX Complete Handler
jmp USART_UDRE ; UDR Empty Handler
jmp USART_TXC ; USART TX Complete Handler
jmp ADC_COMP ; ADC Conversion Complete Handler
jmp EE_RDY ; EEPROM Ready Handler
jmp ANA_COMP ; Analog Comparator Handler
jmp TWSI ; Two-wire Serial Interface Handler
jmp EXT_INT2 ; IRQ2 Handler
jmp TIM0_COMP ; Timer0 Compare Handler
jmp SPM_RDY ; Store Program Memory Ready Handler
; Termina el vector de interrupciones.

;******************
;Aquí comenzará el programa
;******************
Reset:
;Primero inicializamos el stack pointer...
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16 

;******************
;No olvides configurar al inicio los puertos que utilizarás
;También debes configurar si habrá o no pull ups en las entradas
;Para las salidas deberás indicar cuál es la salida inicial
;Los registros que vayas a utilizar inicializalos si es necesario
;******************

ldi r16, 0xFF
out PORTA, r16
clr r16

RCALL INI_LCD

CLR R20
CLR R21		//Checa cuanto caracteres llevo mostrados; 2#, operacion, 2# 

ldi R22, 1 // Contador dig de primos

RCALL ESCRIBE_inicio

MAIN:
	sbis PINA, 0
	rjmp Button_pressed
rjmp MAIN

Button_pressed:
	LDI VAR, 0B0000_0001
	RCALL WR_INS
	rcall ESCRIBE_msj_primes

	LDI VAR, 0B11001110
	RCALL WR_INS
	rcall ESCRIBE_Primes

	LDI VAR, 0B11001101
	RCALL WR_INS
	rcall ESCRIBE_msj_fin
	rcall delay1s

	LDI VAR, 0B0000_0001
	RCALL WR_INS
	rcall ESCRIBE_inicio

	rcall RETARDO_50m
	TRABA_1:
		sbis PINA, 0
		rjmp TRABA_1
	rcall RETARDO_50m
rjmp MAIN

ESCRIBE_inicio:
	LDI ZH, HIGH(MSJ_inicio*2)
	LDI ZL, LOW (MSJ_inicio*2)
	ADD ZL, R20
	ADC ZH, R21
	LPM						//En R0 se encuentra el dato
	MOV VAR, R0				//Muestrar e la LCD
	CPI VAR, '#'
	BREQ EXIT_ESCRIBE_inicio
	RCALL WR_DAT
	INC R20
	RJMP ESCRIBE_inicio
EXIT_ESCRIBE_inicio:
	CLR R20
	CLR R21
RET

ESCRIBE_msj_primes:
	LDI ZH, HIGH(MSJ_primes*2)
	LDI ZL, LOW (MSJ_primes*2)
	ADD ZL, R20
	ADC ZH, R21
	LPM						//En R0 se encuentra el dato
	MOV VAR, R0				//Muestrar e la LCD
	CPI VAR, '#'
	BREQ Exit_ESCRIBE_msj_primes
	RCALL WR_DAT
	INC R20
	RJMP ESCRIBE_msj_primes
Exit_ESCRIBE_msj_primes:
	CLR R20
	CLR R21
RET

Delay_prime:
	ldi r22, 0
	rcall delay1s
	ldi VAR, 0B11001110
	rcall WR_INS
rjmp Cont_ESCRIBE_Primes

ESCRIBE_Primes:
	LDI ZH, HIGH(Primes*2)
	LDI ZL, LOW (Primes*2)
	ADD ZL, R20
	ADC ZH, R21
	LPM						//En R0 se encuentra el dato
	MOV VAR, R0				//Muestrar e la LCD
	CPI VAR, '#'
	BREQ Exit_ESCRIBE_Primes
	RCALL WR_DAT
	cpi R22, 2
	breq Delay_prime
Cont_ESCRIBE_Primes:
	INC R20
	INC R22
	RJMP ESCRIBE_Primes
Exit_ESCRIBE_Primes:
	CLR R20
	CLR R21
RET

ESCRIBE_msj_fin:
	LDI ZH, HIGH(MSJ_fin*2)
	LDI ZL, LOW (MSJ_fin*2)
	ADD ZL, R20
	ADC ZH, R21
	LPM						//En R0 se encuentra el dato
	MOV VAR, R0				//Muestrar e la LCD
	CPI VAR, '#'
	BREQ Exit_ESCRIBE_msj_fin
	RCALL WR_DAT
	INC R20
	RJMP ESCRIBE_msj_fin
Exit_ESCRIBE_msj_fin:
	CLR R20
	CLR R21
RET


Retardo_50m:
; ============================= 
;    delay loop generator 
;     400000 cycles:
; ----------------------------- 
; delaying 399999 cycles:
          ldi  R29, $97
WGLOOP0_0:  ldi  R30, $06
WGLOOP1_0:  ldi  R31, $92
WGLOOP2_0:  dec  R31
          brne WGLOOP2_0
          dec  R30
          brne WGLOOP1_0
          dec  R29
          brne WGLOOP0_0
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 
ret


;******************
;Aquí están las rutinas para el manejo de las interrupciones concretas
;******************
EXT_INT0: ; IRQ0 Handler
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti
EXT_INT1: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; IRQ1 Handler
TIM2_COMP: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Timer2 Compare Handler
TIM2_OVF: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Timer2 Overflow Handler
TIM1_CAPT: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Timer1 Capture Handler
TIM1_COMPA: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Timer1 CompareA Handler
TIM1_COMPB: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Timer1 CompareB Handler
TIM1_OVF: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Timer1 Overflow Handler
TIM0_OVF: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Timer0 Overflow Handler
SPI_STC: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; SPI Transfer Complete Handler
USART_RXC: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; USART RX Complete Handler
USART_UDRE: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; UDR Empty Handler
USART_TXC: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; USART TX Complete Handler
ADC_COMP: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; ADC Conversion Complete Handler
EE_RDY: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; EEPROM Ready Handler
ANA_COMP: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Analog Comparator Handler
TWSI: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Two-wire Serial Interface Handler
EXT_INT2: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; IRQ2 Handler
TIM0_COMP: 
	in R16, SREG
	push R16

	INC R27

	pop R16
	out SREG, R16
reti
SPM_RDY: 
	in R16, SREG
	push R16

	pop R16
	out SREG, R16
reti ; Store Program Memory Ready Handler



;**********************************************************************************************
;ESTA LIBRERA SE UTILIZA PARA EL LCD
;Esta libreria funciona a una frecuencia de 8Mhz
;FUNCIONES:
;   - INI_LCD sirve para inicializar el LCD
;   - WR_INS para escribir una instruccion en el LCD.  Antes debe de cargarse en VAR la instrucción a escribir
;   - WR_DAT para escribir un dato en el LCD.  Antes debe de cargarse en VAR el dato a escribir
;REGISTROS
;   - Se emplea el registro R16, R17 y R18
;PUERTOS
;   - Se emplea el puerto D (pines 5 6 y 7 para RS, RW y E respectivamente)
;   - Se emplea el puerto C para la conexión a D0..D7
;   - Estos puertos pueden modificarse en la definición de variables
;************************************************************************************************************************
;Definición de variables
.def VAR3 = r20
.def VAR2=r19
.def VAR= r16
.equ DDR_DAT=DDRC
.equ PORT_DAT=PORTC
.equ PIN_DAT=PINC
.equ DDR_CTR=DDRD 
.equ PORT_CTR=PORTD
.equ PIN_RS=5
.equ PIN_RW=6
.equ PIN_E=7

;************************************************************************************************************************
INI_LCD:	
	rcall DECLARA_PUERTOS
    rcall T0_15m			 
	ldi VAR,0b00111000		;Function Set - Inicializa el LCD
	rcall WR_INS_INI		
	rcall T0_4m1
	ldi VAR,0b00111000		;Function Set - Inicializa elLCD
	rcall WR_INS_INI		
	rcall T0_100u			
	ldi VAR,0b00111000		;Function Set - Inicializa elLCD
	rcall WR_INS_INI		
	rcall T0_100u			
	ldi VAR,0b00111000		;Function Set - Define 2 líneas, 5x8 char font
	rcall WR_INS_INI		
	rcall T0_100u
	ldi VAR, 0b00001000		;Apaga el display
	rcall WR_INS
	ldi VAR, 0b00000001		;Limpia el display
    rcall WR_INS
	//*******************************************************************************************************************
	//---------------------------------------------CONTROL DE MODO --------------------------------------------------
	//MODO INCREMENTO SIN SHIFT
	ldi VAR, 0b00000110		;Entry Mode Set - Display clear, increment, without display shift
	rcall WR_INS	
	//MODO DECREMENTO SIN SHIFT
	//ldi VAR, 0b00000100		;Entry Mode Set - Display clear, increment, without display shift
	//rcall WR_INS
	//MODO INCREMENTO CON SHIFT
	//ldi VAR, 0b00000111		;Entry Mode Set - Display clear, increment, display shift
	//rcall WR_INS
	//MODO DECREMENTO CON SHIFT
	//ldi VAR, 0b00000101		;Entry Mode Set - Display clear, increment, display shift
	//rcall WR_INS
	//*******************************************************************************************************************	
	ldi VAR, 0b00001100		;Enciende el display
    rcall WR_INS		
	//*******************************************************************************************************************
	//---------------------------------------------CONTROL DE POSICIÓN --------------------------------------------------
	//PARA INCREMENTO SIN SHIFT
	ldi VAR, 0b1000_0000
	rcall WR_INS
	//PARA DECREMENTO SIN SHIFT
	//ldi VAR, 0b1000_1111
	//rcall WR_INS
	//PARA INCREMENTO CON SHIFT
	//ldi VAR, 0b1000_0100
	//rcall WR_INS
	//PARA DECREMENTO CON SHIFT
	//ldi VAR, 0b1010_0111
	//rcall WR_INS
	//*******************************************************************************************************************
ret
;************************************************************************************************************************
WR_INS: 
	rcall WR_INS_INI
	rcall CHK_FLG			;Espera hasta que la bandera del LCD responde que ya terminó
ret
;************************************************************************************************************************
WR_DAT:			
	out PORT_DAT,VAR 
	sbi PORT_CTR,PIN_RS		;Modo datos
	cbi PORT_CTR,PIN_RW		;Modo escritura
	sbi PORT_CTR,PIN_E		;Habilita E
	rcall T0_10m
	cbi PORT_CTR,PIN_E		;Quita E, regresa a modo normal
	rcall CHK_FLG			;Espera hasta que la bandera del LCD indica que terminó
ret
;************************************************************************************************************************
WR_INS_INI: 
	out PORT_DAT,VAR 
	cbi PORT_CTR,PIN_RS		;Modo instrucciones
	cbi PORT_CTR,PIN_RW		;Modo escritura
   	sbi PORT_CTR,PIN_E		;Habilita E
	rcall T0_10m			
	cbi PORT_CTR,PIN_E		;Quita E, regresa a modo normal
ret
;************************************************************************************************************************
DECLARA_PUERTOS:
	ldi VAR, 0xFF
	out DDR_DAT, VAR		; El puerto donde están conectados D0..D7 se habilita como salida
	out DDR_CTR, VAR		; Todo el puerto en donde estén conectados RS,RW y E se habilita como salida
ret	
;************************************************************************************************************************
CHK_FLG: 
	ldi VAR, 0x00		
	out DDR_DAT, VAR		;Establece el puerto de datos como entrada para poder leer la bandera
	cbi PORT_CTR, PIN_RS		;Modo instrucciones
	sbi PORT_CTR, PIN_RW		;Modo lectura
	RBF:
		sbi PORT_CTR, PIN_E 	;Habilita E
		rcall T0_10m
		cbi PORT_CTR, PIN_E	;Quita E, regresa a modo normal
	   	sbic PIN_DAT, 7		
		;****************************************************! sbis o sbic cambian según se trate de la vida real (C) o de poteus (S)
	   	rjmp RBF		;Repite el ciclo hasta que la bandera de ocupado(pin7)=1
	CONTINUA:	
	cbi PORT_CTR, PIN_RS		;Limpia RS
	cbi PORT_CTR, PIN_RW		;Limpia RW
		
 	ldi VAR, 0xFF   	
	out DDR_DAT, VAR		;Regresa el puerto de datos a su configuración como puerto de salida
ret
;************************************************************************************************************************
T0_15m:
; ============================= 
;    delay loop generator 
;     120000 cycles:
; ----------------------------- 
; delaying 119997 cycles:
			ldi  R17, $C7
WGLOOP0a:	ldi  R18, $C8
WGLOOP1a:	dec  R18
			brne WGLOOP1a
			dec  R17
			brne WGLOOP0a
; ----------------------------- 
; delaying 3 cycles:
			ldi  R17, $01
WGLOOP2a:	dec  R17
			brne WGLOOP2a
; =============================
ret
;************************************************************************************************************************
T0_10m:
; ============================= 
;    delay loop generator 
;     80000 cycles:
; ----------------------------- 
; delaying 79998 cycles:
			ldi  R17, $86
WGLOOP0b:	ldi  R18, $C6
WGLOOP1b:	dec  R18
			brne WGLOOP1b
			dec  R17
			brne WGLOOP0b
; ----------------------------- 
; delaying 2 cycles:
			nop
			nop
; ============================= 
ret
;************************************************************************************************************************
T0_100u:
; ============================= 
;    delay loop generator 
;     800 cycles:
; ----------------------------- 
; delaying 798 cycles:
			ldi  R17, $02
WGLOOP0c:	ldi  R18, $84
WGLOOP1c:	dec  R18
			brne WGLOOP1c
			dec  R17
			brne WGLOOP0c
; ----------------------------- 
; delaying 2 cycles:
			nop
			nop
; ============================= 
ret
;************************************************************************************************************************
T0_4m1:
; ============================= 
;    delay loop generator 
;     32800 cycles:
; ----------------------------- 
; delaying 32781 cycles:
			ldi  R17, $31
WGLOOP0d:	ldi  R18, $DE
WGLOOP1d:	dec  R18
			brne WGLOOP1d
			dec  R17
			brne WGLOOP0d
; ----------------------------- 
; delaying 18 cycles:
			ldi  R17, $06
WGLOOP2d:	dec  R17
			brne WGLOOP2d
; ----------------------------- 
; delaying 1 cycle:
			nop
; ============================= 
ret

delay1s:
; ============================= 
;    delay loop generator 
;     8000000 cycles:
; ----------------------------- 
; delaying 7999992 cycles:
		  ldi  R17, $48
WGLOOP0:  ldi  R18, $BC
WGLOOP1:  ldi  R19, $C4
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 6 cycles:
          ldi  R17, $02
WGLOOP3:  dec  R17
          brne WGLOOP3
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 
ret


MSJ_Inicio:
.db "En espera#"

MSJ_primes:
.db "Numeros primos##"

MSJ_fin:
.db "Fin#"

Primes:
.db "02030507111317192329313741434753596167717379838997##"