# sets image based on vga statte
.section .text
.global writeToScreen
getToScreen:
addi sp, sp, -20
stw ra,   0(sp)
stw r16,  4(sp)
stw r17,  8(sp)
stw r18,  12(sp)
stw r19,  16(sp)

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
movia r17,
br WRITE_SCREEN
NORM_1:
movia r17,
br WRITE_SCREEN
FEED_2:
movia r17,
br WRITE_SCREEN
PET_3:
movia r17,
br WRITE_SCREEN
PET_4:
movia r17,
br WRITE_SCREEN

# Now the address is found load the image, pixel by pixel onto the screen
WRITE_SCREEN:

movia r16, ADDR_VGA
addi r19, r17, 0x3FFF

# iterate through each pixel (16 bits each = 2 bytes = 1 half word)

WRITE_LOOP:
beq r19, r17, RETURN

ldh r18, (r17)
sthio r18, (r4)
addi r17, r17, 2
addi r16, r16, 2

br WRITE_LOOP




RETURN:
# return and restore stack
ldw ra,   0(sp)
ldw r16,  4(sp)
ldw r17,  8(sp)
ldw r18,  12(sp)
ldw r19,  16(sp)
addi sp, sp, 20

ret
