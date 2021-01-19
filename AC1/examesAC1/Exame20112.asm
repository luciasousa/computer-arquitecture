	.data
str:	.asciiz "Pesquisa com sucesso"
	.align 2
	#name	offset
	#name	0
	#price	20
	#flag	24
	#qtd	28
	#SIZE	32
book_array: 
	.space 320
max:	.float 0
	.text
	.globl main
main:	subiu $sp,$sp,16
	sw $ra,0($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	s.s $f20,12($sp)
	
	bge $a0,1,endif
	li $v0,-1
	j final
endif:	lw $a0,0($a1)
	jal atoi
	move $s0,$v0
	
	li $v0,6
	syscall
	mov.s $f20,$f0
	
	la $s1,book_array
	move $a0,$s1
	move $a1,$s0
	jal read_array
	
	la $s1,book_array
	move $a0,$s1
	move $a1,$s0
	mov.s $f20,$f12
	l.s $f14,max
	jal exists
	bne $v0,1,endif2
	la $a0,str
	li $v0,4
	syscall
endif2:	li $v0,0
final:	lw $ra,0($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	l.s $f20,12($sp)
	addiu $sp,$sp,16
	jr $ra



exists:
read_array:
atoi: