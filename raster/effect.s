        ; efo header

        .byt  "EFO2"    ; fileformat magic
        .word 0         ; prepare routine
        .word 0         ; setup routine
        .word interrupt ; irq handler
        .word 0         ; main routine
        .word 0         ; fadeout routine
        .word 0         ; cleanup routine
        .word mod_jsr   ; location of playroutine call

        ; tags go here

        ;.byt "P",$04,$07 ; range of pages in use
        ;.byt "I",$10,$1f ; range of pages inherited
        ;.byt "Z",$02,$03 ; range of zero-page addresses in use
        ;.byt "X"         ; avoid loading
        ;.byt "M",<play,>play ; install music playroutine

        .byt "S" ; i/o safe
        .byt 0   ; end of tags

counter = $02

        .word loadaddr
        * = $3c00
loadaddr

main
        ldx counter
raster
        lda sinusTable,x  ; grab rasterline value
        cmp $d012         ; are we there yet?
        beq rastergo
        rts
rastergo
        ldx #00
loop
        lda colorTable,x  ; assign background and border colors
        sta $d020
        sta $d021
        inx
        cpx #$1a
        bne loop

        lda #00           ; assign black to background and border
        sta $d020
        sta $d021
        inc counter
        rts

interrupt
        ; Jitter correction. Put earliest cycle in parenthesis.
        ; (10 with no sprites, 19 with all sprites, ...)
        ; Length of clockslide can be increased if more jitter
        ; is expected, e.g. due to NMIs.
        dec 0               ; 10..18
        sta int_savea+1     ; 15..23
        lda #39-(10)        ; 19..27 <- (earliest cycle)
        sec                     ; 21..29
        sbc $dc06           ; 23..31, A becomes 0..8
        sta *+4             ; 27..35
        bpl *+2             ; 31..39
        lda #$a9            ; 34
        lda #$a9            ; 36
        lda #$a9            ; 38
        lda $eaa5           ; 40

        ; at cycle 34+(10) = 44

        stx int_savex+1
        sty int_savey+1

mod_jsr      bit     !0

int_savea       lda     #0
int_savex       ldx     #0
int_savey       ldy     #0
                lsr     $d019
                inc     0
                rti

colorTable:
.byt 09,08,12,13,01,13,12,08,09

sinusTable:
.byt 140,143,145,148,151,154,156,159,162,164,167,169,172,175,177,180,182,185,187,190
.byt 192,194,197,199,201,204,206,208,210,212,214,216,218,220,222,224,225,227,229,230
.byt 232,233,235,236,237,238,240,241,242,243,244,245,245,246,247,247,248,248,249,249
.byt 250,250,250,250,250,250,250,250,249,249,249,248,248,247,247,246,245,244,243,242
.byt 241,240,239,238,237,235,234,232,231,229,228,226,224,223,221,219,217,215,213,211
.byt 209,207,205,202,200,198,196,193,191,188,186,183,181,178,176,173,171,168,166,163
.byt 160,158,155,152,149,147,144,141,139,136,133,131,128,125,122,120,117,114,112,109
.byt 107,104,102,99,97,94,92,89,87,84,82,80,78,75,73,71,69,67,65,63
.byt 61,59,57,56,54,52,51,49,48,46,45,43,42,41,40,39,38,37,36,35
.byt 34,33,33,32,32,31,31,31,30,30,30,30,30,30,30,30,31,31,32,32
.byt 33,33,34,35,35,36,37,38,39,40,42,43,44,45,47,48,50,51,53,55
.byt 56,58,60,62,64,66,68,70,72,74,76,79,81,83,86,88,90,93,95,98
.byt 100,103,105,108,111,113,116,118,121,124,126,129,132,135,137,140
