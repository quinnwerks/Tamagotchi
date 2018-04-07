.global choosenext
choosenext:
# state table cheat sheet
/*
 0 = default frame 0
 1 = default frame 1
 3 = low hp frame 0
 4 = low hp frame 1
 */

addi sp, sp, -20
stw sp,  0(sp)
stw r16,  4(sp)
stw r17,  8(sp)
stw r18, 12(sp)
stw r19, 16(sp)




movia r16, PET_HP
ldw r19, (r16)
addi r19, r19, -50

movia r16, VGA_STATE
ldw r17, (r16)

movi r18, 5
# move to special state table if not in default loop
bge r17, r18, CHECK_SPECIAL
# else determine HP level
bge r19, r0, CHECK_DEFAULT
blt r19, r0, CHECK_DEFAULT_LOW

CHECK_DEFAULT:
movi r18, 0
beq r17, r18, SET_TO_ONE
br SET_TO_ZERO

CHECK_DEFAULT_LOW:
movi r18, 2
beq r17, r18, SET_LOW_THREE
br SET_LOW_TWO
CHECK_SPECIAL:
# states 5, 6, 7, 8, 9, 10, 11 are feed states
movi r18, 11
ble r17, r18, SET_FEED
bgt r17, r18, SET_PET
br SET_TO_ZERO

# #####################################################
SET_TO_ONE:
movi r18, 1
stw r18, 0(r16)
br DONE
SET_TO_ZERO:
stw r0, 0(r16)
br DONE
# ######################################################
SET_LOW_THREE:
movi r18, 3
stw r18, 0(r16)
br DONE
SET_LOW_TWO:
movi r18, 2
stw r18, 0(r16)
br DONE
# #######################################################
SET_FEED:
# load VGA state again
ldw r17, 0(r16)
movi r18, 11
# if state is less than 10 increment
blt r17, r18, INC_FEED
br SET_TO_ZERO
INC_FEED:
addi r17, r17, 1
stw r17, 0(r16)
br DONE
# #######################################################
SET_PET:
ldw r17, 0(r16)

movi r18, 19
bgt r17, r18, SET_TO_ZERO
beq r17, r18, SET_Y_N_HURT
# else increment
addi r17, r17,1
stw r17, 0 (r16)
br DONE
SET_Y_N_HURT:
movia r18, HURT
ldw r17, (r18)
beq r17, r0, SET_TWENTY

movi r18, 21
stw r18, 0(r16)
br DONE

SET_TWENTY:
movi r18, 20
stw r18, 0(r16)


br DONE

DONE:


# DEATH CHECK?
ldw sp,  0(sp)
ldw r16,  4(sp)
ldw r17,  8(sp)
ldw r18, 12(sp)
ldw r19, 16(sp)
addi sp, sp, 20


ret
