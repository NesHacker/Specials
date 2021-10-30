; Constants and Macros for the Frame Counter
;
; The counter can be used to quickly create timers modulo powers of two for
; easy creation of animation loops and cycles of any sort. Further, the 16-bit
; precision of the timer allows for resetting random seeds and handling other
; effects that require high levels of precision or duration.

FRAME_LOW = $22
FRAME_HIGH = $23

; Increments the current frame count.
.macro IncFrame
  inc FRAME_LOW
  bne :+
  inc FRAME_HIGH
:
.endmacro

.macro LdaFrameMod2
  lda FRAME_LOW
  and #%00000001
.endmacro

.macro LdaFrameMod4
  lda FRAME_LOW
  and #%00000011
.endmacro

.macro LdaFrameMod8
  lda FRAME_LOW
  and #%00000111
.endmacro

.macro LdaFrameMod16
  lda FRAME_LOW
  and #%00001111
.endmacro

.macro LdaFrameMod32
  lda FRAME_LOW
  and #%00011111
.endmacro

.macro LdaFrameMod64
  lda FRAME_LOW
  and #%00111111
.endmacro

.macro LdaFrameMod128
  lda FRAME_LOW
  and #%01111111
.endmacro
