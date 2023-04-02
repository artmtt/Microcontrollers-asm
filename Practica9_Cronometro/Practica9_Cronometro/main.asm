;******************************************************
; Práctica 9 Cronómetro
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
sei

ldi r16, 0xFF
out PORTA, r16
out DDRC, r16
out DDRD, r16

ldi r17, 0
ldi r18, 0
ldi r19, 0
ldi r20, 0

Main_Code:
	sbis PINA, 0
	rjmp Init_Count
	sbis PINA, 7
	rjmp Reset_Count_btn
rjmp Main_Code

Init_Count:
	ldi r16, 0
	out TCNT0, r16

	// 4 Mhz
	// N = 1024
	ldi r16, 0b0_0_00_1_101
	out TCCR0, r16

	// 0.05 Seg cada INT
	ldi r16, 194
	out OCR0, r16

	ldi r16, 0b000000_11
	out TIFR, r16

	ldi r16, 0b000000_10
	out TIMSK, r16

	rcall RETARDO_50m
	TRABA_INIT:
		sbis PINA, 0
		rjmp TRABA_INIT
	rcall RETARDO_50m
rjmp Main_Code

Reset_Count:
	// Reset Flags and Unable Comp INT
	ldi r16, 0b000000_11
	out TIFR, r16

	ldi r16, 0b000000_00
	out TIMSK, r16

	ldi r16, 0 // -> INT Counter
	ldi r17, 0 // -> Seconds Counter
	ldi r18, 0 // -> Minute Counter
	
	out PORTC, r17
	out PORTD, r17 
ret

Reset_Count_btn:
	rcall Reset_Count

	rcall RETARDO_50m
	TRABA_Reset:
		sbis PINA, 7
		rjmp TRABA_Reset
	rcall RETARDO_50m
rjmp Main_Code

Inc_Second:
	ldi r16, 0
	// INC r17
	mov r19, r17
	mov r20, r17
	andi r19, 0b1111_0000
	andi r20, 0b0000_1111
	
	INC r20

	cpi r20, 10
	breq INC_Dec_Second

	EXIT_Inc_Second:
		// Merge the two regs
		ldi r17, 0
		or r17, r19
		or r17, r20

		cpi r19, 96
		breq Inc_Minute
rjmp EXIT_TIM0_COMP

INC_Dec_Second:
	ldi r20, 0b0001_0000
	add r19, r20
	ldi r20, 0
rjmp EXIT_Inc_Second

Inc_Minute:
	ldi r17, 0
	INC r18
	cpi r18, 5
	breq TIME_LIMIT_END
rjmp EXIT_TIM0_COMP

TIME_LIMIT_END:
	rcall Reset_Count
rjmp EXIT_TIM0_COMP

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
	in r19, SREG
	push r19

	INC r16
	cpi r16, 20
	breq Inc_Second

	EXIT_TIM0_COMP:
		out PORTC, r18
		out PORTD, r17

		pop r19
		out SREG, r19
reti
SPM_RDY:
reti ; Store Program Memory Ready Handler