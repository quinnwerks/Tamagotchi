.section .text
.label _start
_start:
    # initalize stack pointer
    movi sp, sp, 0x00FFFFFC

    # initalize devices
    # initalize timer
    # start loop
    loop:
    br loop
