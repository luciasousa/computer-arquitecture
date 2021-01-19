	.data
	.text
	.globl exists
exists:	
	li $t0,0
	li $t1,-1
	sub.s $f2,$f2,$f2
while:	bge $t0,$a1,endwhile
if1:	sll $t2,$t0,5
	addu $t2,$t2,$a0
	s.s $f3,20($t2)
	c.lt.s $f2,$f3
	bc1f endif1
	c.le.s $f3,$f12
	bc1f endif1
	move $t1,$t0
	mov.s $f2,$f3
	
endif1:	
	addiu $t0,$t0,1
	j while
endwhile:
	beq $t1,-1,endif2
	sll $t1,$t1,5
	addu $t1,$t1,$a0
	li $t0,1
	sb $t0,24($t1)
	s.s $f2,0($a2)
	li $v0,1
	j final
endif2:	li $v0,0
final:	jr $ra