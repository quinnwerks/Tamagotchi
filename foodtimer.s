.section .text
.global foodtimer
# this subroutine decreases the value of the global variable food
# this represents the pet becoming more hungry with time
addi sp, sp, -12
stw r20, 0(sp)
stw r21, 4(sp)
stw r22, 8(sp)


# r20 = hp value
# r21 = timer address
# r22 = hp address
movia r21, TIMER1
movia r22, HP

# get HP from mem
ldw r20, (r22)

# make the pet more hungry
addi r20, r20, -1
# store new value in HP
stw r20, r22

ldw r20, 0(sp)
ldw r21, 4(sp)
ldw r22, 8(sp)
addi sp, sp, 12

ret
