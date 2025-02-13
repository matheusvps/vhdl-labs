# vhdl-labs
##### Disciplina de Arquitetura de Computadores. Implementação/Descrição de um processador em VHDL.

## Opcodes e instruções

| Opcode | Instrução  |
|--------|------------|
|  0000  |    nop     |   
|  0001  |    add     |  
|  0010  | *not used* |     
|  0011  |    sub     |   
|  0100  | *not used* |
|  0101  |    cmp (compara acumulador com registrador)|
|  0110  |    ld      |
|  0111  |    lw      |
|  1000  |    or      |
|  1001  |    mult    |
|  1010  |    mov     |
|  1011  |    sw      |
|  1100  |    zac  (zerar acumulador)|
|  1101  |    BEQ (a == b -> flag zero  dá 1)|
|  1101  |    BNE (a != b -> flag zero  dá 0)|
|  1101  |    BGT (a > b  -> flag carry dá 0)|
|  1101  |    BLT (a < b  -> flag carry dá 1)|
|  1110  | *not used* |
|  1111  |    jump    |


## Codificação

MSB b13 |---------------| b0 LSB

| Instrução |  Binário (14bits)  |
|-----------|--------------------|
|    nop    |  0000_XXXX_XXXX_XX | 
|    add    |  0001_SSSS_XXXX_XX |
|    sub    |  0011_SSSS_XXXX_XX |
|    cmp    |  0101_SSSS_XXXX_XX |  
|    ld     |  0110_DDDD_CCCC_CC |  
|    lw     |  0111_XXXX_SSSS_XX |
|    or     |  1000_SSSS_XXXX_XX |  
|    mult   |  1001_SSSS_XXXX_XX |  
|    mov    |  1010_DDDD_SSSS_XX |  
|    sw     |  1011_XXXX_SSSS_XX |  
|    zac    |  1100_XXXX_XXXX_XX |
|    beq    |  1101_000_AAAA_AAA |  
|    bne    |  1101_001_AAAA_AAA |  
|    bgt    |  1101_010_AAAA_AAA |  
|    blt    |  1101_011_AAAA_AAA | 
|    jmp    |  1111_AAAA_AAAX_XX |  

> X: irrelevante
> D: registrador destino
> S: registrador fonte
> C: constante
> A: endereço

_Obs: LW e SW -> Operações de memória usando registrador SSSS como endereço e o Acumulador como _

## Condições de salto
| Instrução | br_condition |
|-----------|--------------|
|    beq    |    000       |
|    bne    |    001       |
|    bgt    |    010       |
|    blt    |    011       |
|    ---    |    100       |
|    ---    |    101       |
|    ---    |    110       |
|    ---    |    111       |