# Taken bne, no data dependencies (NOPs before the branch).
# The two instructions after the branch must have no effect.
# expect: x1=5 x2=4 x3=0 x4=0 x5=10

addi x1, x0, 5
addi x2, x0, 4
nop
nop
nop
bne  x1, x2, TARGET  # 5 != 4: taken
addi x3, x0, 1       # skipped
addi x4, x0, 1       # skipped
TARGET:
add  x5, x1, x1      # x5 = 10
