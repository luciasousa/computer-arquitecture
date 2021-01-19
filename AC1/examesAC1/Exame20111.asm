	.data
	.text
	.globl eval
eval:	subiu $sp,$sp,28
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	s.s $f20,20($sp)
	s.s $f21,24($sp)
	
	move $s0,$a0
	bne $a0,$0,else
	li $t0,1
	mtc1 $t0,$f0
	cvt.d.w $f0,$f0
	j final
	
else:	
	mtc1 $0,$f20
	mtc1 $0,$f21
	li $s1,0
for:	bge $s1,$s0,endfor
	
	move $a0,$s1
	jal eval
	add.d $f20,$f20,$f0
	
	addi $s0,$s0,1
	j for
endfor:	li $t0,2
	mtc1 $t0,$f2
	cvt.d.w $f2,$f2
	mtc1 $s0,$f4
	cvt.d.w $f4,$f4
	div.d $f0,$f20,$f4
	mul.d $f0,$f0,$f2
	add.d $f0,$f0,$f2
	
final:	lw $ra,0($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	l.s $f20,20($sp)
	l.s $f21,24($sp)
	addiu $sp,$sp,28
	jr $ra
