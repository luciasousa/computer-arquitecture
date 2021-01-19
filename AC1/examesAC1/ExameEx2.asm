	.data
str:	.asciiz "\n"
max:	.asciiz "max:"
	.text
	.globl main
main:	
	li $v0,5
	syscall
	move $t0,$v0
	move $t1,$t0
	move $t2,$t0
for:	ble $t2,1,endfor
	move $a0,$t2
	li $v0,1
	syscall
	
	la $0,str
	li $v0,4
	syscall
	
if1:	and $t3,$t2,1
	beq $t3,0,endif1
	
	mul $t2,$t2,3
	addi $t2,$t2,1
if2:	ble $t2,$t1,endif2
	move $t1,$t2
endif2:	
endif1:	
	sra $t2,$t2,1
	j for
endfor:	
	la $a0,max
	li $v0,4
	syscall
	
	move $a0,$t2
	li $v0,1
	syscall
	
	la $a0,str
	li $v0,4
	syscall
	
	jr $ra