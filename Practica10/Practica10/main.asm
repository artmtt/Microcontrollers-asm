;******************************************************
; Practica 10
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

ldi r16, 0xFF
out DDRB, r16

//---------------- TIMER0:
// -> BPM: 180
sei

SONG_CALL:
	rcall PART1_LOOP
	rcall RETARDO_Negra
	nop
	nop
	nop
	nop
	//------------------------

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Corchea

	// Unable it for a moment
	;ldi r16, 0b0_0_00_1_011
	;out TCCR0, r16
	// Retardo bewtween notes
	;rcall RETARDO_50m

	// Enable it
	;ldi r16, 0b0_0_01_1_011
	;out TCCR0, r16

	rcall RETARDO_Blanca
	//------------------------ PART1 END

	rcall PART1_LOOP
	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	nop
	nop
	nop
	nop
	//------------------------

	//------------------------
	ldi r16, 19
	out OCR0, r16

	rcall RETARDO_Corchea
	rcall RETARDO_Blanca
	//------------------------ PART2 MIDDLE START

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 15
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 19
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 15
	out OCR0, r16

	rcall RETARDO_Corchea
	//------------------------

	//------------------------
	ldi r16, 14
	out OCR0, r16

	rcall RETARDO_Corchea
	//------------------------

	//------------------------
	ldi r16, 15
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 19
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 15
	out OCR0, r16

	rcall RETARDO_Corchea
	//------------------------

	//------------------------
	ldi r16, 14
	out OCR0, r16

	rcall RETARDO_Corchea
	//------------------------

	//------------------------
	ldi r16, 15
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 19
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 26
	out OCR0, r16

	rcall RETARDO_Blanca
	//------------------------ END PARTE 2

	rcall PART1_LOOP
	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	nop
	nop
	nop
	nop
	//------------------------

	//------------------------
	ldi r16, 19
	out OCR0, r16

	rcall RETARDO_Corchea
	rcall RETARDO_Blanca

	// UNABLE it
	ldi r16, 0b0_0_00_1_011
	out TCCR0, r16
	
	TRABA_SONG:
		rjmp TRABA_SONG

PART1_LOOP:
	ldi r16, 0
	out TCNT0, r16

	// CTC, N = 64
	ldi r16, 0b0_0_01_1_011
	out TCCR0, r16

	ldi r16, 15
	out OCR0, r16

	//------------------------

	ldi r16, 0b000000_11
	out TIFR, r16

	ldi r16, 0b000000_10
	out TIMSK, r16

	rcall RETARDO_Negra
	rcall RETARDO_Negra

	//------------------------
	ldi r16, 14
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 12
	out OCR0, r16

	rcall RETARDO_Negra
	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 14
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 15
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 19
	out OCR0, r16

	rcall RETARDO_Negra
	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 17
	out OCR0, r16

	rcall RETARDO_Negra
	//------------------------

	//------------------------
	ldi r16, 15
	out OCR0, r16

	rcall RETARDO_Negra
ret


RETARDO_Negra:
; ============================= 
;    delay loop generator 
;     333000 cycles:
; ----------------------------- 
; delaying 332976 cycles:
          ldi  R29, $07
WGLOOP0:  ldi  R30, $69
WGLOOP1:  ldi  R31, $96
WGLOOP2:  dec  R31
          brne WGLOOP2
          dec  R30
          brne WGLOOP1
          dec  R29
          brne WGLOOP0
; ----------------------------- 
; delaying 24 cycles:
          ldi  R29, $08
WGLOOP3:  dec  R29
          brne WGLOOP3
; ============================= 
ret

RETARDO_Blanca:
; ============================= 
;    delay loop generator 
;     667000 cycles:
; ----------------------------- 
; delaying 666999 cycles:
          ldi  R26, $6F
WGLOOP0_B:  ldi  R27, $0B
WGLOOP1_B:  ldi  R28, $B5
WGLOOP2_B:  dec  R28
          brne WGLOOP2_B
          dec  R27
          brne WGLOOP1_B
          dec  R26
          brne WGLOOP0_B
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 
ret

RETARDO_Corchea:
; ============================= 
;    delay loop generator 
;     167000 cycles:
; ----------------------------- 
; delaying 166980 cycles:
          ldi  R23, $DC
WGLOOP0_c:  ldi  R24, $FC
WGLOOP1_c:  dec  R24
          brne WGLOOP1_c
          dec  R23
          brne WGLOOP0_c
; ----------------------------- 
; delaying 18 cycles:
          ldi  R23, $06
WGLOOP2_c:  dec  R23
          brne WGLOOP2_c
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 
ret

RETARDO_50m:
; ============================= 
;    delay loop generator 
;     50000 cycles:
; ----------------------------- 
; delaying 49995 cycles:
          ldi  R20, $65
WGLOOP0_50:  ldi  R21, $A4
WGLOOP1_50:  dec  R21
          brne WGLOOP1_50
          dec  R20
          brne WGLOOP0_50
; ----------------------------- 
; delaying 3 cycles:
          ldi  R20, $01
WGLOOP2_50:  dec  R20
          brne WGLOOP2_50
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