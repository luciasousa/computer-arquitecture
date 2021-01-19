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

main:   #RE0 - RE3 como saídas
        lui $t1, SFR_BASE_HI       
        lw $t2, TRISE($t1)          # READ (Mem_addr = 0xBF880000 + 0x6100)
        andi $t2, $t2, 0xFFF0       # MODIFY (bit0=bit3=0 (0 means OUTPUT))
        sw $t2, TRISE($t1)          # WRITE (Write TRISE register) 

        #RB0 - RB3 como entradas
        lw $t3, TRISB($t1)          # READ (Mem_addr = 0xBF880000 + 0x6040)
        ori $t3, $t3,0x000F         #bit0=bit3=1
        sw $t3, TRISB($t1)

        addiu $sp,$sp,-4
        sw $ra,0($sp)

        lw $t2, PORTB($t1)
        andi $t2,$t2,0x0008

        jal johnson

        lw $ra,0($sp)
        addiu $sp,$sp,4


        jr $ra

### FUNÇÃO JHONSON ###

johnson: li $t6,0

while_m: andi $t7, $t6, 0x01       # isolate LSB
        nor $t7, $t7, $t7        # negate LSB
        andi $t7, $t7, 0x01       # all other bits to 0 to not mess with bits 3 to 1 
        sll $t7, $t7, 3
        srl $t6, $t6, 1
        or $t6, $t6, $t7
        andi $t6, $t6, 0x000F     # to ignore all other bits
        lw $t7, LATE($t1)         # $s3 is needless now, can use it for LATE
        andi $t7, $t7, 0xFFF0
        or $t7, $t7, $t6
        sw $t7, LATE($t1)
        li $a0, 666
        jal delay
        j while_m


### FUNÇÃO DELAY ###
delay:  subu $sp,$sp,4
        sw $ra,0($sp)
for:    ble $a0,0, endfor
        li $v0, RESET_CORE_TIMER
        syscall 

while2: li $v0,READ_CORE_TIMER      # while (1) {
        syscall                     #
        blt $v0,20000,while2
        subu $a0,$a0,1
        j for
endfor: lw $ra,0($sp)
        addiu $sp,$sp,4
        jr $ra
