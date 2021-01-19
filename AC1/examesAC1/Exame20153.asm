#Name		Size	Align	Offset
#name		22	1	0
#nmec		4	4	24
#gender		1	1	28
#grade		8	4	32
#student	40	4
#

	.data
student1:
	.asciiz "Maria Francelina"
	.space 5
	.word 23457
	.byte 'F'
	.double 14,5
student2:
	.asciiz "Nobel Olimpico"
	.space 7
	.word 24095
	.byte 'M'
	.double 13,3
	
array:	.word student1, student2
	.align 2
minimo:	.double 9,5
	.text
	.globl main
main:	li $t0,0
	la $t2,array
for:	bge $t0,2,endfor
	sll $t1,$t0,2
	addu $t1,$t1,$t2
	lw $t3,0($t1)
	l.s $f2,32($t3)
	l.s $f3,36($t3)
	l.d $f4, minimo
	c.lt.d $f4,$f2
	bc1f endif
	
	move $a0,$t3
	li $v0,4
	syscall
	
	
	lw $a0,24($t3)
	li $v0,1
	syscall
	
endif:	
	addi $t0,$t0,1
	j for
endfor:	
	li $v0,0
	jr $ra
	