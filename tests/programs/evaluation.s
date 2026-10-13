# The course's evaluation program: forwarding, load-use, sub and beq.
# expect: x1=7 x2=7 mem[0]=7 mem[4]=7

# Put the base value in memory
addi x2, x0, 7
sw x2, 4(x0)
lw x1, 4(x0)
add x2, x1, x0
add x1, x1, x2
add x1, x1, x2
sub x1, x1, x2
sub x1, x1, x2
beq x1, x2, EXIT
# If execution gets here, the processor is wrong
add x1, x1, x1
sw x1, 0(x0)
EXIT:
and x1, x1, x2
or x1, x1, x0
sw x1, 0(x0)
