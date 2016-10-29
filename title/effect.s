		; efo header

		.aasc	"EFO2"		; fileformat magic
		.word	0		; prepare routine
		.word	setup		; setup routine
		.word	interrupt	; irq handler
		.word	0		; main routine
		.word	0		; fadeout routine
		.word	0		; cleanup routine
		.word	mod_jsr		; location of playroutine call

		; tags go here

		;.byt	"P",$04,$07	; range of pages in use
		;.byt	"I",$10,$1f	; range of pages inherited
		;.byt	"Z",$02,$03	; range of zero-page addresses in use
		;.byt	"X"		; avoid loading
		;.byt	"M",<play,>play	; install music playroutine

		.aasc	"S"		; i/o safe
		.byt	0		; end of tags

		.word	loadaddr
		* = $3000
loadaddr

setup
    ldx #$00    ; black color
    stx $d021   ; background
    stx $d020   ; border

clear
    lda #$020   ; spacebar code
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $06e8,x
    lda #$00    ; black color
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne clear   ; loop until X overflows

    ldx #$00
loop_text
    lda line1,x   ; read character from line 1
    sta $0590,x   ; and store in Screen RAM near center
    lda line2,x   ; some trick for line 2
    sta $05e0,x
    lda line3,x   ; and line 3
    sta $0630,x

    inx
    cpx #$28      ; process 40 cols of each line
    bne loop_text ; loop until done

    lda $d011   ; clear bit 0 (we're before line 255)
    and #$7f
    sta $d011
		lda	#$00
		sta	$d012   ; interupt on row 0
		rts

interrupt
		; Jitter correction. Put earliest cycle in parenthesis.
		; (10 with no sprites, 19 with all sprites, ...)
		; Length of clockslide can be increased if more jitter
		; is expected, e.g. due to NMIs.
		dec	0		; 10..18
		sta	int_savea+1	; 15..23
		lda	#39-(10)	; 19..27 <- (earliest cycle)
		sec			; 21..29
		sbc	$dc06		; 23..31, A becomes 0..8
		sta	*+4		; 27..35
		bpl	*+2		; 31..39
		lda	#$a9		; 34
		lda	#$a9		; 36
		lda	#$a9		; 38
		lda	$eaa5		; 40

		; at cycle 34+(10) = 44

		stx	int_savex+1
		sty	int_savey+1

		ldx #$27      ; 39 iterations
    lda color+$27 ; load acc with the last color from the table

cycle1
    ldy color-1,x  ; load current color in Y
    sta color-1,x  ; overwrite position with color from acc
    sta $d990,x    ; put it into Color RAM
    sta $da30,x
    tya            ; transfer remembered color into acc
    dex            ; next iteration
    bne cycle1     ; keep going until we had all iterations
    sta color+$27  ; when done store last color from acc into table
    sta $d990      ; and into Color RAM
    sta $da30

    ldx #$00       ; loop the other way round for the second line
    lda color2+$27 ; load acc with first color from the table

cycle2
    ldy color2,x   ; load current color in Y
    sta color2,x   ; overwrite position with color from acc
    sta $d9e0,x    ; put into Color RAM
    tya            ; transfer remembered color into acc
    inx            ; next iteration
    cpx #$26       ; are we through 39 iterations?
    bne cycle2     ; if not repeat
    sta color2+$27 ; if we are store the final color
    sta $d9e0+$27  ; and write it to Color RAM

mod_jsr bit !0

int_savea	lda	#0
int_savex	ldx	#0
int_savey	ldy	#0
		lsr	$d019
		inc	0
		rti


color        .byt $06,$06,$06,$0e,$0e 
             .byt $0e,$03,$03,$03,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$03,$03,$03,$0e 
             .byt $0e,$0e,$06,$06,$06 

color2       .byt $06,$06,$06,$0e,$0e 
             .byt $0e,$03,$03,$03,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$07,$07,$07,$07 
             .byt $07,$03,$03,$03,$0e 
             .byt $0e,$0e,$06,$06,$06

line1   .asc "            defeest presents            "
line2   .asc "       all the cheap demo effects       " 
line3   .asc "     we could find on the interwebs     "
