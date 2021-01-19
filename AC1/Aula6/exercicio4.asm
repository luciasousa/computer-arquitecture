	.data
	.eqv print_string, 4
	.eqv print_int, 1
str1: 	.asciiz "cara"
str2: 	.asciiz "pau"
	.text
	.globl main

main:	addiu $sp, $sp, -4		#espa�o na stack
	sw $ra, 0($sp)			#guardar $ra na stack
	la $a0, str1			#argumentos
	la $a1, str2
	jal strcat
	move $a0, $v0			#print_string
	ori $v0, $0, 4
	syscall

 	lw $ra,0($sp) 			# rep�e endere�o de retorno
 	
 	addiu $sp,$sp,4			# liberta espa�o da stack
 	jr $ra 				# termina a sub-rotina 
 	
#Fun��o que permite concatenar 2 strings

strcat:	la $t0, str2			#char *p = dst;

whilea:	lb $t0,0($a0)
	beq $t0,'\0',endwa		#while(*p != '\0') 
	addi $v0,$v0,1
	addiu $a0,$a0,1 		#p++
	j whilea
endwa:	la $t2, str1
	move $v0, $t1
	move $v1, $t2
	#jal strcpy
	jr $ra
	
#Fun��o que copia string de uma zona da mem�ria para outra

strcpy:	li $t0, 0

do: 	lb $t1,0($a0)
	jr $ra

#Fun��o que devolve dimens�o da string

strlen: li $v0,0 			# len = 0;
while: 	lb $t0,0($a0)			# while(*s++ != '\0')
 	beq $t0,'\0',endw 		# {
 	addi $v0,$v0,1 			# len++;
 	addiu $a0,$a0,1 
 	j while				# }
endw: 	move $v0,$t0 			# return len;
 	jr $ra 				#

#Fun��o que inverte string

strrev: addiu $sp,$sp,-16 	# reserva espa�o na stack
 	sw $ra,0($sp) 		# guarda endere�o de retorno
 	sw $s0,4($sp) 		# guarda valor dos registos
 	sw $s1,8($sp) 		# $s0, $s1 e $s2
 	sw $s2,12($sp) 		#
 	move $s0,$a0 		# registo "callee-saved"
 	move $s1,$a0 		# p1 = str
 	move $s2,$a0 		# p2 = str
while1: lb $t0, 0($s2)
	beq $t0,'\0',endw1	# while( *p2 != '\0' ) {
 	addi $s2,$s2,1		# p2++;
 	j while1		# }
endw1: 	addi $s2,$s2,-1		# p2--;
while2: 			# while(p1 < p2) {
 	bge $s1,$s2,endw2
 	move $a0,$s1 		#
 	move $a1,$s2 		#
 	jal exchange 		# exchange(p1,p2)
 	addi $s1,$s1,1
 	addi $s2,$s2,-1
 	j while2		# }
endw2:	move $v0,$s0
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	sw $s1,8($sp) 		
 	sw $s2,12($sp)
	addi $sp, $sp, 16
	jr $ra
exchange:
	lb $t2, 0($a0)	
	lb $t1, 0($a1)	
	
	sb $t1, 0($a0)
	sb $t2, 0($a1)
	
	jr $ra
