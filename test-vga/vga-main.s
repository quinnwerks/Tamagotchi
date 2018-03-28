.equ ADDR_VGA, 0x08000000
.equ VGATIMER, 0xff202020
.equ SECOND, 50000000
.section .text
.global _start
_start:
# initalize devices
# initalize timer 2
movia r14, VGATIMER
stwio r0, 0(r14)
movui r10, %lo(SECOND)
stwio r10,  8(r14)
movui r10, %hi(SECOND)
stwio r10, 12(r14)



# FILL THIS WITH WORKING CODE


# start the timer
ldwio r15, 4(r14)
ori r15, r10, 0x4
stwio r15, 4(r14)




.section .exceptions, "ax"
myISR:
# store stuff in stack
# determine which interrput occured


addi ea, ea, -4
eret
