# Mapa de registos
# p: $t0
# *p: $t1
# lista+Size: $t2 
	.data
str1:	.asciiz "; "
str2:	.asciiz "\nConteudo do array :\n"
lista:	.word 8,-4,3,5,124,-15,87,9,27,15	 # a diretiva ".word" alinha num endere�o m�ltiplo de 4 
	.eqv print_int10,1
	.eqv print_string,4
	.eqv SIZE,10
	.text
	.globl main
	
main:
	la $a0,str2			#print_string(str2)
	li $v0,4
	syscall
	
	la $t0,lista			# p = lista
	li $t2,SIZE
	sll $t2,$t2,2
	#lb $t1,0($t0)			# libertar 4
	addu $t2,$t2,$t0		# $t2 = lista + SIZE;

while:	
	bgeu $t0,$t2,endw		# while(p < lista+SIZE) {
	lw $t1,0($t0)			# $t1 = *p;
	
	move $a0,$t1
	li $v0,1			# print_int10( *p );
	syscall
	
 	la $a0,str1			#print_string(str1)
	li $v0,4
	syscall
	
 	addi $t0,$t0,4 			# p++; de 4 em 4
 	j while				# } 
	
endw:	jr $ra				#termina o programa
	
