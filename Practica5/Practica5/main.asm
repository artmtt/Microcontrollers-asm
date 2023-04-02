;******************************************************
; Teclado Matricial
;
; Fecha: 04/10/2022
; Autor: Arturo
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

; Aquí empieza la configuración para teclado matricial
; Se usa el PUERTO A
ldi r16, 0b1111_0000; Los 4 bits más significativos son para la salida 
out DDRA, r16

ldi r17, 0xFF
out DDRD, r17

ldi r17, 0
; ---------------------------------------> **IMP r17 va a guardar el número que había sido presionado en el teclado matricial
;  r17 -> 0b++++_---- -> - for display at the left, + for the right -> The ORDER of the BITS 0b1234_1234 **EXAMPLE IN UNO

TECLADO:
	ldi r16, 0xFF
	out PORTA, r16 ; Pull ups y todos 1

	cbi PORTA, 4 ; Poner 0 en A4
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PINA, 0
	rjmp UNO
	sbis PINA, 1
	rjmp CUATRO
	sbis PINA, 2
	rjmp SIETE
	sbis PINA, 3
	rjmp ASTERISC

	sbi PORTA, 4 ; Pone 1 en A4
	cbi PORTA, 5 ; Pone 0 en A5
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PINA, 0
	rjmp DOS
	sbis PINA, 1
	rjmp CINCO
	sbis PINA, 2
	rjmp OCHO
	sbis PINA, 3
	rjmp CERO

	sbi PORTA, 5 ; Pone 1 en A5
	cbi PORTA, 6 ; Pone 0 en A6
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PINA, 0
	rjmp TRES
	sbis PINA, 1
	rjmp SEIS
	sbis PINA, 2
	rjmp NUEVE
	sbis PINA, 3
	rjmp HASHTAG

	sbi PORTA, 6 ; Pone 1 en A6
	cbi PORTA, 7 ; Pone 0 en A7
	nop
	nop
	; Revisar si hay un 0 en algún botón de la columna
	sbis PINA, 0
	rjmp A
	sbis PINA, 1
	rjmp B
	sbis PINA, 2
	rjmp C
	sbis PINA, 3
	rjmp D

rjmp TECLADO


UNO:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_1000 // ONE is 1000 instead of 0001
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_UNO:
		sbis PINA, 0
		rjmp TRABA_UNO
	rcall RETARDO_50m
rjmp TECLADO


CUATRO:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_0010
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_CUATRO:
		sbis PINA, 1
		rjmp TRABA_CUATRO
	rcall RETARDO_50m
rjmp TECLADO


SIETE:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_1110
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_SIETE:
		sbis PINA, 2
		rjmp TRABA_SIETE
	rcall RETARDO_50m
rjmp TECLADO


ASTERISC:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_ASTERISC:
		sbis PINA, 3
		rjmp TRABA_ASTERISC
	rcall RETARDO_50m
rjmp TECLADO


DOS:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_0100
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_DOS:
		sbis PINA, 0
		rjmp TRABA_DOS
	rcall RETARDO_50m
rjmp TECLADO


CINCO:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_1010
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_CINCO:
		sbis PINA, 1
		rjmp TRABA_CINCO
	rcall RETARDO_50m
rjmp TECLADO


OCHO:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_0001
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_OCHO:
		sbis PINA, 2
		rjmp TRABA_OCHO
	rcall RETARDO_50m
rjmp TECLADO


CERO:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	/*ldi r18, 0b0000_0000
	add r17, r18*/
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_CERO:
		sbis PINA, 3
		rjmp TRABA_CERO
	rcall RETARDO_50m
rjmp TECLADO


TRES:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_1100
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_TRES:
		sbis PINA, 0
		rjmp TRABA_TRES
	rcall RETARDO_50m
rjmp TECLADO


SEIS:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_0110
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_SEIS:
		sbis PINA, 1
		rjmp TRABA_SEIS
	rcall RETARDO_50m
rjmp TECLADO


NUEVE:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_1001
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_NUEVE:
		sbis PINA, 2
		rjmp TRABA_NUEVE
	rcall RETARDO_50m
rjmp TECLADO


HASHTAG:
	// Aquí va el código de lo que se quiere hacer cuando esté presionado
	rcall RETARDO_50m
	TRABA_HASHTAG:
		sbis PINA, 3
		rjmp TRABA_HASHTAG
	rcall RETARDO_50m
rjmp TECLADO


A:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_0101
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_A:
		sbis PINA, 0
		rjmp TRABA_A
	rcall RETARDO_50m
rjmp TECLADO


B:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_1101
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_B:
		sbis PINA, 1
		rjmp TRABA_B
	rcall RETARDO_50m
rjmp TECLADO


C:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_0011
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_C:
		sbis PINA, 2
		rjmp TRABA_C
	rcall RETARDO_50m
rjmp TECLADO


D:
	lsl r17
	lsl r17
	lsl r17
	lsl r17
	ldi r18, 0b0000_1011
	add r17, r18
	out PORTD, r17
	rcall RETARDO_50m
	TRABA_D:
		sbis PINA, 3
		rjmp TRABA_D
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
;No olvides configurar al inicio los puertos que utilizarás
;También debes configurar si habrá o no pull ups en las entradas
;Para las salidas deberás indicar cuál es la salida inicial
;Los registros que vayas a utilizar inicializalos si es necesario
;******************************************************




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