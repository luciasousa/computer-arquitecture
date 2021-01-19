# Mapa de registos:
# $t0 – soma
# $t1 – value
# $t2 - i
 	.data
str1: 	.asciiz "Introduza um numero: "
str2: 	.asciiz "Valor ignorado\n"
str3: 	.asciiz "A soma dos positivos é: "
 	.eqv print_string, 4
 	.eqv read_int, 5
 	.eqv print_int10, 1 
 	
 	.text
 	.globl main
main: 	li $t0,0 		# soma = 0;
 	li $t2,0		# i = 0;
for: 	bge $t2,5,endfor 	# while(i < 5) {

	# Printing out the text
	la $a0, str1
	li $v0,4
 	syscall 		# print_string(str1)
 	
 	# Getting user input
 	li $a0, 1
 	li $v0, 5
 	syscall
 	
 	# Moving the integer input to another register
 	move $t1, $v0		# value=read_int();

 	ble $t1,$0,else	 	# if(value > 0)
 	add $t0,$t0,$v0		# soma += value;
 	j endif 		#
else: 				# else

	# Printing out the text
	la $a0, str2
	li $v0,4
 	syscall			# print_string(str2);
 	
endif: 	addi $t2,$t2,1 		# i++;
 	j for 			# }
endfor:
	# Printing out the text
	la $a0, str3
	li $v0,4
	syscall			# print_string(str3)
	
	# Printing out the number
	li $v0, 1
	move $a0, $t0		
	syscall
				# print_int10(soma);
				
	li $v0, 10
    	syscall
 	jr $ra 
