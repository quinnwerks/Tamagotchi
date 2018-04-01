.equ UART, 0xFF201000
.equ ADC, 0xFF204000
.equ TIMER, 0xFF202000
.equ time, 0x02FAF080

.section .text
.global _start
_start:
#init stack
movia sp, 0x03FFFFFC
mov r11, r0

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

#init ADC auto update
movia r9, ADC
movi r8, 1
stwio r8, 4(r9)

#init timer
movia r9, TIMER
movui r8, %lo(time)
stwio r8, 8(r9)
movui r8, %hi(time)
stwio r8, 12(r9)

stwio r0, 0(r9)
movi r8, 0b100
stwio r8, 4(r9)
 
#poll timer
loop: 
    ldwio r8, 0(r9)
    andi r8, r8, 1
    beq r8, zero, loop

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

    #read from ADC and print
    movia r10, ADC
    ldwio r11, 0(r10)
    mov r4, r11
    call WriteADC
  
    #reset timer
	movia r9 ,TIMER
    stwio r0, 0(r9)
	movi r8, 0b100
	stwio r8, 4(r9)
    br loop  

#void WriteUART(char)
.global WriteUART
WriteUART:
addi sp, sp, -4
stw r16, 0(sp)

movia r16, UART
stwio r4, 0(r16)

ldw r16, 0(sp)
addi sp, sp, 4
ret

#void WriteADC(int)
.global WriteADC
WriteADC:
    addi sp, sp, -8
    stw r16, 0(sp)
    stw ra, 4(sp)
    
    #print bit 11 to 8
    mov r16, r4
    andi r4, r16, 0xF00
	srli r4, r4, 8
    call WriteHex

    #bit 7 to 4
    andi r4, r16, 0xF0
	srli r4, r4, 4
    call WriteHex
    
    #bit 3 to 0
    andi r4, r16, 0xF
    call WriteHex

    ldw ra, 4(sp)
    ldw r16, 0(sp)
    addi sp, sp, 8
    ret

#void WriteHex(int)
.global WriteHex
WriteHex:
	addi sp, sp, -8
	stw r16, 0(sp)
	stw ra, 4(sp)

	#convert this number to ascii
	movi r16, 0xA
	blt r4, r16, LESS_THAN_A

	MORE_THAN_A:
		addi r4, r4, 55
		br print

	LESS_THAN_A:
		addi r4, r4, 48
	
	print:
		call WriteUART
	
	ldw r16, 0(sp)
	ldw ra, 4(sp)
	addi sp, sp, 8
	ret

