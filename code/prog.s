    .section .text
    .globl _start

_start:
    # Inicialização
    li x1, 10         # x1 = 10
    li x2, 20         # x2 = 20
    li x3, 0x100      # x3 = endereço base para lw/sw
    li x4, 0          # x4 = acumulador
    li x5, 5          # x5 = valor imediato
    li x6, 0x12345678 # valor para armazenar na memória

    # 1. ADD: x7 = x1 + x2 = 30
    add x7, x1, x2

    # 2. ADDI: x8 = x1 + 5 = 15
    addi x8, x1, 5

    # 3. XOR: x9 = x1 ^ x2
    xor x9, x1, x2

    # 4. SLL: x10 = x1 << (x5 & 0x1F) = 10 << 5 = 320
    sll x10, x1, x5

    # 5. SW: guarda x6 no endereço x3 + 0
    sw x6, 0(x3)

    # 6. LW: carrega x11 do endereço x3 + 0 (espera-se que x11 == x6)
    lw x11, 0(x3)

    # 7. BNE: se x11 != x6, pula (não deve pular)
    bne x11, x6, error

    # Fim em loop infinito
end:
    j end

error:
    # Loop de erro
    j error
