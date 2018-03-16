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
movia sp, sp, 0x00FFFFFC



# start loop
loop:
br loop


.section .exceptions, "ax"
myISR:
# store stuff in stack
# determine which interrput occured


addi ea, ea, -4
eret
