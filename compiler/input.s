addi x4, x0, 4     ; Coloca o valor 3 em x4 (soma 0 + 3)
addi x5, x0, 3     ; Coloca o valor 3 em x5 (soma 0 + 3)
nop
nop
add x6, x4, x5     ; Soma os valores de x4 e x5, armazena o resultado em x6
nop
addi x2, x4, -3
sw x6, 0(x4)      ; Armazena o valor de x6 no endereço apontado por x7
addi x1, x6, 4
lw x3, 0(x4)      ; Carrega o valor armazenado no endereço apontado por x7 em x3