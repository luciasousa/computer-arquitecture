#void main(void)
#{
# int v = 0;
# TRISE0 = 0; // Configura o porto RE0 como saída
# while(1)
# {
# LATE0 = v; // Escreve v no bit 0 do porto E
# delay(500); // Atraso de 500ms
# v ^= 1; // complementa o bit 0 de v (v = v xor 1)
# }
#} 
        .equ SFR_BASE_HI, 0xBF88    # 16 MSbits of SFR area
        .equ TRISE, 0x6100          # TRISE address is 0xBF886100
        .equ PORTE, 0x6110          # PORTE address is 0xBF886110
        .equ LATE, 0x6120           # LATE address is 0xBF886120
        .equ TRISB, 0x6040          # TRISB addres
        .equ PORTB, 0x6050
        .equ RESET_CORE_TIMER,12
        .equ READ_CORE_TIMER,11
        .data
        .text
        .globl main

main:   ori $t0,$0,0

        lui $t1,SFR_BASE_HI
        lw $t2,TRISE($t1)          
        andi $t2, $t2, 0xFFFE
        sw $t2,TRISE($t1) 

while:  lw $t3, LATE($t1)
        andi $t3,$t3,0x0000
        or $t3,$t3,$t0
        sw $t3, LATE($t1)
        
        ori $a0,$0,500
        jal delay

        xor $t0,$t0,1

        j while

        jr $ra


delay:  subu $sp,$sp,4
        sw $ra,0($sp)
for:    ble $a0,0, endfor
        li $v0, RESET_CORE_TIMER
        syscall 

while2:  li $v0,READ_CORE_TIMER      # while (1) {
        syscall                     #
        blt $v0,20000,while2
        subu $a0,$a0,1
        j for
endfor:  lw $ra,0($sp)
         addiu $sp,$sp,4
         jr $ra
