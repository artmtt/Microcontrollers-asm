;******************************************************
; Práctica 6
;
; Fecha: 27/09/2022
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


;******************************************************
;No olvides configurar al inicio los puertos que utilizarás
;También debes configurar si habrá o no pull ups en las entradas
;Para las salidas deberás indicar cuál es la salida inicial
;Los registros que vayas a utilizar inicializalos si es necesario
;******************************************************

ldi r16, 0xFF
out PORTB, r16
out DDRA, r16

ldi r16, 0b0000_0000

READ:
	sbis PINB, 0
	rjmp BUTTON0
	sbis PINB, 1
	rjmp BUTTON1
rjmp READ

BUTTON0:
	;rcall RETARDO_50m
	R_CLOCKWISE:
			lsr r16
			cpi r16, 0
			breq RESET0_R16
			;rcall RETARDO_10m
			out PORTA, r16
			rcall RETARDO_10m
	;rcall RETARDO_50m
rjmp READ

RESET0_R16:
	ldi r16, 0b0001_0000
rjmp BUTTON0

RESET1_R16:
	ldi r16, 0b0000_0000
rjmp BUTTON1

RESET_SHOW1_R16:
	ldi r16, 0b0000_0001
	;rcall RETARDO_10m
	out PORTA, r16
	rcall RETARDO_10m
;rcall RETARDO_50m
rjmp READ

BUTTON1:
	;rcall RETARDO_50m
	R_NOT_CLOCKWISE:
			lsl r16
			cpi r16, 16
			breq RESET1_R16
			cpi r16, 0
			breq RESET_SHOW1_R16
			;rcall RETARDO_10m
			out PORTA, r16
			rcall RETARDO_10m
	;rcall RETARDO_50m
rjmp READ


; ---------------------------------
RETARDO_10m:
; ============================= 
;    delay loop generator 
;     10000 cycles:
; ----------------------------- 
; delaying 9999 cycles:
          ldi  R29, $21
WGLOOP0:  ldi  R30, $64
WGLOOP1:  dec  R30
          brne WGLOOP1
          dec  R29
          brne WGLOOP0
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 
ret

RETARDO_50m:
; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R26, $65
WGLOOP0_1:  ldi  R27, $A4
WGLOOP1_1:  dec  R27
          brne WGLOOP1_1
          dec  R26
          brne WGLOOP0_1
; ----------------------------- 
; delaying 3 cycles:
          ldi  R26, $01
WGLOOP2_1:  dec  R26
          brne WGLOOP2_1
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