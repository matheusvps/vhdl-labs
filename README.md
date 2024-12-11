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
    0101_SSSS_CCCC_CC  

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
    1101_000_AAAA_AAA  

blt:  
    1101_011_AAAA_AAA  

zac:
    1100_XXXX_XXXX_XX

X: irrelevante
D: registrador destino
S: registrador fonte
C: constante
A: endereço

opcode:  operação:
0000     nop
0001     add
0010     *not used*
0011     sub
0100     *not used*
0101     cmp (compara com registrador)
0110     ld
0111     lw
1000     OR
1001     mult
1010     mov
1011     sw
1100     zac  (zerar acumulador)
1101     BEQ  (relativo) a == b -> flag zero  dá 1
1101     BLT  (relativo) a < b  -> flag carry dá 1
1110     *not used*
1111     jump (absoluto)

## Condições de salto
Instrução | br_condition
------------------------
   beq    |    000
   bne    |    001
   bgt    |    010
   blt    |    011
   bge    |    100
   ble    |    101
   bvs    |    110
   bvc    |    111