.section .data
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ ADDR_END_VGA 0x08012C00
.equ red, 0xF100
.equ blue, 0x001F
.equ green, 0x07E0
.equ white, 0xFFFF
.equ yellow, 0xFFE0
.section .text
.global _start
_start:
  movia r2,ADDR_VGA
  movia r3, ADDR_CHAR
  movui r4,0xffff  /* White pixel */

  sthio r4,1032(r2) /* pixel (4,1) is x*2 + y*1024 so (8 + 1024 = 1032) */


  # ovia r3, ADDR_END_VGA
  # writeWhite:
  sthio r4, 1032(r2)
  # addi r2, r2, 1
  # ble r2, r3, writeWhite

  loop:
  br loop
