# Hazards combined with branches and jumps.
# expect: x2=3 x3=0 x4=24 x5=24 x6=25

addi x1, x0, 3
sw   x1, 0(x0)
lw   x2, 0(x0)
beq  x2, x1, OK      # branch uses the loaded value (stall + forward)
addi x3, x0, 99      # skipped
OK:
jal  x4, F           # x4 = 24
addi x5, x4, 0       # after returning: x5 = 24
beq  x0, x0, END
F:
addi x6, x4, 1       # uses the link right after the jal: x6 = 25
jalr x0, 0(x4)
END:
