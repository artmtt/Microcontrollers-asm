;******************************************************
; Práctica 12
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
out PORTA, r16
out DDRB, r16

; ----------> Timer Config
sei

ldi r16, 0
out TCNT0, r16

ldi r16, 0b0_1_11_1_001
out TCCR0, r16

;ldi r16, 255
;out OCR0, r16

ldi r16, 255 // -> Counter
rjmp Increase_OCR

MAIN_Code:
	sbis PINA, 0
	rjmp Decrease_OCR
	sbis PINA, 7
	rjmp Increase_OCR
rjmp MAIN_Code

Decrease_OCR:
	cpi r16, 0
	brne Dec_r16
	Step_2_Dec:
		cpi r16, 0
		breq Min_r16
	END_Decrease:
		out PORTB, r17
		out OCR0, r16
		rcall RETARDO_50m
		TRABA_Dec:
			sbis PINA, 0
			rjmp TRABA_Dec
		rcall RETARDO_50m
rjmp MAIN_Code

Dec_r16:
	subi r16, 51
	ldi r17, 0b0000_0000
rjmp Step_2_Dec

Min_r16:
	ldi r17, 0b0000_0100
rjmp END_Decrease

Increase_OCR:
	cpi r16, 255
	brne Inc_r16
	Step_2_Inc:
		cpi r16, 255
		breq Max_r16
	END_Increase:
		out PORTB, r17
		out OCR0, r16
		rcall RETARDO_50m
		TRABA_Inc:
			sbis PINA, 7
			rjmp TRABA_Inc
		rcall RETARDO_50m
rjmp MAIN_Code

Inc_r16:
	ldi r18, 51
	add r16, r18
	ldi r17, 0b0000_0000
rjmp Step_2_Inc

Max_r16:
	ldi r17, 0b0000_0010
rjmp END_Increase


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