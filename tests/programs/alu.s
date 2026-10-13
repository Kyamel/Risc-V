# Every R-type ALU operation, no close dependencies.
# expect: x0=0 x3=-5 x4=11 x5=0 x6=-5 x7=-5 x8=24 x9=0x1fffffff x10=-1 x11=1 x12=0

addi x0, x0, 5       # writes to x0 are ignored
addi x1, x0, -8      # 0xfffffff8
addi x2, x0, 3
nop
nop
nop
add  x3, x1, x2      # -5
sub  x4, x2, x1      # 11
and  x5, x1, x2      # 0
or   x6, x1, x2      # -5
xor  x7, x1, x2      # -5
sll  x8, x2, x2      # 24
srl  x9, x1, x2      # 0x1fffffff
sra  x10, x1, x2     # -1
slt  x11, x1, x2     # 1
sltu x12, x1, x2     # 0
