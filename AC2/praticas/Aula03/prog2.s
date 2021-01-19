        .equ SFR_BASE_HI, 0xBF88    # 16 MSbits of SFR area
        .equ TRISE, 0x6100          # TRISE address is 0xBF886100
        .equ PORTE, 0x6110          # PORTE address is 0xBF886110
        .equ LATE, 0x6120           # LATE address is 0xBF886120
        .equ TRISB, 0x6040          # TRISB addres
        .equ PORTB, 0x6050
        .data
        .text
        .globl main

main:   #RE0 - RE3 como saídas
        lui $t1, SFR_BASE_HI        #
        lw $t2, TRISE($t1)          # READ (Mem_addr = 0xBF880000 + 0x6100)
        andi $t2, $t2, 0xFFFE       # MODIFY (bit0=bit3=0 (0 means OUTPUT))
        sw $t2, TRISE($t1)          # WRITE (Write TRISE register) 

        #RB0 como entrada
        lw $t2, TRISB($t1)          # READ (Mem_addr = 0xBF880000 + 0x6040)
        ori $t2, $t2,0x0001         #bit0 = 1
        sw $t2, TRISB($t1)

loop:   lw $t2, PORTB($t1)
        andi $t2, $t2, 0x0001
        nor $t2,$t2,0x0000
        lw $t3, LATE($t1)
        andi $t3, $t3, 0xFFFE
       
        or $t2, $t2, $t3
        
        sw $t2, LATE($t1)

        j loop

        jr $ra