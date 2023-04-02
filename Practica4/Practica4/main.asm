;******************************************************
; Práctica4
;
; Fecha: 22/09/2022
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

;CLR r16
;out DDRA, r16

ldi r16, 0xFF
out DDRC, r16

out PORTA, r16

; r17 -> Red Count
; r18 -> Blue Count
; r19 -> Both Combined

ldi r20, 16

READ:
	sbis PINA, 0
	rjmp RESET_RED
	sbis PINA, 2
	rjmp INC_RED

	sbis PINA, 4
	rjmp RESET_BLUE
	sbis PINA, 6
	rjmp INC_BLUE
	rjmp READ

RESET_RED:
	CLR r17
	rcall OUT_NUM

	rcall RETARDO
	rcall TRABA_RR
	rcall RETARDO
	rjmp READ

INC_RED:
	INC r17
	sbrc r17, 4
	CLR r17
	rcall OUT_NUM

	rcall RETARDO
	rcall TRABA_IR
	rcall RETARDO
	rjmp READ

RESET_BLUE:
	rcall RETARDO
	rcall TRABA_RB
	rcall RETARDO

	CLR r18
	rcall OUT_NUM

	rjmp READ

INC_BLUE:
	rcall RETARDO
	rcall TRABA_IB
	rcall RETARDO

	INC r18
	sbrc r18, 4
	CLR r18
	rcall OUT_NUM

	rjmp READ

OUT_NUM:
	mov r19, r17
	mul r19, r20
	mov r19, r0
	add r19, r18
	out PORTC, r19
	ret

;--------------------------
TRABA_RR:
	sbis PINA, 0
	rjmp TRABA_RR
	ret

TRABA_IR:
	sbis PINA, 2
	rjmp TRABA_IR
	ret

TRABA_RB:
	sbis PINA, 4
	rjmp TRABA_RB
	ret

TRABA_IB:
	sbis PINA, 6
	rjmp TRABA_IB
	ret

RETARDO:
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