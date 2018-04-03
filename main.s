.section .exceptions, "ax"
ISR:
	addi sp, sp, -8
	stw r16, 0(sp)
	stw r17, 4(sp)
	rdctl et, ipending
	andi et, et, 0b1
	bne et, r0, LoseHP
	br exit

LoseHP:
	movia r17, PET_HP
	ldw r16, 0(r17)
	subi r16, r16, 10
	stw r16, 0(r17)

	#reset timer
	movia r17, HPTIMER
	stwio r0, 0(r17)

exit:
	ldw r16, 0(sp)
	ldw r17, 4(sp)
	addi sp, sp, 8
	addi ea, ea, 4
	eret

# global variables and address's used
.section .data
.equ ADDR_VGA, 0x08000000
.equ VGATIMER, 0xff202020
.equ HPTIMER, 0xff202000
.equ SECOND, 50000000
.equ FIVE, 500000000

.align 2
IMAGE0:
.incbin "frame0.bin"

IMAGE1:
.incbin "frame1.bin"

IMAGE2:
.incbin "frame2.bin"

IMAGE3:
.incbin "frame3.bin"

.align 2
VGA_STATE:
 .word 0
PET_HP:
.word 50

.section .text
.global _start
_start:
# stack
movia sp, 0x03FFFFFC

#VGA Timer 2
movia r14, VGATIMER
stwio r0, 0(r14)
movui r10, %lo(SECOND)
stwio r10,  8(r14)
movui r10, %hi(SECOND)
stwio r10, 12(r14)

#HP timer 1
movia r8, HPTIMER
stwio r0, 0(r8)
movui r10, %lo(FIVE)
stwio r10, 8(r8)
movui r10, %hi(FIVE)
stwio r10, 12(r8)
movi r10, 0b111
stwio r10, 4(r8)

#set timer 1 interrupt
movi r10, 0b1
wrctl ienable, r10
wrctl status, r10

# set initial vga state to zero
movia r9, VGA_STATE
movi  r8, 0
stw r8, 0(r9)

loop:
# load the image
call getToScreen
# start the timer
ldwio r15, 4(r14)
ori r15, r10, 0x4
stwio r15, 4(r14)

# poll the vga timer (creates a SECOND delay)
pollVGA:
ldwio r15, (r14)
andi r15, r15, 1
beq r0, r15, pollVGA

call choosenext

stwio r0, 0(r14)
br loop

.global choosenext
choosenext:
# state table cheat sheet
/*
 0 = default frame 0
 1 = default frame 1
 3 = low hp frame 0
 4 = low hp frame 1
 */

addi sp, sp, -20
stw sp,  0(sp)
stw r16,  4(sp)
stw r17,  8(sp)
stw r18, 12(sp)
stw r19, 16(sp)

movia r16, PET_HP
ldw r19, (r16)
addi r19, r19, -50

movia r16, VGA_STATE
ldw r17, (r16)

movi r18, 5
# move to special state table if not in default loop
bge r17, r18, CHECK_SPECIAL
# else determine HP level
bge r19, r0, CHECK_DEFAULT
blt r19, r0, CHECK_DEFAULT_LOW

CHECK_DEFAULT:
movi r18, 0
beq r17, r18, SET_TO_ONE
br SET_TO_ZERO

CHECK_DEFAULT_LOW:
movi r18, 2
beq r17, r18, SET_LOW_THREE
br SET_LOW_TWO
CHECK_SPECIAL:
br SET_TO_ONE

# #####################################################
SET_TO_ONE:
movi r18, 1
stw r18, 0(r16)
br DONE
SET_TO_ZERO:
stw r0, 0(r16)
br DONE
# ######################################################
SET_LOW_THREE:
movi r18, 3
stw r18, 0(r16)
br DONE
SET_LOW_TWO:
movi r18, 2
stw r18, 0(r16)
br DONE
# #######################################################
SET_FEED:
br DONE
# #######################################################
DONE:

# DEATH CHECK?
ldw sp,  0(sp)
ldw r16,  4(sp)
ldw r17,  8(sp)
ldw r18, 12(sp)
ldw r19, 16(sp)
addi sp, sp, 20


ret

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

beq r17, r0, PET_4
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
