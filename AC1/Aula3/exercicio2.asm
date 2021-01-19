# Mapa de registos:
# $t0 – value
# $t1 – bit
# $t2 - i
 	.data					#variaveis
str1: 	.asciiz "Introduza um numero: "
str2: 	.asciiz "O valor em binário é: "
 	.eqv print_string,4
 	.eqv read_int,5
 	.eqv print_char,11

   	.text					#instruções
 	.globl main
 	#print str
main: 	la $a0,str1
 	li $v0,4 			# (instrução virtual)
 	syscall 			# print_string(str1);
 	#read int
 	li $a0,1			# value=read_int();
 	li $v0,5
 	syscall

 	move $t0, $v0 			# mover v0 para t0

 	la $a0, str2			# print_string(str2);
 	li $v0, 4
 	syscall
 	li $t2,0 			# i = 0
for: 	bge  $t2,32,endfor 		# while(i < 32) {

	rem $t3,$t2,4			# if((i % 4) == 0) // resto da divisão inteira
	bne $t3,$0,endif
	li $a0,' '
 	li $v0,11
 	syscall	
					# print_char(' ');
endif:	andi $t1,$t0,0x80000000 	# (instrução virtual)
 	
 	beq $t1,$0,else 		# if(bit != 0)
 	li $a0,'1'
 	li $v0,11
 	syscall				# print_char('1');
 	j endif1
 	 
else: 					# else
 	li $a0,'0'
 	li $v0,11
 	syscall				# print_char('0');
endif1: sll $t0, $t0, 1			# value = value << 1;
	
 		
	addi $t2,$t2,1 			# i++;
 	j for 	
endfor: 				#
 	jr $ra 				# fim do programa  
