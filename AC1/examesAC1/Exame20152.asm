	.data
arrayf:	.space 16
dez:	.double 10.0
	.text
	.globl main
main:	subiu $sp,$sp,20
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	
	move $s3,$a1
	ble $a0,4,else
	li $s0,4
	j endif1
else:	move $s0,$a0
endif1:	
	li $s1,0
for:	bge $s1,$s0,endfor
	move $a0,$s3
	jal atof
	l.d $f2,dez
	c.lt.d $f2,$f0
	bc1f endif2
	mov.d $f0,$f2
endif2:	
	cvt.d.s $f0,$f0
	sll $t0,$s1,2
	la $t1, arrayf
	addu $t1,$t1,$t0
	s.s $f0,0($t1)
	addiu $s3,$s3,4
	
	addi $s1,$s1,1
	j for
endfor:	
	li $v0,6
	syscall
	
	la $a0,arrayf
	li $a1,4
	mov.s $f12,$f0
	jal procf
	
	li $v0,2
	mov.s $f12,$f0
	syscall
	
	li $v0,0
	lw $ra,0($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	addiu $sp,$sp,20
	jr $ra
	
	
atof:
procf: