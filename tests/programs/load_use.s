# An instruction right after a lw uses the loaded value: needs 1 stall cycle.
# expect: x1=42 x2=42 x3=43 x4=42 mem[8]=42 mem[12]=42

addi x1, x0, 42
sw   x1, 8(x0)
lw   x2, 8(x0)
addi x3, x2, 1       # x3 = 43 (load-use)
lw   x4, 8(x0)
sw   x4, 12(x0)      # store of the value just loaded
