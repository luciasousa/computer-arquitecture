	.data
	.eqv print_string, 4
str: 	.asciiz "Universidade de Aveiro - DETI"
	.text
	.globl main

main:	addiu $sp, $sp, -4		#espaço na stack
	sw $ra, 0($sp)			#guardar ra na stack
	la $a0, str
	jal strrev
	move $a0, $v0			#print_string
	ori $v0, $0, 4
	syscall

 	lw $ra,0($sp) 		# repõe endereço de retorno
 	
 	addiu $sp,$sp,4		# liberta espaço da stack
 	jr $ra 			# termina a sub-rotina 
# Mapa de registos:
# str: $a0 -> $s0 (argumento é passado em $a0)
# p1: $s1 (registo callee-saved)
# p2: $s2 (registo callee-saved)
#
strrev: addiu $sp,$sp,-16 	# reserva espaço na stack
 	sw $ra,0($sp) 		# guarda endereço de retorno
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
