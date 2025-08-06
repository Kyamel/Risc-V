addi x5, x0, 0 # endereço base da memória   
addi  x6, x0, 4       
addi  x7, x0, 0          
addi  x8, x0, 3          

# loop sem rótulo - usamos offsets relativos
sw    x6, 0(x5)          
addi  x6, x6, 1          
addi  x5, x5, 4          
addi  x7, x7, 1          
#bne   x7, x8, -9         

addi  x1, x0, 1          # fim