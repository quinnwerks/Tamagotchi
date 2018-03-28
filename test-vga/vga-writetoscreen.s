# sets image based on vga statte
.section .text
.global writeToScreen
getToScreen:
addi sp, sp, 16
stw ra,   0(sp)
stw r16,  4(sp)
stw r17,  8(sp)
stw r18,  12(sp)

movia r16, VGA_STATE

# r17 is now vga_state
ldw r17, (r16)

# state stable, to load to memory
beq r17, r0, NORM_0
addi r17, r17, -1

beq r17, r0, NORM_1
addi r17, r17, -1

beq r17, r0, FEED_2
addi r17, r17, -1

beq r17, r0, PET_3
addi r17, r17, -1

beq r17, r0, PET_4
br NORM_0

NORM_0:
movia r17,
br DONE
NORM_1:
movia r17,
br DONE
FEED_2:
movia r17,
br DONE
PET_3:
movia r17,
br DONE
PET_4:
movia r17,
br DONE

# Now the address is found load the image, pixel by pixel onto the screen
DONE:




# return and restore stack
ldw ra,   0(sp)
ldw r16,  4(sp)
ldw r17,  8(sp)
ldw r18,  12(sp)
addi sp, sp, 16

ret
