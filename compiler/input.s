addi x1, x0, 127      # imediato positivo
addi x5, x2, -1       # imediato negativo (0xFFF em 12 bits)
addi x3, x0, 0        # imediato zero

sw x3, 16(x0)         # imediato 16
sw x5, -4(x6)         # imediato -4
lw x7, 16(x0)          # imediato 8

beq x1, x0, 8         # offset +8 (2 instruções à frente)
beq x1, x0, -4        # offset -4 (1 instrução atrás)

lui x2, 0x12345       # imediato será 0x12345000

jal x8, 0x111        # offset +0xABC (0xABC deve ser alinhado e tratado como signed)
add x9, x1, x5         # x9 = x1 + x5 (x1 é 127, x5 é -1)
xor x10, x3, x1        # x10 = x3 XOR x1 (x1 é 127, então x10 será modificado)
sll x11, x2, x3        # x11 = x2 << x3 (x3 é 0, então x11 será igual a x2)
