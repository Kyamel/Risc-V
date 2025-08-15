lw x1, 4(x0)
add x2, x1, x0
add x1, x1, x2
add x1, x1, x2
sub x1, x1, x2
sub x1, x1, x2
beq x1, x2, SAIDA
# Caso o fluxo venha para cá, seu processador está errado
add x1, x1, x1
sw x1, 0(x0)
SAIDA:
and x1, x1, x2
or x1, x1, x0
sw x1, 0(x0)