# lui and auipc.
# expect: x1=0x12345000 x2=0xfffff000 x3=8 x4=0x100c

lui   x1, 0x12345
lui   x2, 0xfffff
auipc x3, 0          # x3 = pc of this instruction = 8
auipc x4, 1          # x4 = 0x1000 + 12
