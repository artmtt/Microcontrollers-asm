;******************************************************
; Practica 13
;
; Fecha: 
; Autor: Art
;******************************************************

.include "m16adef.inc"    
   
;******************************************************
;Registros (aquí pueden definirse)
;.def temporal=r19

;Palabras claves (aquí pueden definirse)
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
;Aquí comenzará el programa
;******************************************************
Reset:
;Primero inicializamos el stack pointer...
ldi r16, high(RAMEND)
out SPH, r16
ldi r16, low(RAMEND)
out SPL, r16


;******************************************************
;No olvides configurar al inicio los puertos que utilizarás
;También debes configurar si habrá o no pull ups en las entradas
;Para las salidas deberás indicar cuál es la salida inicial
;Los registros que vayas a utilizar inicializalos si es necesario
;******************************************************

ldi r16, 0xFF
out DDRB, r16
out DDRC, r16

; ---> PWM Config
sei

ldi r16, 0
out TCNT0, r16

ldi r16, 0b0_1_10_1_100
out TCCR0, r16

rcall Deg_90


; Aquí empieza la configuración para teclado matricial
; Se usa el PUERTO D
ldi r16, 0b1111_0000; Los 4 bits más significativos son para la salida 
out DDRD, r16

TECLADO:
	ldi r16, 0xFF
	out PORTD, r16 ; Pull ups y todos 1

	cbi PORTD, 4 ; Poner 0 en D4
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PIND, 0
	rjmp SIETE
	sbis PIND, 1
	rjmp CUATRO
	sbis PIND, 2
	rjmp UNO
	sbis PIND, 3
	rjmp D

	sbi PORTD, 4 ; Pone 1 en D4
	cbi PORTD, 5 ; Pone 0 en D5
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PIND, 0
	rjmp OCHO
	sbis PIND, 1
	rjmp CINCO
	sbis PIND, 2
	rjmp DOS
	sbis PIND, 3
	rjmp CERO

	sbi PORTD, 5 ; Pone 1 en A5
	cbi PORTD, 6 ; Pone 0 en A6
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PIND, 0
	rjmp NUEVE
	sbis PIND, 1
	rjmp SEIS
	sbis PIND, 2
	rjmp TRES
	sbis PIND, 3
	rjmp E

	sbi PORTD, 6 ; Pone 1 en A6
	cbi PORTD, 7 ; Pone 0 en A7
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PIND, 0
	rjmp A
	sbis PIND, 1
	rjmp B
	sbis PIND, 2
	rjmp C
	sbis PIND, 3
	rjmp F

rjmp TECLADO


A:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_A:
		sbis PIND, 0
		rjmp TRABA_A
	rcall RETARDO_50m
rjmp TECLADO


B:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_B:
		sbis PIND, 1
		rjmp TRABA_B
	rcall RETARDO_50m
rjmp TECLADO


C:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_C:
		sbis PIND, 2
		rjmp TRABA_C
	rcall RETARDO_50m
rjmp TECLADO


D:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_D:
		sbis PIND, 3
		rjmp TRABA_D
	rcall RETARDO_50m
rjmp TECLADO


UNO:
	rcall Deg_0

	rcall RETARDO_50m
	TRABA_UNO:
		sbis PIND, 0
		rjmp TRABA_UNO
	rcall RETARDO_50m
rjmp TECLADO


CUATRO:
	rcall Deg_135

	rcall RETARDO_50m
	TRABA_CUATRO:
		sbis PIND, 1
		rjmp TRABA_CUATRO
	rcall RETARDO_50m
rjmp TECLADO


SIETE:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_SIETE:
		sbis PIND, 2
		rjmp TRABA_SIETE
	rcall RETARDO_50m
rjmp TECLADO


E:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_E:
		sbis PIND, 3
		rjmp TRABA_E
	rcall RETARDO_50m
rjmp TECLADO


DOS:
	rcall Deg_45

	rcall RETARDO_50m
	TRABA_DOS:
		sbis PIND, 0
		rjmp TRABA_DOS
	rcall RETARDO_50m
rjmp TECLADO


CINCO:
	rcall Deg_180

	rcall RETARDO_50m
	TRABA_CINCO:
		sbis PIND, 1
		rjmp TRABA_CINCO
	rcall RETARDO_50m
rjmp TECLADO


OCHO:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_OCHO:
		sbis PIND, 2
		rjmp TRABA_OCHO
	rcall RETARDO_50m
rjmp TECLADO


CERO:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_CERO:
		sbis PIND, 3
		rjmp TRABA_CERO
	rcall RETARDO_50m
rjmp TECLADO


TRES:
	rcall Deg_90

	rcall RETARDO_50m
	TRABA_TRES:
		sbis PIND, 0
		rjmp TRABA_TRES
	rcall RETARDO_50m
rjmp TECLADO


SEIS:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_SEIS:
		sbis PIND, 1
		rjmp TRABA_SEIS
	rcall RETARDO_50m
rjmp TECLADO


NUEVE:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_NUEVE:
		sbis PIND, 2
		rjmp TRABA_NUEVE
	rcall RETARDO_50m
rjmp TECLADO


F:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_F:
		sbis PIND, 3
		rjmp TRABA_F
	rcall RETARDO_50m
rjmp TECLADO

;-------------------------------------------
; Tags for servo rotation

Deg_0:
	ldi r16, 11
	out OCR0, r16
	; Display Position Number
	ldi r16, 1
	out PORTC, r16
ret

Deg_45:
	ldi r16, 17
	out OCR0, r16
	; Display Position Number
	ldi r16, 2
	out PORTC, r16
ret

Deg_90:
	ldi r16, 24
	out OCR0, r16
	; Display Position Number
	ldi r16, 3
	out PORTC, r16
ret

Deg_135:
	ldi r16, 31
	out OCR0, r16
	; Display Position Number
	ldi r16, 4
	out PORTC, r16
ret

Deg_180:
	ldi r16, 38
	out OCR0, r16
	; Display Position Number
	ldi r16, 5
	out PORTC, r16
ret

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
;Aquí están las rutinas para el manejo de las interrupciones concretas
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