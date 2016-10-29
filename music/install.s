INIT		= $1000
PLAY		= $1003

		; efo header

		.byt	"EFO2"		; fileformat magic
		.word	0		; prepare routine
		.word	setup		; setup routine
		.word	interrupt	; irq handler
		.word	0		; main routine
		.word	0		; fadeout routine
		.word	0		; cleanup routine
		.word	0		; location of playroutine call

		.byt	"S"		; i/o safe

		.byt	"M",<PLAY,>PLAY	; music playroutine for subsequent effects

		.byt	0

		.word	loadaddr
		* = $ec00
loadaddr

setup
		lda	#$1b
		sta	$d011
		lda	#$fb
		sta	$d012
		lda	#0
		jsr	INIT
		rts

interrupt
		pha
		lda	1
		pha
		lda	#$35
		sta	1
		txa
		pha
		tya
		pha
		jsr	PLAY
		pla
		tay
		pla
		tax
		pla
		lsr	$d019
		sta	1
		pla
		rti
