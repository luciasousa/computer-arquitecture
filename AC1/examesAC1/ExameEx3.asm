	.data
	.text
	.globl xpto
xpto:	li $t1,0
	li $t0,0
for:	bge $t0,$a0,endfor
	lw $t2,0($a1)
	beq $t2,0,if
	
	addi $t2,$t0,1
	bge $t2,$a0,else
	
	addi $t2,$0,4
	addu $t2,$t2,$a1
	lw $t2,0($t2)
	bne $t2,0,else
	
if:	
	addi $t1,$t1,100
	j endif
else:	
	subi $t1,$t1,1
	lw $t2,0($a1)
	addi $t2,$t2,1
	sw $t2,0($a1)
endif:	
	addi $a1,$a1,4
	
	addi $t0,$t0,1
	j for
endfor:
	move $v0,$t1
	jr $ra