#!/usr/bin/env node
import fs from 'fs';
import { Encoder } from './core/Encoder.js';
import { COPTS_ISA } from './core/Config.js';

// Configuração do encoder (RV32I por padrão)
const config = {
  ISA: COPTS_ISA.RV32I,
};

// Verifica se o arquivo de entrada foi fornecido
if (process.argv.length < 3) {
  console.error('Uso: node riscv-assembler.js <arquivo-de-entrada.s> [<arquivo-de-saída>]');
  process.exit(1);
}

const inputFile = process.argv[2];
const outputFile = process.argv[3] || 'output'; // Nome padrão do arquivo de saída

// Lê o arquivo de entrada
let assemblyLines;
try {
  const fileContent = fs.readFileSync(inputFile, 'utf-8');
  assemblyLines = fileContent.split('\n').filter(line => line.trim() !== '');
} catch (error) {
  console.error(`Erro ao ler o arquivo ${inputFile}: ${error.message}`);
  process.exit(1);
}

// Processa cada linha de assembly
const output = [];
for (const asm of assemblyLines) {
  let instruction = asm.trim();

  // Tradução de pseudoinstrução "nop"
  if (instruction.toLowerCase() === 'nop') {
    instruction = 'addi x0, x0, 0';
  }

  try {
    const encoder = new Encoder(instruction, config);
    const binary = encoder.bin;
    const hex = parseInt(binary, 2).toString(16).padStart(8, '0'); // 32 bits = 8 hex chars
    output.push({
      assembly: asm.trim(),
      binary: binary,
      hex: hex,
    });
  } catch (error) {
    console.error(`Erro ao codificar "${asm.trim()}": ${error}`);
    output.push({
      assembly: asm.trim(),
      error: error.message,
    });
  }
}

// Exibe os resultados no console
console.log('Resultado da conversão:');
console.log('='.repeat(80));
output.forEach((item) => {
  if (item.error) {
    console.log(`[ERRO] ${item.assembly} -> ${item.error}`);
  } else {
    console.log(`[OK] ${item.assembly} -> Bin: ${item.binary} | Hex: ${item.hex}`);
  }
});

// Salva em um arquivo (binário e hexadecimal)
if (outputFile) {
  try {
    const hexContent = output
      .filter(item => !item.error)
      .map(item => item.hex)
      .join('\n');

    const binContent = output
      .filter(item => !item.error)
      .map(item => item.binary)
      .join('\n');

    fs.writeFileSync(`${outputFile}.hex`, hexContent);
    fs.writeFileSync(`${outputFile}.bin`, binContent);
    console.log(`\nArquivos salvos: ${outputFile}.hex e ${outputFile}.bin`);
  } catch (error) {
    console.error(`Erro ao salvar os arquivos: ${error.message}`);
  }
}