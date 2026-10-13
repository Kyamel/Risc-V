# Function call and return with jal/jalr.
# expect: x1=8 x10=6 x11=6

addi x10, x0, 3
jal  x1, DOUBLE      # x1 = 8 (return address)
addi x11, x10, 0     # runs after returning: x11 = 6
beq  x0, x0, END
DOUBLE:
add  x10, x10, x10
jalr x0, 0(x1)       # return
END:
