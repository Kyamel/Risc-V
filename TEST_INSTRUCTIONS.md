# Instruções para Testar as Correções do ID_STAGE

## Modificações Realizadas

1. **Correção dos includes**: Todos os arquivos agora usam `include "constants.v"` e foi criado um symlink em `src/constants.v` apontando para `src/core/constants.v`.

2. **Lógica de avaliação de branch**: Adicionada ao módulo `id_stage.v` entre as linhas 67-93:
   - Extrai `funct3`, `opcode` e detecta instruções de branch
   - Avalia condições de branch (BEQ, BNE, BLT, BGE, BLTU, BGEU) usando dados com bypass
   - Cria `control_signals_final` que substitui o bit de branch pela condição avaliada

3. **Uso dos sinais corrigidos**: O registro ID/EX agora usa `control_signals_final` em vez de `control_signals`.

## Como Testar

Para testar as correções, compile e execute o teste:

```bash
# Se tiver iverilog instalado:
make test_id_stage

# Ou manualmente:
iverilog -I src/core -I src/stages -I src/components -I src/control \
  -o build/tb_id_stage \
  src/core/constants.v \
  src/components/immediate_generator.v \
  src/control/control_unit.v \
  src/stages/id_stage.v \
  tb/stages/tb_id_stage.v
vvp build/tb_id_stage
```

## Resultados Esperados

Com as correções aplicadas, os testes devem mostrar:
- ✅ Branch conditions being evaluated correctly (não mais branch=1 para todas as instruções)
- ✅ Redução ou eliminação dos 4 testes que falhavam anteriormente
- ⚠️  Avisos sobre immediate calculation podem persistir (formato B-type vs teste expectation)

## Principais Correções

1. **BEQ (funct3=000)**: rs1 == rs2 => branch=1, rs1 != rs2 => branch=0
2. **BNE (funct3=001)**: rs1 != rs2 => branch=1, rs1 == rs2 => branch=0
3. **BLT (funct3=100)**: rs1 < rs2 (signed) => branch=1, caso contrário => branch=0
4. **BGE (funct3=101)**: rs1 >= rs2 (signed) => branch=1, caso contrário => branch=0
5. **BLTU (funct3=110)**: rs1 < rs2 (unsigned) => branch=1, caso contrário => branch=0
6. **BGEU (funct3=111)**: rs1 >= rs2 (unsigned) => branch=1, caso contrário => branch=0

