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
.include "palettes.s"
.include "sprites.s"

SLIME = $04
PUMPKIN = $0C
GHOST = $14

.scope SpriteTimer
  FRAMES = 12
  timer = $60
  offset = $61
.endscope

.scope Ghost
  FRAMES = 2
  MAX_X = 180
  MIN_X = 60
  timer = $62
  xPos = $63
  dx = $64
.endscope

.proc main
  BasicReset
  LoadPalettes palettes
  jsr LoadSprites

  lda #SpriteTimer::FRAMES
  sta SpriteTimer::timer
  lda #0
  sta SpriteTimer::offset

  lda #Ghost::FRAMES
  sta Ghost::timer
  lda #120
  sta Ghost::xPos
  lda #0
  sta Ghost::dx

  EnableRendering
  EnableNMI
: jmp :-
.endproc

.proc nmi
  jsr updateSprites
  jsr updateGhost
  lda #$02
  sta OAM_DMA
  VramReset
  rti
.endproc

.proc LoadSprites
  ldx #0
: lda sprites, x
  sta $0200, x
  inx
  bne :-
  rts
.endproc

.proc updateSprites
  dec SpriteTimer::timer
  beq :+
  rts
: lda #SpriteTimer::FRAMES
  sta SpriteTimer::timer
  lda #%00000100
  eor SpriteTimer::offset
  sta SpriteTimer::offset
  ; Update slime frames
  clc
  adc #SLIME
  tax
  .repeat 4, K
    stx $210 + (4*K) + 1
    stx $220 + (4*K) + 1
    stx $230 + (4*K) + 1
    stx $240 + (4*K) + 1
    inx
  .endrep
  ; Update Pumpkin Frames
  lda SpriteTimer::offset
  clc
  adc #PUMPKIN
  tax
  .repeat 4, K
    stx $250 + (4*K) + 1
    stx $260 + (4*K) + 1
    stx $270 + (4*K) + 1
    stx $280 + (4*K) + 1
    inx
  .endrep
  ; Update Ghost Frames
  lda SpriteTimer::offset
  clc
  adc #GHOST
  tax
  .repeat 4, K
    stx $290 + (4*K) + 1
    inx
  .endrep
  rts
.endproc

.proc updateGhost
  dec Ghost::timer
  beq :+
  rts
: lda #Ghost::FRAMES
  sta Ghost::timer
  lda Ghost::dx
  bne @right
@left:
  dec Ghost::xPos
  lda Ghost::xPos
  cmp #Ghost::MIN_X
  beq @reverse
  bne @updatePosition
@right:
  inc Ghost::xPos
  lda Ghost::xPos
  cmp #Ghost::MAX_X
  bne @updatePosition
@reverse:
  lda #1
  eor Ghost::dx
  sta Ghost::dx
@updatePosition:
  lda Ghost::xPos
  sta $290 + 3
  sta $290 + $08 + 3
  clc
  adc #8
  sta $290 + $04 + 3
  sta $290 + $0C + 3
  rts
.endproc
