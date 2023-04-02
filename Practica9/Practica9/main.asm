;******************************************************
; Practica9
;
; Fecha: 
; Autor: 
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

sei // Interrupciones HABILITADAS
ldi r16, 0b0000_0011 // INT0 Flanco de subida
out MCUCR, r16
ldi r16, 0b111_00000
out GIFR, r16
ldi r16, 0b010_00000
out GICR, r16

ldi r16, 0xFF
out DDRC, r16

FIRST_SEQUENCE:
	ldi r16, 0b0000_0001
	out PORTC, r16
	rcall RETARDO_2s

	FIRST_SEQUENCE_MAIN:
		lsl r16
		out PORTC, r16
		rcall RETARDO_2s
		sbrs r16, 7
	rjmp FIRST_SEQUENCE_MAIN
rjmp FIRST_SEQUENCE


RETARDO_50ms:
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

RETARDO_2s:
; ============================= 
;    delay loop generator 
;     2000000 cycles:
; ----------------------------- 
; delaying 1999998 cycles:
          ldi  R26, $12
WGLOOP0_1:  ldi  R27, $BC
WGLOOP1_1:  ldi  R28, $C4
WGLOOP2_1:  dec  R28
          brne WGLOOP2_1
          dec  R27
          brne WGLOOP1_1
          dec  R26
          brne WGLOOP0_1
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 
ret


;******************************************************
;Aquí están las rutinas para el manejo de las interrupciones concretas
;******************************************************
EXT_INT0: ; IRQ0 Handler
	in r17, SREG
	push r17
	// Respaldar registros de RETARDO_2s por si la INT0 se activó ahí
	push r26
	push r27
	push r28

	// Rebote
	rcall RETARDO_50ms
	sbis PIND, 2
	rjmp EXIT_INT0

	ldi r17, 0
	ldi r18, 0

	THREE_ON_DOWN:
		com r17
		out PORTC, r17
		rcall RETARDO_2s
		INC r18
		cpi r18, 6
		breq EXIT_INT0
	rjmp THREE_ON_DOWN

	EXIT_INT0:
	ldi r18, 0

	rcall RETARDO_50ms
	TRABA_INT0:
		sbic PIND, 2
		rjmp TRABA_INT0
	rcall RETARDO_50ms

	// RESET PORTC To how it was before INT0
	out PORTC, r16
	pop r26
	pop r27
	pop r28

	pop r17
	out SREG, r17
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