; NES Power-on Reset Macros

; Waits for the next Vblank by testing the 7th bit of $2002.
.macro VblankWait
: bit $2002
  bpl :-
.endmacro

; Clears All System RAM ($0000 - $07FF)
.macro ClearRAM
  lda #0
: sta $000,x
  sta $100,x
  sta $200,x
  sta $300,x
  sta $400,x
  sta $500,x
  sta $600,x
  sta $700,x
  inx
  bne :-
.endmacro

; Performs a standard NES power-on reset.
.macro PowerOnReset
  sei        ; ignore IRQs
  cld        ; disable decimal mode
  ldx #$40
  stx $4017  ; disable APU frame IRQ
  ldx #$ff
  txs        ; Set up stack
  inx        ; now X = 0
  stx $2000  ; disable NMI
  stx $2001  ; disable rendering
  stx $4010  ; disable DMC IRQs
  bit $2002
.endmacro

; Performs a full basic NES reset procedure. Adapt this code to create
; specialized reset routines for games as needed.
.macro BasicReset
  PowerOnReset
  VblankWait
  ClearRAM
  VblankWait
.endmacro
