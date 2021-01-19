	.data
str1:	.asciiz "2016 e 2020 sao anos bissextos\n"
str2: 	.asciiz "101101 em binario"
	.eqv print_int10, 1
	.text
	.globl main
	
main:	addiu $sp, $sp, -4		#espaço na stack
	sw $ra, 0($sp)			#guardar ra na stack
	la $a0, str1
	jal atoi
	
	move $a0, $v0			#print_int10
	ori $v0, $0, 1
	syscall
	
	lw $ra, 0($sp)			#repor ra
	addiu $sp, $sp, 4		#repor sp
	
	addiu $sp, $sp, -4		#espaço na stack
	sw $ra, 0($sp)			#guardar ra na stack
	la $a0, str2
	jal atoibin
	
	move $a0, $v0			#print_int10
	ori $v0, $0, 1
	syscall
	
	lw $ra, 0($sp)			#repor ra
	addiu $sp, $sp, 4		#repor sp
	
	ori $v0,$0,10
	syscall
	jr $ra


# Mapa de registos
# res: $v0
# s: $a0
# *s: $t0
# digit: $t1
# Sub-rotina terminal: não devem ser usados registos $sx 

atoi: 	li $v0,0 			# res = 0;
while: 	lb $t0,0($a0) 			# while(*s >= '0')
 	blt $t0,'0',endw		# e (*s <= '9') 
 	bgt $t0,'9',endw		# {
 	sub $t1,$t0,'0'			# digit = *s – '0'
 	addiu $a0,$a0,1			# s++;
 	mul $v0,$v0,10 			# res = 10 * res;
 	add $v0,$v0,$t1			# res = 10 * res + digit;
 	j while				# }
endw: 	jr $ra 				# termina sub-rotina 

atoibin:li $v0,0 			# decimal = 0; i = 0; remainder
	li $t7,0
while2: lb $t0,0($a0) 			# while(*s == '0')
 	blt $t0,'0',endw2		# ou (*s == '1') 
 	bgt $t0,'1',endw2		# {
 	rem $t6,$t0,10			# remainder = s%10

 	sll $t5,$t7,2
 	mul $t6,$t6,$t5			# rem = rem*pow(2,i);
 	add $v0,$v0,$t6			# decimal += rem*pow(2,i);
 	
 	addiu $t7,$t7,1			# i++;
 	j while2			# }
endw2: 	jr $ra 				# termina sub-rotina 
