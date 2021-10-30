.macro JumpTable tableIndex, lowBytes, highBytes
  ldx tableIndex
  lda lowBytes, x
  sta $00
  lda highBytes, x
  sta $01
  jmp ($0000)
.endmacro
