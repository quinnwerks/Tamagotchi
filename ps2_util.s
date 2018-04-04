.equ PS2, 0xFF200100

.section .text
#char readPS2(void)
.global readPS2
readPS2:
addi sp, sp, -4
stw r16, 0(sp)

movia r16, PS2
ldwio r2, 0(r16)
andi r2, r2, 0xFF

ldw r16, 0(sp)
addi sp, sp, 4 
ret
