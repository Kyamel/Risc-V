# Pseudo-instructions expanded by GNU as.
# expect: x2=-5 x3=-5 x4=5 x5=-1 x6=0x12345678 x7=1 x8=1 x9=9 x10=1

li   x2, -5             # addi x2, x0, -5
mv   x3, x2             # addi x3, x2, 0
neg  x4, x2             # sub x4, x0, x2
not  x5, x0             # xori x5, x0, -1
li   x6, 0x12345678     # lui + addi
seqz x7, x0             # sltiu x7, x0, 1
snez x8, x2             # sltu x8, x0, x2
call SUB                # auipc + jalr (or jal after linker relaxation); ra = return address
addi x10, x0, 1         # runs after returning
j    END                # jal x0, END
SUB:
li   x9, 9
ret                     # jalr x0, 0(ra)
END:
