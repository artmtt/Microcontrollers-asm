;******************************************************
; Base Teclado Matricial
;
; Fecha: 29/09/2022
; Autor: Arturo
;******************************************************

.include "m16adef.inc"    
   
;******************************************************
;Registros (aqu� pueden definirse)
;.def temporal=r19

;Palabras claves (aqu� pueden definirse)
;.equ LCD_DAT=DDRC
;******************************************************

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

;******************************************************
;Aqu� comenzar� el programa
;******************************************************
Reset:
;Primero inicializamos el stack pointer...
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16

; Aqu� empieza la configuraci�n para teclado matricial
; Se usa el PUERTO A
ldi r16, 0b1111_0000; Los 4 bits m�s significativos son para la salida 
out DDRA, r16

TECLADO:
	ldi r16, 0xFF
	out PORTA, r16 ; Pull ups y todos 1

	cbi PORTA, 4 ; Poner 0 en A4
	nop
	nop
	; Revisar si hay un 0 en alg�n bot�n de la columna
	sbis PINA, 0
	rjmp A
	sbis PINA, 1
	rjmp B
	sbis PINA, 2
	rjmp C
	sbis PINA, 3
	rjmp D

	sbi PORTA, 4 ; Pone 1 en A4
	cbi PORTA, 5 ; Pone 0 en A5
	nop
	nop
	; Revisar si hay un 0 en alg�n bot�n de la columna
	sbis PINA, 0
	rjmp UNO
	sbis PINA, 1
	rjmp CUATRO
	sbis PINA, 2
	rjmp SIETE
	sbis PINA, 3
	rjmp E

	sbi PORTA, 5 ; Pone 1 en A5
	cbi PORTA, 6 ; Pone 0 en A6
	nop
	nop
	; Revisar si hay un 0 en alg�n bot�n de la columna
	sbis PINA, 0
	rjmp DOS
	sbis PINA, 1
	rjmp CINCO
	sbis PINA, 2
	rjmp OCHO
	sbis PINA, 3
	rjmp CERO

	sbi PORTA, 6 ; Pone 1 en A6
	cbi PORTA, 7 ; Pone 0 en A7
	nop
	nop
	; Revisar si hay un 0 en alg�n bot�n de la columna
	sbis PINA, 0
	rjmp TRES
	sbis PINA, 1
	rjmp SEIS
	sbis PINA, 2
	rjmp NUEVE
	sbis PINA, 3
	rjmp F

rjmp TECLADO


A:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_A:
		sbis PINA, 0
		rjmp TRABA_A
	rcall RETARDO_50m
rjmp TECLADO


B:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_B:
		sbis PINA, 1
		rjmp TRABA_B
	rcall RETARDO_50m
rjmp TECLADO


C:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_C:
		sbis PINA, 2
		rjmp TRABA_C
	rcall RETARDO_50m
rjmp TECLADO


D:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_D:
		sbis PINA, 3
		rjmp TRABA_D
	rcall RETARDO_50m
rjmp TECLADO


UNO:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_UNO:
		sbis PINA, 0
		rjmp TRABA_UNO
	rcall RETARDO_50m
rjmp TECLADO


CUATRO:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_CUATRO:
		sbis PINA, 1
		rjmp TRABA_CUATRO
	rcall RETARDO_50m
rjmp TECLADO


SIETE:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_SIETE:
		sbis PINA, 2
		rjmp TRABA_SIETE
	rcall RETARDO_50m
rjmp TECLADO


E:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_E:
		sbis PINA, 3
		rjmp TRABA_E
	rcall RETARDO_50m
rjmp TECLADO


DOS:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_DOS:
		sbis PINA, 0
		rjmp TRABA_DOS
	rcall RETARDO_50m
rjmp TECLADO


CINCO:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_CINCO:
		sbis PINA, 1
		rjmp TRABA_CINCO
	rcall RETARDO_50m
rjmp TECLADO


OCHO:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_OCHO:
		sbis PINA, 2
		rjmp TRABA_OCHO
	rcall RETARDO_50m
rjmp TECLADO


CERO:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_CERO:
		sbis PINA, 3
		rjmp TRABA_CERO
	rcall RETARDO_50m
rjmp TECLADO


TRES:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_TRES:
		sbis PINA, 0
		rjmp TRABA_TRES
	rcall RETARDO_50m
rjmp TECLADO


SEIS:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_SEIS:
		sbis PINA, 1
		rjmp TRABA_SEIS
	rcall RETARDO_50m
rjmp TECLADO


NUEVE:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_NUEVE:
		sbis PINA, 2
		rjmp TRABA_NUEVE
	rcall RETARDO_50m
rjmp TECLADO


F:
	// Aqu� va el c�digo de lo que se quiere hacer cuando est� presionado
	rcall RETARDO_50m
	TRABA_F:
		sbis PINA, 3
		rjmp TRABA_F
	rcall RETARDO_50m
rjmp TECLADO

; --------------------------------------------------------

RETARDO_50m:
; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R29, $65
WGLOOP0:  ldi  R30, $A4
WGLOOP1:  dec  R30
          brne WGLOOP1
          dec  R29
          brne WGLOOP0
; ----------------------------- 
; delaying 3 cycles:
          ldi  R29, $01
WGLOOP2:  dec  R29
          brne WGLOOP2
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; =============================
ret

;---------------------------------------------------------

;******************************************************
;No olvides configurar al inicio los puertos que utilizar�s
;Tambi�n debes configurar si habr� o no pull ups en las entradas
;Para las salidas deber�s indicar cu�l es la salida inicial
;Los registros que vayas a utilizar inicializalos si es necesario
;******************************************************






;******************************************************
;Aqu� est�n las rutinas para el manejo de las interrupciones concretas
;******************************************************
EXT_INT0: ; IRQ0 Handler
reti
EXT_INT1:
reti ; IRQ1 Handler
TIM2_COMP:
reti ; Timer2 Compare Handler
TIM2_OVF:
reti ; Timer2 Overflow Handler
TIM1_CAPT:
reti ; Timer1 Capture Handler
TIM1_COMPA:
reti ; Timer1 CompareA Handler
TIM1_COMPB:
reti ; Timer1 CompareB Handler
TIM1_OVF:
reti ; Timer1 Overflow Handler
TIM0_OVF:
reti ; Timer0 Overflow Handler
SPI_STC:
reti ; SPI Transfer Complete Handler
USART_RXC:
reti ; USART RX Complete Handler
USART_UDRE:
reti ; UDR Empty Handler
USART_TXC:
reti ; USART TX Complete Handler
ADC_COMP:
reti ; ADC Conversion Complete Handler
EE_RDY:
reti ; EEPROM Ready Handler
ANA_COMP:
reti ; Analog Comparator Handler
TWSI:
reti ; Two-wire Serial Interface Handler
EXT_INT2:
reti ; IRQ2 Handler
TIM0_COMP:
reti
SPM_RDY:
reti ; Store Program Memory Ready Handler