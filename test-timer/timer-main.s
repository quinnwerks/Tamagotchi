.section .data
.equ TIMER1, 0xFF202000
.align 2
# globabl variables
HP:
.word 50
VGA_STATE:
.word 0

.section .text
.global _start
_start:

# initalize stack pointer
movia sp, 0x00FFFFFC

# initalize devices
# initalize timer 1
movia r8, TIMER1

# enable continue and interrupt r10 = (b11)
movi r10, 0x03
stwio r10, 4(r8)

# store time (r10 is now time = 1 second)
movui r10, 0xE100
stwio r10,  8(r8)
movui r10, 0x5F5
stwio r10, 12(r8)

# initalize keyboard interrupt ????


# configure CPU to interrupt
# r10 is now both irq line and PIE
movi r10, 1
wrctl ienable, r10
wrctl status, r10

#start the timer
ldwio r10, 4(r8)
ori r10, r10, 0x4
stwio r10, 4(r8)

# start loop
loop:
br loop

.section .exceptions, "ax"
myISR:
# store stuff in stack
# determine which interrput occured
call foodtimer

addi ea, ea, -4
eret
