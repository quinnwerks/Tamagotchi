# global variables and address's used
.section .data
.equ ADDR_VGA, 0x08000000
.equ VGATIMER, 0xff202020
.equ SECOND, 50000000

.align 2
IMAGE0:
.incbin "frame0.bin"

IMAGE1:
.incbin "frame1.bin"

IMAGE2:
.incbin "frame2.bin"

IMAGE3:
.incbin "frame3.bin"

FEED0:
.incbin "feed0.bin"

FEED1:
.incbin "feed1.bin"

FEED2:
.incbin "feed2.bin"

FEED3:
.incbin "feed3.bin"

FEED4:
.incbin "feed4.bin"

FEED5:
.incbin "feed5.bin"

FEED6:
.incbin "feed6.bin"


PET0:
.incbin "pet0.bin"

PET1:
.incbin "pet1.bin"

PET2:
.incbin "pet2.bin"

PET3:
.incbin "pet3.bin"

PET4:
.incbin "pet4.bin"

PET5:
.incbin "pet5.bin"

PET6:
.incbin "pet6.bin"

PET7:
.incbin "pet7.bin"

PET8:
.incbin "pet8.bin"

PET9:
.incbin "pet9.bin"

PREPET0:
.incbin "prepet0.bin"



.align 2
VGA_STATE:
 .word 0
PET_HP:
.word 100

PS2_BREAK:
.word 0

HURT:
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

#init HP
movia r8, PET_HP
movi r9, 40
stw r9, (r8)

#init hurt
movia r8, HURT
movi r9, 1
stw r0, 0(r8)

# set initial vga state to zero
movia r9, VGA_STATE
movi  r8, 12
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
