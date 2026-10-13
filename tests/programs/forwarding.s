# Dependencies between neighboring instructions, no NOPs.
# expect: x1=5 x2=6 x3=7 x4=8 x5=13 x6=18 mem[0]=18

addi x1, x0, 5
addi x2, x1, 1       # x2 = 6   (forward EX/MEM -> EX)
addi x3, x1, 2       # x3 = 7   (forward MEM/WB -> EX)
addi x4, x1, 3       # x4 = 8   (register file written and read in the same cycle)
add  x5, x2, x3      # x5 = 13  (both operands forwarded)
add  x6, x5, x1      # x6 = 18
sw   x6, 0(x0)       # mem[0] = 18 (store data forwarded)
