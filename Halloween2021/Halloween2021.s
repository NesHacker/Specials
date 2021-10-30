.segment "HEADER"
  .byte "NES", $1A  ; iNES header identifier
  .byte 2           ; 2x 16KB PRG code
  .byte 1           ; 1x  8KB CHR data
  .byte $00         ; Mirroring ($00 Horiz, $01 Vertical)
  .byte $00         ; Mapper 0

.segment "VECTORS"
  .addr nmi, main, 0

.segment "CHARS"
  .incbin "CHR-ROM.bin"

.segment "STARTUP"

.segment "CODE"

.include "../common/common.s"

.proc main
  BasicReset
: jmp :-
.endproc

.proc nmi
  rti
.endproc
