.equ UART, 0xFF201000
.equ PS2, 0xFF200100

.section .exceptions, "ax"
ISR:
addi sp, sp, -4
stw r16, 0(sp)

#keyboard interrupt, read the key stroke by press-release pattern
#read from ipending
rdctl et, ipending
andi et, 0x80
beq et, r0, exit

#something from keyboard, check if on release
addi sp, sp, -8
stw r2, 0(sp)
stw ra, 4(sp)

#exit if not break code 0xF0
call readPS2
movi et, 0xF0
beq r2, et, dealloc

#else read second bit and write to terminal
call readPS2
addi sp, sp, -4
stw r4, 0(sp)
mov r4, r2
call WriteUART
ldw r4, 0(sp)
addi sp, sp, 4

dealloc:
    ldw r2, 0(sp)
    ldw ra, 4(sp)
    addi sp, sp, 8

exit:
    ldw r16, 0(sp)
    addi sp, sp, 4
    addi ea, ea, -4
    eret

.section .text
.global _start
_start:
#init stack
movia sp, 0x03FFFFFC

#clear terminal
movi r4, 0x1b
call WriteUART
movi r4, 0x5b
call WriteUART
movi r4, 0x32
call WriteUART
movi r4, 0x4b 
call WriteUART
movi r4, 0x1b
call WriteUART
movi r4, 0x5b
call WriteUART
movi r4, 0x48
call WriteUART 

#init keyboard interrupt
movia r8, PS2
movi r9, 1
stwio r9, 4(r8)

#interrupt enable
movi r9, 0x80  #IRQ 7
wrctl ienable, r9
movi r9, 1
wrctl status, r9
 
#infinite loop
loop: br loop

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

#void WriteUART(char)
.global WriteUART
WriteUART:
addi sp, sp, -4
stw r16, 0(sp)

movia r16, UART
stwio r4, r16

ldw r16, 0(sp)
addi sp, sp, 4
ret
