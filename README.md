# vhdl-labs
VHDL Labs - UTFPR - Computer Architecture

## Codificação
MSB b13              b0 LSB
    |---------------|
nop:  
    0000_XXXX_XXXX_XX  

add:  
    0001_SSSS_XXXX_XX
    
sub:  
    0011_SSSS_XXXX_XX

cmp:  
    0101_SSSS_XXXX_XX  

ld:  
    0110_DDDD_CCCC_CC  

lw:  
    0111_DDDD_SSSS_XX  

or:  
    1000_SSSS_XXXX_XX  

mult:  
    1001_SSSS_XXXX_XX  

mov:  
    1010_DDDD_SSSS_XX  

sw:  
    1011_SSSS_XXXX_XX  

jmp:  
    1111_AAAA_AAAX_XX  

beq:  
    1101_AAAA_AAAX_XX  

blt:  
    1110_AAAA_AAAX_XX  

X: irrelevante
D: registrador destino
S: registrador fonte
C: constante
A: endereço

opcode:  operação:
0000     nop
0001     add
0011     sub
0101     cmp (compara com registrador)
0110     ld
0111     lda
1000     OR
1001     mult
1010     mov
1011     open
1111     jump (absoluto)
1101     BEQ  (relativo) a == b ->flag zero  dá 1
1110     BLT  (relativo) a < b  ->flag carry dá 1
1111     inválido