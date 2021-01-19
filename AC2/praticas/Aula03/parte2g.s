        .equ readCoreTimer, 11
        .equ resetCoreTimer, 12
        .equ SFR_BASE_HI, 0XBF88
        .equ TRISE, 0X6100
        .equ LATE, 0X6120
        .equ TRISB, 0X6040
        .equ PORTB, 0x6050
        .data
msg:    .asciiz "\n\n"
        .text
        .globl main

main:
        addiu $sp, $sp, -20
        sw $ra, 0($sp)
        sw $s0, 4($sp)        # target address
        sw $s1, 8($sp)        # data to show
        sw $s2, 12($sp)       # counter
        sw $s3, 16($sp)       # aux for johnson counter / LATE-put

        li $s2, 1
        #RB0-3 -> input
        lui $s0, SFR_BASE_HI
        lw $s1, TRISE($s0)
        ori $s1, $s1, 0x000F
        sw $s1, TRISE($s0)

        #RE0-3 -> output
        lw $s1, TRISE($s0)
        andi $s1, $s1, 0xFFF0
        sw $s1, TRISE($s0)

while_m:
        lw $s1, PORTB($s0)         # get all RB bits
        andi $s1, $s1, 0x0002      # isolate port RB1
        beq $s1, 0x0002, left_ring
        beq $s2, 0x0001, right_reset   # if rez = 0 then reset to 8 
        srl $s2, $s2, 1            # else rez >> 1
        j j2while_ring

right_reset:
        li $s2, 0x08
        j j2while_ring

left_ring:
        beq $s2, 0x0008, left_reset
        sll $s2, $s2, 1
        j j2while_ring

left_reset:
        li $s2, 0x01
        j j2while_ring

j2while_ring:
        lw $s3, LATE($s0)
        andi $s3, $s3, 0xFFF0
        or $s3, $s3, $s2
        sw $s3, LATE($s0)
        li $a0, 333
        jal delay
        j while_m

end_wm:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        addiu $sp, $sp, 20
        jr $ra

### FUNÇÃO DELAY ###
delay:  subu $sp,$sp,4
        sw $ra,0($sp)
for:    ble $a0,0, endfor
        li $v0, 12
        syscall 

while2: li $v0,11      # while (1) {
        syscall                     #
        blt $v0,20000,while2
        subu $a0,$a0,1
        j for
endfor: lw $ra,0($sp)
        addiu $sp,$sp,4
        jr $ra