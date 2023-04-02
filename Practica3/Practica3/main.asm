;******************************************************
; Título del proyecto
;
; Fecha: Poner aquí la fecha
; Autor: Poner aquí el autor
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

;ldi r16, 0
;out DDRA, r16

ldi r16, 0xFF
out DDRD, r16

out PORTA, r16

ldi r17, 0

rcall ZERO

READ:
	sbis PINA, 0
	rjmp PRESS
	rjmp READ

PRESS:
	rcall HANDLEPRESS
	rcall RETARDO
	rcall TRABA
	rcall RETARDO
	rjmp READ

HANDLEPRESS:
	INC r17
	cpi r17, 1
	breq ONE

	cpi r17, 2
	breq TWO

	cpi r17, 3
	breq THREE

	cpi r17, 4
	breq FOUR

	cpi r17, 5
	breq FIVE

	cpi r17, 6
	breq SIX

	cpi r17, 7
	breq SEVEN

	cpi r17, 8
	breq EIGHT

	cpi r17, 9
	breq NINE

	ldi r17, 0
	rjmp ZERO
	ret

;------------------------------
ZERO:
	ldi r18, 0b0011_1111
	rjmp OUTDISPLAY

ONE:
	ldi r18, 0b0000_0110
	rjmp OUTDISPLAY

TWO:
	ldi r18, 0b0101_1011
	rjmp OUTDISPLAY

THREE:
	ldi r18, 0b0100_1111
	rjmp OUTDISPLAY

FOUR:
	ldi r18, 0b0110_0110
	rjmp OUTDISPLAY

FIVE:
	ldi r18, 0b0110_1101
	rjmp OUTDISPLAY

SIX:
	ldi r18, 0b0111_1101
	rjmp OUTDISPLAY

SEVEN:
	ldi r18, 0b0000_0111
	rjmp OUTDISPLAY

EIGHT:
	ldi r18, 0b0111_1111
	rjmp OUTDISPLAY

NINE:
	ldi r18, 0b0110_0111
	rjmp OUTDISPLAY

OUTDISPLAY:
	out PORTD, r18
	ret
;------------------------------

TRABA:
	sbis PINA, 0
	rjmp TRABA
	ret

RETARDO:
; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R18, $65
WGLOOP0:  ldi  R19, $A4
WGLOOP1:  dec  R19
          brne WGLOOP1
          dec  R18
          brne WGLOOP0
; ----------------------------- 
; delaying 3 cycles:
          ldi  R18, $01
WGLOOP2:  dec  R18
          brne WGLOOP2
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