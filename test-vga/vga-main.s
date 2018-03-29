# address's used
.section .data
.equ ADDR_VGA, 0x08000000
.equ VGATIMER, 0xff202020
.equ SECOND, 50000000
# global variables
.section .data
.align 2
VGA_STATE:
.word 3

.section .text
.global _start
_start:
# initalize devices
# initalize timer 2
# r14 is reserved for VGATIMER
movia r14, VGATIMER
stwio r0, 0(r14)
movui r10, %lo(SECOND)
stwio r10,  8(r14)
movui r10, %hi(SECOND)
stwio r10, 12(r14)

# set initial vga state to zero
movia r9, VGA_STATE
movi  r8, 0
stw r8, 0(r9)







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

# timer has now ended determine next state
# load VGA STATE


# STATE table




# timer has ended determine next statte
# if current state is 1
# set to 2
# if current state is 2
# set to 1
# else interrupt has taken care of memory
# store state in memory




.section .exceptions, "ax"
myISR:
# store stuff in stack
# determine which interrput occured


# set timer count to zero to end animation\

addi ea, ea, -4
eret
