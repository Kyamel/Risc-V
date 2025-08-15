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

// Primeira passagem: coleta labels e calcula seus endereços
const labelMap = new Map();
let currentAddress = 0;
const processedLines = [];

for (const asm of assemblyLines) {
  let instruction = asm.trim();
  
  // Remove comentários
  instruction = instruction.split(';')[0].trim();
  if (!instruction) continue;
  instruction = instruction.split('#')[0].trim();
  if (!instruction) continue;

  // Verifica se é um label
  if (instruction.endsWith(':')) {
    const labelName = instruction.slice(0, -1).trim();
    labelMap.set(labelName, currentAddress);
    continue;
  }

  // Tradução de pseudoinstrução "nop"
  if (instruction.toLowerCase() === 'nop') {
    instruction = 'addi x0, x0, 0';
  }

  processedLines.push(instruction);
  currentAddress += 4; // Cada instrução ocupa 4 bytes
}

// Segunda passagem: substitui labels por endereços e codifica
const output = [];
currentAddress = 0;

for (const instruction of processedLines) {
  try {
    // Substitui labels em instruções de branch/jump
    let processedInstruction = instruction;
    const branchMatch = instruction.match(/(beq|bne|blt|bge|bltu|bgeu)\s+(x\d+),\s*(x\d+),\s*([^\s,]+)/i);
    
    if (branchMatch) {
      const [, op, rs1, rs2, label] = branchMatch;
      if (labelMap.has(label)) {
        const targetAddress = labelMap.get(label);
        const offset = (targetAddress - currentAddress) / 2; // Branch offset é em múltiplos de 2
        processedInstruction = `${op} ${rs1}, ${rs2}, ${offset}`;
      }
    }

    const encoder = new Encoder(processedInstruction, config);
    const binary = encoder.bin;
    const hex = parseInt(binary, 2).toString(16).padStart(8, '0');
    
    output.push({
      assembly: instruction,
      binary: binary,
      hex: hex,
    });
    
    currentAddress += 4;
  } catch (error) {
    console.error(`Erro ao codificar "${instruction}": ${error}`);
    output.push({
      assembly: instruction,
      error: error.message,
    });
    currentAddress += 4;
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