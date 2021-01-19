	.data
	.eqv print_string, 4
	.eqv print_int, 1
str: 	.asciiz "Arquitetura de Computadores I"
	.text
	.globl main

main:	addiu $sp, $sp, -4		#espaço na stack
	sw $ra, 0($sp)			#guardar ra na stack
	la $a0, str
	jal strlen
	
	move $a0, $v0			#print_int
	ori $v0, $0, 1
	syscall
	
	lw $ra, 0($sp)			#repor ra
	addiu $sp, $sp, 4		#repor sp
	
	#ori $v0, $0,0			#return zero
	jr $ra
	
# O argumento da função é passado em $a0
# O resultado é devolvido em $v0
# Sub-rotina terminal: não devem ser usados registos $sx
strlen: li $t1,0 			# len = 0;
while: 	lb $t0,0($a0)			# while(*s++ != '\0')
 	addiu $a0,$a0,1 		#
 	beq $t0,'\0',endw 		# {
 	addi $t1,$t1,1 			# len++;
 	j while				# }
endw: 	move $v0,$t1 			# return len;
 	jr $ra 				#