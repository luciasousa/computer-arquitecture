	.data
marg1:	.double -0,00000000000000000001
marg2:	.double 0,00000000000000000001
table:	.space 2880
num1:	.double 0.017453292519943295769
num2:	.double 1000000.0
	.text
	.globl sin_r, sin_d
	
sin_r:	addiu $sp,$sp,-12
	sw $ra,0($sp)
	s.s $f12,4($sp)
	s.s $f13,8($sp)
	
	bge $a0,50,if
	l.d $f2,marg1
	c.lt.d $f2,$f14
	bc1f endif
	l.d $f2,marg2
	c.lt.d $f14,$f2
	bc1f endif
if:	mov.d $f0,$f14
	lw $ra,0($sp)
	addiu $sp,$sp,12
	jr $ra
endif:	addi $t0,$a0,1
	addi $t1,$a0,2
	mul $t2,$t0,$t1
	mtc1 $t2,$f2
	cvt.d.w $f2,$f2
	div.d $f2,$f12,$f2
	mul.d $f14,$f14,$f2
	addi $a0,$a0,2
	jal sin_r
	l.s $f2,4($sp)
	l.s $f3,8($sp)
	sub.d $f0,$f2,$f0
	addiu $sp,$sp,12
	lw $ra,0($sp)
	jr $ra



sin_d:	addiu $sp,$sp,-8
	sw $ra,0($sp)
	sw $a1,4($sp)
	la $t2,table
	rem $t0,$a0,360
	bge $t0,0 endif1
	addi $t0,$t0,360
endif1:	sll $t1,$t0,3
	add $t1,$t2,$t1
	l.s $f2,0($t1)
	l.s $f3,4($t1)
	mtc1 $0,$f4
	mtc1 $0,$f5
	c.eq.d $f2,$f4
	bc1f endif2
	l.d $f4,num1
	mtc1 $t0,$f6
	cvt.d.w $f6,$f6
	mul.d $f4,$f4,$f6
	mul.d $f12,$f4,$f4
	mov.d $f14,$f4
	li $a0,1
	jal sin_r
	mov.d $f2,$f0
	s.s $f2,0($t1)
	s.s $f3,4($t1)
	
endif2:
	mov.d $f4,$f2
	lw $a1,4($sp)
	beq $a1,$0,endif3
	l.d $f6,num2
	mul.d $f2,$f4,$f6
	cvt.d.w $f2,$f2
	mfc1 $a0,$f2
	li $v0,1
	syscall
	
endif3:	
	mov.d $f0,$f4
	lw $ra,0($sp)
	addiu $sp,$sp,8
	jr $ra