# Implementation of: RV32E Base Integer Instruction Set, Version 2.0


## ISA - RISC-V References

**Página oficial do projeto RISC-V:**  
  [RISC-V Technical Specifications](https://lf-riscv.atlassian.net/wiki/spaces/HOME/pages/16154769/RISC-V+Technical+Specifications)  
**Documento oficial da RV32I Base Integer Instruction Set (Versão 2.1):**  
  [RV32I Base Integer Instruction Set - PDF (Google Drive)](https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view?pli=1)  
**Backup do documento oficial:**  
  [riscv-unprivileged.pdf](docs/riscv-unprivileged.pdf)


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


[Todas intruções Base RV32E](/docs/rv32e_instrucoes_base_priority.md)  
[Intrucões Prioridade para Implementar](/docs/rv32e_instrucoes_base_priority.md)  
![Encoding](/docs/encoding.png)  
![Encoding Imediate variantes](/docs//encoding_imediate_variant.png)  
![Pipeline](/docs/risc-v-pipeline.svg)  
![Datapath](/docs/risc-v-dartapath.png)


## Estrutura do Peojeto

rv32e_processor/
├── src/
│   ├── core/
│   │   ├── rv32e_cpu.v                 # Módulo principal do processador   D
│   │   ├── pipeline_registers.v        # Registradores entre estágios      D
│   │   └── constants.v                 # Definições e constantes
│   │
│   ├── stages/
│   │   ├── if_stage.v                  # Instruction Fetch                 G
│   │   ├── id_stage.v                  # Instruction Decode                G
│   │   ├── ex_stage.v                  # Execute                           G
│   │   ├── mem_stage.v                 # Memory Access                     D
│   │   └── wb_stage.v                  # Write Back                        D
│   │
│   ├── components/
│   │   ├── register_file.v             # Banco de 16 registradores         G
│   │   ├── alu.v                       # Unidade Lógica Aritmética         G
│   │   ├── immediate_generator.v       # Gerador de imediatos              G
│   │   ├── branch_unit.v               # Unidade de branch
│   │   ├── memory_interface.v          # Interface de memória
│   │   └── pc_generator.v              # Gerador de PC
│   │
│   ├── control/
│   │   ├── control_unit.v              # Unidade de controle principal     G
│   │   ├── hazard_detection.v          # Detecção de hazards
│   │   ├── forwarding_unit.v           # Data forwarding
│   │   ├── branch_predictor.v          # Preditor de branch (opcional)
│   │   └── stall_controller.v          # Controle de stalls
│   │
│   ├── memory/
│   │   ├── instruction_memory.v        # Memória de instruções             D
│   │   ├── data_memory.v               # Memória de dados                  D
│   │   └── cache_controller.v          # Controlador de cache (opcional)   
│   │
│   └── debug/
│       ├── performance_counters.v      # Contadores de performance
│       ├── debug_interface.v           # Interface de debug
│       └── trace_generator.v           # Gerador de traces
│
├── tb/
│   ├── tb_rv32e_cpu.v                  # Testbench principal
│   ├── tb_individual_stages.v          # Testes de estágios individuais
│   ├── tb_hazard_tests.v               # Testes específicos de hazards
│   ├── tb_forwarding.v                 # Testes de forwarding
│   └── test_programs/
│       ├── basic_arithmetic.hex        # Programas de teste
│       ├── branch_tests.hex
│       ├── load_store_tests.hex
│       └── hazard_scenarios.hex
│
├── scripts/
│   ├── build.py                        # Script de compilação
│   ├── compile.tcl                     # Script de compilação
│   ├── simulate.tcl                    # Script de simulação
│   └── synthesis.tcl                   # Script de síntese
│
├── docs/
│   ├── architecture.md                 # Documentação da arquitetura
│   ├── pipeline_diagram.svg            # Diagrama do pipeline
│   └── instruction_set.md              # Conjunto de instruções
│
└── Makefile                            # Automatização de build