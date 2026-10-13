# Every branch type, taken and not taken.
# If a branch misbehaves, the next instruction writes 99 to that case's register.
# expect: x10=0 x11=0 x12=0 x13=0 x14=0 x15=0 x8=1 x9=0
# cycles: 300

addi x1, x0, -1
addi x2, x0, 1
nop
nop
nop
# Must be taken
beq  x1, x1, B1
addi x10, x0, 99
B1:
bne  x1, x2, B2
addi x11, x0, 99
B2:
blt  x1, x2, B3      # -1 < 1 (signed)
addi x12, x0, 99
B3:
bge  x2, x1, B4
addi x13, x0, 99
B4:
bltu x2, x1, B5      # 1 < 0xffffffff (unsigned)
addi x14, x0, 99
B5:
bgeu x1, x2, B6
addi x15, x0, 99
B6:
# Must not be taken
beq  x1, x2, FAIL
bne  x1, x1, FAIL
blt  x2, x1, FAIL
bge  x1, x2, FAIL
bltu x1, x2, FAIL
bgeu x2, x1, FAIL
addi x8, x0, 1
beq  x0, x0, END
FAIL:
addi x9, x0, 99
END:
