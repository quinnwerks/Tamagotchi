.section .data
.equ TIMER1, 0xFF202000
.align 2
# globabl variables
FOOD:
.word 0
VGA_STATE:
.word 0


.section .text
.global _start
_start:

# initalize stack pointer
movi sp, sp, 0x00FFFFFC

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

# initalize keyboard interrput ????








# start loop
loop:
br loop
