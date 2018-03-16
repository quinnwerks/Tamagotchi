.section .text
.global _start
_start:
.section .data

# SDRAM memory locations. Each will be the same memory size as the Front Buffer

 .equ VGA_Back_Buffer1, 0x01000000
 .equ VGA_End_Back1, 0x0103FFFF

 .equ VGA_Back_Buffer2, 0x02000000
 .equ VGA_End_Back2, 0x0203FFFF

 .equ VGA_Back_Buffer3, 0x03000000
 .equ VGA_End_Back3, 0x0303FFFF
# colour values for the Pixel buffer

 .equ red, 0xF100
 .equ blue, 0x001F
 .equ green, 0x07E0
 .equ white, 0xFFFF
 .equ yellow, 0xFFE0
.section .text
.global _start
_start:
.equ ADDR_Front_Buffer, 0xFF203020
.equ ADDR_Slider_Switches, 0xFF200040


# Fill back buffer1 memory locations with the colour red

 movia r2, red
 movia r3, VGA_Back_Buffer1
 movia r4, VGA_End_Back1

# counter to increment through each back buffer1 memory location until 256k locations have been filled with red Pixel value

 count1:
  sth r2, 0(r3)
  addi r3,r3,2
  ble r3,r4, count1
# Fill back buffer2 memory locations with the colour blue
 movia r2, blue
 movia r3, VGA_Back_Buffer2
 movia r4, VGA_End_Back2

# counter to increment through each back buffer2 memory location until 256k locations have been filled with blue Pixel value

 count2:
  sth r2, 0(r3)
  addi r3,r3,2
  ble r3,r4, count2

# load pointer for Back Buffer1

  movia r5, ADDR_Front_Buffer
  movia r3, VGA_Back_Buffer1
  stwio r3, 4(r5) 	# set start location of back buffer1
  movi  r6, 1
  stwio r4, 0(r5)       # Enable double buffering

# wait for swap to be complete but waiting for status bit to go active low

  swapcheck:
  ldwio r3, 12(r5)  # load status bit
  andi r3, r3, 1
  beq r3,r6, swapcheck

# load pointer for Back Buffer2

  movia r3, VGA_Back_Buffer2
  stwio r3, 4(r5) 	# set start location of Back Buffer2

# check slider switch

  movia r2,  ADDR_Slider_Switches
  mov r4, r0

 check:
  ldwio r3, 0(r2)
  andi r3,r3, 1
  beq  r3, r4, check
  mov r4, r3    # save switch setting

# swap back buffers

 stwio r6, 0(r5)

# wait for status bit to go low. This indicates that the pointer is properly set

 swapcheck2:
  ldwio r3, 12(r5)  # load status bit
  andi r3, r3, 1
  beq r3,r6, swapcheck2

 br check

endloop:
br endloop
