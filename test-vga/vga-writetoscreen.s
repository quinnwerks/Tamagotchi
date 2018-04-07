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
/*
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
*/


STARTWRTIE:
movia r16, VGA_STATE

# r17 is now vga_state
ldw r17, (r16)

# state stable, to load to memory
beq r17, r0, NORM_0
addi r17, r17, -1

beq r17, r0, NORM_1
addi r17, r17, -1

beq r17, r0, LOW_2
addi r17, r17, -1

beq r17, r0, LOW_3
addi r17, r17, -1

beq r17, r0, DEATH_4
addi r17, r17, -1

beq r17, r0, FEED_5
addi r17, r17, -1

beq r17, r0, FEED_6
addi r17, r17, -1

beq r17, r0, FEED_7
addi r17, r17, -1

beq r17, r0, FEED_8
addi r17, r17, -1

beq r17, r0, FEED_9
addi r17, r17, -1

beq r17, r0, FEED_10
addi r17, r17, -1

beq r17, r0, FEED_11
addi r17, r17, -1

beq r17, r0, PET_12
addi r17, r17, -1

beq r17, r0, PET_13
addi r17, r17, -1

beq r17, r0, PET_14
addi r17, r17, -1

beq r17, r0, PET_15
addi r17, r17, -1

beq r17, r0, PET_16
addi r17, r17, -1

beq r17, r0, PET_17
addi r17, r17, -1

beq r17, r0, PET_18
addi r17, r17, -1

beq r17, r0, PET_19
addi r17, r17, -1

beq r17, r0, PET_20
addi r17, r17, -1

beq r17, r0, PET_21
addi r17, r17, -1

br NORM_0

NORM_0:
movia r17, IMAGE0
br WRITE_SCREEN
NORM_1:
movia r17, IMAGE1
br WRITE_SCREEN
LOW_2:
movia r17, IMAGE2
br WRITE_SCREEN
LOW_3:
movia r17, IMAGE3
br WRITE_SCREEN
DEATH_4:
movia r17, IMAGE0
br WRITE_SCREEN
FEED_5:
movia r17, FEED0
br WRITE_SCREEN
FEED_6:
movia r17, FEED1
br WRITE_SCREEN
FEED_7:
movia r17, FEED2
br WRITE_SCREEN
FEED_8:
movia r17, FEED3
br WRITE_SCREEN
FEED_9:
movia r17, FEED4
br WRITE_SCREEN
FEED_10:
movia r17, FEED5
br WRITE_SCREEN
FEED_11:
movia r17, FEED6
br WRITE_SCREEN
PET_12:
movia r17, PET0
br WRITE_SCREEN
PET_13:
movia r17, PET1
br WRITE_SCREEN
PET_14:
movia r17, PET2
br WRITE_SCREEN
PET_15:
movia r17, PET3
br WRITE_SCREEN
PET_16:
movia r17, PET4
br WRITE_SCREEN
PET_17:
movia r17, PET5
br WRITE_SCREEN
PET_18:
movia r17, PET6
br WRITE_SCREEN
PET_19:
movia r17, PET7
br WRITE_SCREEN
PET_20:
movia r17, PET9
br WRITE_SCREEN
PET_21:
movia r17, PET8
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
