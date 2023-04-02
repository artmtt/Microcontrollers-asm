;******************************************************
; Título del proyecto
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
out DDRA, r16
out DDRB, r16
out DDRD, r16

out PORTC, r16

ldi r16, 0	// Para motor Eje
ldi r17, 0	// Para motor Brazo

ldi r18, 0 // Cont giro
ldi r20, 0
ldi r21, 0 // Flag White | Black

Main:
	sbis PINC, 0
	rjmp Make_Movement

	/*rcall Rotate_Down_Brazo
	rcall RETARDO_200m

	rcall Rotate_Up_Brazo
	rcall RETARDO_200m

	rcall Rotate_Right_Eje
	rcall RETARDO_200m

	rcall Rotate_Down_Brazo
	rcall RETARDO_200m

	rcall Rotate_Up_Brazo
	rcall RETARDO_200m

	rcall Rotate_Left_Eje
	rcall RETARDO_200m*/

	/*rcall Close_Pinza
	rcall retardo_200m
	rcall Open_Pinza
	rcall retardo_200m*/

	;rjmp STOP_EVER
rjmp Main

RETARDO_200m:
	rcall RETARDO_50m
	rcall RETARDO_50m
	rcall RETARDO_50m
	rcall RETARDO_50m
ret

STOP_EVER:
	ldi r20, 0
rjmp STOP_EVER

Make_Movement: // Button Pressed
	// Move Down
	// Take Ball
	// Move Up

	// if ball is white
	//		Rotate eje left
	// else
	//		Rotate eje right

	// Move Down
	// Drop Ball
	// Move Up
	// if ball was white
	//		Rotate eje right to center
	// else
	//		Rotate eje left to center

	rcall Rotate_Down_Brazo
	rcall RETARDO_200m

	rcall Close_Pinza
	rcall RETARDO_200m

	rcall Rotate_Up_Brazo
	rcall RETARDO_200m

	sbis PINC, 1 // skip if black
	rjmp White_Ball
	rjmp Black_Ball

	Make_Movement_OUT:
		rcall Rotate_Down_Brazo
		rcall RETARDO_200m


		rcall Open_Pinza
		rcall RETARDO_200m

		rcall Rotate_Up_Brazo
		rcall RETARDO_200m

		sbrs r21, 0 // skip if was black
		rjmp Was_White_Ball
		rjmp Was_Black_Ball

		Make_Movement_EXIT:
			rcall RETARDO_50m
			Traba_Button:
				sbis PINC, 0
				rjmp Traba_Button
			rcall RETARDO_50m
rjmp Main

White_Ball:
	ldi r21, 0b0000_0000
	rcall Rotate_Left_Eje
	rcall RETARDO_200m
rjmp Make_Movement_OUT

Black_Ball:
	ldi r21, 0b0000_0001
	rcall Rotate_Right_Eje
	rcall RETARDO_200m
rjmp Make_Movement_OUT


Was_White_Ball:
	rcall Rotate_Right_Eje
	rcall RETARDO_200m
rjmp Make_Movement_EXIT

Was_Black_Ball:
	rcall Rotate_Left_Eje
	rcall RETARDO_200m
rjmp Make_Movement_EXIT


// ---------------------------- Pinza
Close_Pinza:
	ldi r20, 0b0000_0010

	INC r18
	cpi r18, 210
	breq MAX_ROTS

	out PORTD, r20
	rcall RETARDO_5m
rjmp Close_Pinza


Open_Pinza:
	ldi r20, 0b0000_0001

	INC r18
	cpi r18, 30
	breq MAX_ROTS

	out PORTD, r20
	rcall RETARDO_5m
	ldi r20, 0
	out PORTD, r20
rjmp Open_Pinza



// ---------------------------- Eje
Rotate_Right_Eje:
	lsr r16
	cpi r16, 0
	breq RESET_Right_R16

	INC r18
	cpi r18, 255
	breq MAX_ROTS

	Rotate_Right_Eje_EXIT:
		out PORTA, r16
		rcall RETARDO_5m
rjmp Rotate_Right_Eje

MAX_ROTS:
ldi r18, 0
;rjmp MAIN
ret

RESET_Right_R16:
	ldi r16, 0b0000_1000
rjmp Rotate_Right_Eje_EXIT

RESET_Left_R16:
	ldi r16, 0b0000_0001
rjmp Rotate_Left_Eje_EXIT

Rotate_Left_Eje:
	lsl r16
	cpi r16, 16
	breq RESET_Left_R16
	cpi r16, 0
	breq RESET_Left_R16

	INC r18
	cpi r18, 255
	breq MAX_ROTS

	Rotate_Left_Eje_EXIT:
		out PORTA, r16
		rcall RETARDO_5m
rjmp Rotate_Left_Eje
// ----------------------------

// ---------------------------- Brazo
Rotate_Up_Brazo:
	lsr r17
	cpi r17, 0
	breq RESET_Up_R17

	INC r18
	cpi r18, 220
	breq MAX_ROTS

	Rotate_Up_Brazo_EXIT:
		out PORTB, r17
		rcall RETARDO_5m
		rcall RETARDO_5m
rjmp Rotate_Up_Brazo

RESET_Up_R17:
	ldi r17, 0b0011_1000
rjmp Rotate_Up_Brazo_EXIT

RESET_Down_R17:
	ldi r17, 0b0000_0001
rjmp Rotate_Down_Brazo_EXIT

Rotate_Down_Brazo:
	lsl r17
	cpi r17, 16
	breq RESET_Down_R17
	cpi r17, 0
	breq RESET_Down_R17

	INC r18
	cpi r18, 70
	breq MAX_ROTS

	Rotate_Down_Brazo_EXIT:
		out PORTB, r17
		rcall RETARDO_5m
		rcall RETARDO_5m
rjmp Rotate_Down_Brazo
// ----------------------------


; ---------------------------------
RETARDO_5m:
; ============================= 
;    delay loop generator 
;     5000 cycles:
; ----------------------------- 
; delaying 4998 cycles:
          ldi  R29, $07
WGLOOP0:  ldi  R30, $ED
WGLOOP1:  dec  R30
          brne WGLOOP1
          dec  R29
          brne WGLOOP0
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