addi x1, x0, 1  ; x1 = 1
nop
nop
nop 
sw x1, 0(x0)    ; armazena 1 em mem[0]
addi x4, x0, 2  ; x4 = 2
nop
lw x2, 0(x0)    ; x2 = 1
nop
nop
nop
sll  x5, x4, x2  ; x5 = 2 << 1 = 4
nop
nop
nop
xor  x6, x5, x4 ; x6 = 6
sw   x4, 4(x0)
sw   x5, 8(x0)
lw   x7, 4(x0)  ; x7 = 2
lw   x8, 8(x0)  ; x8 = 4
nop
nop
nop
add x9, x7, x8 ; x9 = 6