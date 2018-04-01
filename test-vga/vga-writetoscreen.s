.section .data
.equ ADDR_VGA, 0x08000000
.equ VGATIMER, 0xff202020
.equ SECOND, 50000000


IMAGE0:
.incbin "frame0.bin"

IMAGE1:
.incbin "test.bin"

.align 2
VGA_STATE:
 .word 2


# sets image based on vga statte
.global getToScreen
getToScreen:
addi sp, sp, -24
stw ra,   0(sp)
stw r16,  4(sp)
stw r17,  8(sp)
stw r18,  12(sp)
stw r19,  16(sp)
stw r20,  20(sp)

mov r17, r0
movia r16, ADDR_VGA
movia r18, 0x25800
add r19, r17, r18

# clear VGA
CLEAR_LOOP:
sthio r0, (r16)
addi r16, r16, 2
addi r17, r17, 2
srli r19, r16, 1
andi r19, r19, 0x1FF

movi r20, 320
blt r19, r20, CLEAR_LOOP
slli r19, r19, 1
sub r16, r16, r19
addi r16, r16, 0x400

srli r19, r16, 10
andi r19, r19 , 0xFF
movi r20, 240
blt r19, r20 , CLEAR_LOOP



STARTWRTIE:
movia r16, VGA_STATE

# r17 is now vga_state
ldw r17, (r16)

# state stable, to load to memory
beq r17, r0, NORM_0
addi r17, r17, -1

beq r17, r0, NORM_1
addi r17, r17, -1

beq r17, r0, FEED_2
addi r17, r17, -1

beq r17, r0, PET_3
addi r17, r17, -1

beq r17, r0, PET_4
br NORM_0

NORM_0:
movia r17, IMAGE0
br WRITE_SCREEN
NORM_1:
movia r17, IMAGE1
br WRITE_SCREEN
FEED_2:
movia r17, IMAGE0
br WRITE_SCREEN
PET_3:
movia r17, IMAGE0
br WRITE_SCREEN
PET_4:
movia r17, IMAGE0
br WRITE_SCREEN

# Now the address is found load the image, pixel by pixel onto the screen
WRITE_SCREEN:


movia r16, ADDR_VGA

# clear VGA
WRITE_LOOP:
ldh   r18, (r17)
sthio r18, (r16)
addi r16, r16, 2
addi r17, r17, 2
srli r19, r16, 1
andi r19, r19, 0x1FF

movi r20, 320
blt r19, r20, WRITE_LOOP
slli r19, r19, 1
sub r16, r16, r19
addi r16, r16, 0x400

srli r19, r16, 10
andi r19, r19 , 0xFF
movi r20, 240
blt r19, r20 , WRITE_LOOP

RETURN:
# return and restore stack
ldw ra,   0(sp)
ldw r16,  4(sp)
ldw r17,  8(sp)
ldw r18,  12(sp)
ldw r19,  16(sp)
ldw r20,  20(sp)
addi sp, sp, 24

ret
