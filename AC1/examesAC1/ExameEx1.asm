	.data
strerr:	.asciiz "warning: zero digits!"
	.text
	.globl maddf
maddf:	
	addiu $sp,$sp,-32
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	sw $s3,12($sp)
	sw $s4,16($sp)
	sw $s5,20($sp)
	sw $s6,24($sp)
	sw $ra,28($sp)
	
	move $s2,$a0
	move $s3,$a1
	move $s4,$a2
	move $s5,$a3
	
	li $s6,0
	
	bne $s2,0,endif
	la $s2,strerr
	li $v0,4
	syscall
	
endif:	li $s0,0
for:	bgeu $s0,$s2,endfor
	sll $t0,$s0,2
	add $t0,$t0,$s3
	lw $t0,0($t0)
if2:	beq $t0,0,endif2
	li $s1,0
for2:	bgeu $s1,$s2,endfor2
	add $t0,$s0,$s1
	sll $t0,$t0,2
	add $t0,$t0,$s5
	lw $t1,0($t0)
	
	sll $t2,$s0,2
	add $t2,$t2,$s3
	lw $t2,0($t2)
	
	sll $t3,$s1,2
	add $t3,$t3,$s4
	lw $t3,0($t3)
	
	mul $t2,$t2,$t3
	add $t1,$t1,$t2
	sw $t1,0($t0)
	
	
	addi $s1,$s1,1
	j for2
endfor2:
	
	add $s6,$s6,1
	and $t0,$s6,15
	bne $t0,0,endif3
	
	mul $a0,$s2,2
	move $a1,$s5
	jal normalize
	
endif3:	
endif2:		
	addi $s0,$s0,1
	j for
endfor:	and $t0,$s6,15
	beq $t0,0,end
	
	mul $a0,$s2,2
	move $a1,$s5
	jal normalize
	
end:	
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	lw $s3,12($sp)
	lw $s4,16($sp)
	lw $s5,20($sp)
	lw $s6,24($sp)
	lw $ra,28($sp)
	addiu $sp,$sp,32
	jr $ra