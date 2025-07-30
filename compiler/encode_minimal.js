import { Encoder } from './core/Encoder.js';
import { COPTS_ISA } from './core/Config.js';

const config = {
  ISA: COPTS_ISA.RV32I, // Configuração para RV32I
};

// Exemplo de instruções para codificar
const instructions = [
  'add x1, x2, x3',
  'lw x4, 100(x5)',
  'jal x1, 2048',
  'c.add x8, x9', // Instrução compacta (C-extension)
];

for (const asm of instructions) {
  try {
    const encoder = new Encoder(asm, config);
    console.log(`Assembly: ${asm}`);
    console.log(`Binary:   ${encoder.bin}`);
    console.log(`XLENs:    ${encoder.xlens}`); // Mostra os XLENs suportados
    console.log('---');
  } catch (error) {
    console.error(`Erro ao codificar "${asm}": ${error}`);
  }
}