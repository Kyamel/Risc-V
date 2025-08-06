addi x1, x0, 5          # x1 = 5
addi x2, x0, 3          # x2 = 5
nop
nop
bne  x1, x2, 8          # Salta 4 instruções (16 bytes) se x1 != x2
add x3, x1, x2          # x3 = 7