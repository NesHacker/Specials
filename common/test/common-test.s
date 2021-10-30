.segment "HEADER"
  .byte $4E, $45, $53, $1A  ; iNES header identifier
  .byte 2                   ; 2x 16KB PRG-ROM Banks
  .byte 1                   ; 1x  8KB CHR-ROM
  .byte $01, $00            ; mapper 0, vertical mirroring

.segment "VECTORS"
  .addr nmi
  .addr reset
  .addr 0

.segment "STARTUP"

.segment "CHARS"
  .incbin "CHR-ROM.bin"

.segment "CODE"

.include "../frame.s"
.include "../joypad.s"
.include "../ppu.s"
.include "../reset.s"

.proc nmi
  IncFrame
  ReadJoypads

  LdaFrameMod128
  bne :+
  inc $00
: lda $00
  and #%0000011
  sta $00

  VramReset
  rti
.endproc

.proc reset
  BasicReset
  LoadPalettes palettes
  EnableNMI
  EnableRendering
main:
  jmp main
.endproc

palettes:
  .byte $0C, $14, $23, $37
  .byte $0F, $1C, $2B, $39
  .byte $0F, $00, $10, $30
  .byte $0F, $00, $30, $10
  .byte $0C, $14, $23, $37
  .byte $0F, $1C, $2B, $39
  .byte $0F, $00, $10, $30
  .byte $0F, $00, $30, $10
