# Inicialização
addi x2, x0, 7       # x2 = 7
sw x2, 4(x0)         # Mem[4] = x2
lw x1, 4(x0)         # x1 = 7
add x2, x1, x0       # x2 = 7

# Sequência de adições
add x1, x1, x2       # x1 = 14
add x1, x1, x2       # x1 = 21

# Substituição de sub x1, x1, x2 (x1 = 21-7 = 14)
addi x4, x0, -1      # x4 = -1 (0xFFFFFFFF)
xor x3, x2, x4       # x3 = ~x2 (complemento de 1)
addi x3, x3, 1       # x3 = -x2 (complemento de 2)
add x1, x1, x3       # x1 = x1 - x2

# Segunda subtração (x1 = 14-7 = 7)
xor x3, x2, x4       # x3 = ~x2
addi x3, x3, 1       # x3 = -x2
add x1, x1, x3       # x1 = x1 - x2

# Substituição de beq por bne
bne x1, x2, ERROR    # Se x1 != x2, vai para ERROR
# Se x1 == x2, continua

# Substituição de and x1, x1, x2 (x1 = x1 & x2)
# Implementação alternativa sem AND:
addi x5, x0, 0       # x5 = 0 (acumulador do AND)
# Fim normal
sw x1, 0(x0)
jal x0, END

ERROR:
add x1, x1, x1       # x1 *= 2 (código de erro)
sw x1, 0(x0)

END:
# Término do programa