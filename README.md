# vhdl-labs
VHDL Labs - UTFPR - Computer Architecture

## Codificação
MSB b13               b0 LSB
    |                 |
nop:  
    0000_XXXXXXXXXX  

add:  
    0001_DDDD_SSSS_XX
    
sub:  
    0011_DDDD_SSSS_XX

cmp:  
    0101_SSSS_XXXXXX  

ld:  
    0110_DDDD_CCCCCC  

lw:  
    0111_DDDD_SSSS_XX  

or:  
    1000_SSSS_XXXXXX  

mult:  
    1001_SSSS_XXXXXX  

mov:  
    1010_DDDD_SSSS_XX  

sw:  
    1011_SSSS_XXXXXX  

jmp:  
    1111_AAAAAAA_XXX  

beq:  
    1101_AAAAAAA_XXX  

blt:  
    1110_AAAAAAA_XXX  

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