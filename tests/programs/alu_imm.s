# Every I-type ALU operation, no close dependencies.
# expect: x3=8 x4=19 x5=-4 x6=48 x7=15 x8=-4 x9=1 x10=1

addi x1, x0, -8      # 0xfffffff8
addi x2, x0, 3
nop
nop
nop
andi x3, x1, 15      # 8
ori  x4, x2, 16      # 19
xori x5, x2, -1      # -4
slli x6, x2, 4       # 48
srli x7, x1, 28      # 15
srai x8, x1, 1       # -4
slti x9, x1, 0       # 1
sltiu x10, x2, 4     # 1
