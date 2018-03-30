.section .text
.global choosenext
choosenext:

addi sp, sp, -16
stw sp,  0(sp)
stw r16,  4(sp)
stw r17,  8(sp)
stw r18, 12(sp)
# STATE table
movia r16, VGA_STATE
ldw r17, (r16)
movi r18, 1

beq r0, r17, SET_TO_ONE
beq r18, r17, SET_TO_ZERO

SET_TO_ONE:
stw r18, 0(r16)
br DONE

SET_TO_ZERO:
stw r0, 0(r16)
br DONE

DONE:

# DEATH CHECK?
ldw sp,  0(sp)
ldw r16,  4(sp)
ldw r17,  8(sp)
ldw r18, 12(sp)
addi sp, sp, 16

ret
