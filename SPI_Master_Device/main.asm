;
; SPI_Master_Device.asm
;
; Created: 15.11.2022. 09:04:16
; Author : Aleksandar Bogdanovic

;
// ASM Master SPI Code

.include "m328pdef.inc"

.org 0x00
rjmp main

.dseg

.equ sck	= 5
.equ mosi	= 3
.equ ss		= 2

.cseg


main:
	ldi r17, 0b00101100			// 
	out DDRB, r17				// Ukljucujemo MOSI, SCK i SS pin kao output
	
	ldi r17, 0b01010001			// Ukljucujemo SPE, MSTR i SPR0 bitove u SPI kontrolnom registru
	out SPCR, r17				// Ukljucujemo hardverski Arduino SPI kao Master uredjaj, fsck/16
	
	ldi r17, 0b11001100			// Bajt koji ce biti prebacen
	
again:
	// enable emit
	cbi PORTB, SS				// Ukljucujemo Slave uredjaj
	out SPDR, r17				// Emitujemo bajt do Slave uredjaja
	
loop:
	in r18, SPSR
	sbrs r18, SPIF				// Cekamo da je bajt emituje
	rjmp loop					// Ponovi emitovanje
	// disable emit
	sbi PORTB, SS				// Iskljuci Slave uredjaj
	
	rcall delay					// Delay
	com	r17						// 1' komplement od bajta - ako je bajt 01010101 com od toga je 10101010
	rjmp again
	
delay:
	ldi  r20, 82
    ldi  r21, 43
    ldi  r22, 0
L1: dec  r22
    brne L1
    dec  r21
    brne L1
    dec  r20
    brne L1
    lpm
	ret
	