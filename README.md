# Implementation of: RV32E Base Integer Instruction Set, Version 2.0


## ISA - RISC-V References

**Página oficial do projeto RISC-V:**  
  [RISC-V Technical Specifications](https://lf-riscv.atlassian.net/wiki/spaces/HOME/pages/16154769/RISC-V+Technical+Specifications)  
**Documento oficial da RV32I Base Integer Instruction Set (Versão 2.1):**  
  [RV32I Base Integer Instruction Set - PDF (Google Drive)](https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view?pli=1)  
**Backup do documento oficial:**  
  [riscv-unprivileged.pdf](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)


### Capitúlos mais relevantes:  
**2.3. Immediate Encoding Variants**  
**2.4. Integer Computational Instructions**


## Registradores RV32I e Convenções ABI

| Registrador | Nome ABI | Uso típico                          |
|-------------|----------|-----------------------------------|
| x0          | zero     | Constante zero (sempre 0)          |
| x1          | ra       | Return address (endereço de retorno) |
| x2          | sp       | Stack pointer                     |
| x3          | gp       | Global pointer                   |
| x4          | tp       | Thread pointer                  |
| x5 - x7     | t0 - t2  | Temporários                     |
| x8          | s0 / fp  | Saved register / frame pointer    |
| x9          | s1       | Saved register                  |
| x10 - x11   | a0 - a1  | Argumentos / return values         |
| x12 - x17   | a2 - a7  | Argumentos                    |
| x18 - x27   | s2 - s11 | Saved registers |
| x28 - x31   | t3 - t6  | Temporários  |

**RV32E possui apenas registradores (x0 - x15)**


## Instruções

### Essenciais (obrigatórias para implementar)

| Instrução | Tipo   | Operação | Comentário                               | Reuso interno                                                      |
|-----------|--------|----------|-----------------------------------------|-------------------------------------------------------------------|
| add       | R-type | ADD      | rs1 + rs2                              | —                                                                 |
| addi      | I-type | ADD      | rs1 + imediato                         | Reusa a operação ADD                                               |
| xor       | R-type | XOR      | rs1 ^ rs2                             | —                                                                 |
| sll       | R-type | SLL      | Shift Left Logical (rs1 << rs2[4:0]) | —                                                                 |
| lw        | I-type | ADD      | Calcula endereço: rs1 + offset          | Reusa a operação ADD para calcular o endereço                      |
| sw        | S-type | ADD      | Calcula endereço: rs1 + offset          | Reusa a operação ADD para calcular o endereço                      |
| bne       | B-type | SUB ou XOR + OR | Verifica se rs1 != rs2                  | Pode usar SUB para comparar ou reaproveitar XOR + OR para detectar diferença |

### Úteis (não requisitadas, porém simples e essenciais)

| Instrução | Tipo   | Operação | Comentário                                         | Reuso interno                                                      |
|-----------|--------|----------|---------------------------------------------------|-------------------------------------------------------------------|
| sub       | R-type | SUB      | rs1 - rs2 (útil para branchs e aritmética)        | —                                                                 |
| and       | R-type | AND      | rs1 & rs2                                         | —                                                                 |
| or        | R-type | OR       | rs1 \| rs2                                        | —                                                                 |
| andi      | I-type | AND      | rs1 & imediato                                    | Reusa a operação AND                                               |
| ori       | I-type | OR       | rs1 \| imediato                                   | Reusa a operação OR                                                |
| jal       | J-type | —        | Jump and link (PC + 4 para rd, desvio relativo)  | —                                                                 |
| jalr      | I-type | ADD      | Jump and link register (PC + 4 para rd, endereço rs1 + imediato) | Reusa a operação ADD para cálculo do endereço     |
| beq       | B-type | SUB ou XOR + OR | Branch se rs1 == rs2                               | Igual a `bne`, porém verifica igualdade                   |
| srl       | R-type | SRL      | Shift Right Logical (rs1 >> rs2[4:0])| —                                                                 |

---

## Estrutura do Estágio EX (`src/stages/EX`)

```plaintext
src/
└── stages/
    └── EX/
        ├── EX.v                   # Módulo top-level do estágio EX (cola tudo)
        ├── control/
        │   └── ForwardingUnit.v   # Detecta e aplica data forwarding para evitar hazards
        ├── datapath/
        │   ├── MuxOpB.v           # MUX entre rs2 e imediato (seleção do segundo operando)
        │   ├── BranchDecision.v   # Compara rs1 e rs2 para branchs (ex: BNE, BEQ)
        │   ├── BranchAdder.v      # Calcula PC + offset (endereço do branch)
        │   └── Pipeline_EX_MEM.v  # Registrador pipeline para passagem EX → MEM
        └── alu/
            ├── ALU.v              # Cola os operadores da ALU, escolhe operação pelo opcode/fun3
            └── ops/
                ├── Add.v
                ├── Sub.v
                ├── Xor.v
                ├── And.v         
                ├── Or.v
                ├── Sll.v
                ├── Srl.v 
                └── Bne.v
