.equ ADDR_VGA, 0x08000000
.equ VGATIMER, 0xff202020
.equ red, 0xF100
.equ blue, 0x001F
.equ green, 0x07E0
.equ white, 0xFFFF
.equ yellow, 0xFFE0
.section .data
.align 2
VGA_STATE:
.word 3
VGA_STATE_OLD:
.word -1
.section .text
.global _start
_start:
  movia r8,ADDR_VGA

  movia r10, VGA_STATE
  movia r12, VGA_STATE_OLD



loadNewState:
  ldw r11, 0(r10)

  beq r0, r11, wrRed # state is 0
  addi r11, r11, -1
  beq r0, r11, wrBlue #state is 1
  addi r11, r11, -1
  beq r0, r11, wrGreen #state is 2
  addi r11, r11, -1
  beq r0, r11, wrWhite #state is 3
  br wrYellow

wrRed:
  movui r9, red
  br writePixel
wrBlue:
  movui r9, blue
  addi r11, r11, 1
  br writePixel
wrGreen:
  movui r9, green
  addi r11, r11, 2
  br writePixel
wrWhite:
  movui r9, white
  addi r11, r11, 3
  br writePixel
wrYellow:
  movui r9, yellow
  movi r11, -2
  br writePixel

writePixel:
  sthio r9,1032(r8) /* pixel (4,1) is x*2 + y*1024 so (8 + 1024 = 1032) */

holdState:
  stw r11, (r12)
  ldw r13, (r10)
  beq r11, r13, holdState

  br loadNewState

  loop:
  br loop
