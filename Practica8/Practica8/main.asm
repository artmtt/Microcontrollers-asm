;******************************************************
; Práctica8
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
sei ; -----------------------------> Usando INT

;******************************************************
;No olvides configurar al inicio los puertos que utilizarás
;También debes configurar si habrá o no pull ups en las entradas
;Para las salidas deberás indicar cuál es la salida inicial
;Los registros que vayas a utilizar inicializalos si es necesario
;******************************************************

ldi r16, 0xFF
out DDRA, r16

// Pull up Interrupción 0
out PORTD, r16

ldi r16, 0b0000_0010
out MCUCR, r16

ldi r16, 0b111_00000
out GIFR, r16

ldi r16, 0b010_00000
out GICR, r16

ldi r16, 1
ldi r18, 16

RANDOM_NUM:
	INC r16
	cpi r16, 7
	breq RESET_r16
	rjmp RANDOM_NUM

RESET_r16:
	ldi r16, 1
	rjmp RANDOM_NUM

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

UNO:
	ldi r17, 0b0000_1000
rjmp OUT_INT0

DOS:
	ldi r17, 0b0010_0010
rjmp OUT_INT0

TRES:
	ldi r17, 0b0100_1001
rjmp OUT_INT0

CUATRO:
	ldi r17, 0b0101_0101
rjmp OUT_INT0

CINCO:
	ldi r17, 0b0101_1101
rjmp OUT_INT0

SEIS:
	ldi r17, 0b0111_0111
rjmp OUT_INT0

SIETE:
	ldi r17, 0b0111_1111
rjmp OUT_INT0

;******************************************************
;Aquí están las rutinas para el manejo de las interrupciones concretas
;******************************************************
EXT_INT0: ; IRQ0 Handler
	in r18, SREG // Respaldar SREG para evitar problemas
	push r18 // Guardar r18 (SREG) en la pila para poder usar r18 en el código de abajo

	// Verificar Rebote
	rcall RETARDO_50m
	sbic PIND, 2
	rjmp OUT_INT0

	cpi r16, 1
	breq UNO
	cpi r16, 2
	breq DOS
	cpi r16, 3
	breq TRES
	cpi r16, 4
	breq CUATRO
	cpi r16, 5
	breq CINCO
	cpi r16, 6
	breq SEIS
	cpi r16, 7
	breq SIETE

	OUT_INT0:
		out PORTA, r17

	rcall RETARDO_50m
	TRABA_INT0:
		sbis PIND, 2
		rjmp TRABA_INT0
	rcall RETARDO_50m
	pop r18 // Recuperar r18 (SREG anterior)
	out SREG, r18 // Restore SREG
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