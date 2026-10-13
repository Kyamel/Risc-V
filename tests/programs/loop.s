# Loop: adds 5 + 4 + 3 + 2 + 1 with a backward branch.
# expect: x1=15 x2=0 x3=1
# cycles: 300

addi x1, x0, 0       # sum
addi x2, x0, 5       # counter
LOOP:
add  x1, x1, x2
addi x2, x2, -1
bne  x2, x0, LOOP
addi x3, x0, 1       # only after leaving the loop
