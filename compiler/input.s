addi x1, x0, 5          # x1 = 5
addi x2, x0, 4          # x2 = 5
nop
nop
bne  x1, x2, 4          # Salta 4 instruções (16 bytes) se x1 != x2
addi x3, x0, 1          # x2 = 1
#jal  x0, -4             # volta para o bne
#addi x4, x0, 3          # x4 = 0, pois eh saltado
#add x6, x1, x2          # x6 = 6
add  x5, x1, x1         # x5 = 10