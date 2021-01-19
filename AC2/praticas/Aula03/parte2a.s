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

        jal count

        lw $ra,0($sp)
        addiu $sp,$sp,4



loop:   #RE0 = RB0 ...
        lw $t2, PORTB($t1)
        andi $t2,$t2,0x000F 
        lw $t3, LATE($t1)

        andi $t3, $t3, 0xFFF0    
       
        or $t2, $t2, $t3
        
        sw $t2, LATE($t1)

        j loop

        jr $ra

### FUNÇÃO COUNT ###
count:  li $t0,0

while:  bge $t0,15,endW
        addi $t0,$t0,1

        lw $t3, LATE($t1)
        andi $t3,$t3,0x0000
        or $t3,$t3,$t0
        sw $t3, LATE($t1)

        li $a0,500
        jal delay
        j while

endW:   li $t0,0
        j while
        jr $ra

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
