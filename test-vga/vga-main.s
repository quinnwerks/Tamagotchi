# global variables and address's used
.section .data
.equ ADDR_VGA, 0x08000000
.equ VGATIMER, 0xff202020
.equ SECOND, 50000000

.align 2
IMAGE0:
.incbin "frame0.bin"

IMAGE1:
.incbin "test.bin"

.align 2
VGA_STATE:
 .word 0


.section .text
.global _start
_start:
.section .text
.global _start
_start:
movia sp, 0x03FFFFFC
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
