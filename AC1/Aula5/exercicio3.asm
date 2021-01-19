#define SIZE 10
#define TRUE 1
#define FALSE 0 
# Mapa de registos
# k : $t2
# j : $t3
# houve_troca: $t4
# i: $t5
# lista: $t6
# lista + i: $t7 

	.data
	.eqv FALSE,0
	.eqv TRUE,1
	.eqv SIZE,10
	.eqv print_int10,1
	.eqv print_string,4
	.eqv read_int,5
str1:	.asciiz "\nInsira um número: "
str2:	.asciiz "\nConteúdo do array: "
str3:	.asciiz "; "
lista:	.space 40 #10*4
	.text
	.globl main
	
main:	
					#ler valores
	la $t6,lista			#$t6=lista
	li $t5,0			#i = 0

#ler e adicionar valores ao array	
while1: 
	bge $t5,SIZE,do
	la $a0,str1			#print_string(str1)
	li $v0,4
	syscall
	
	li $v0,5			# $v0 = read_int();
	syscall
	
	sll $t7,$t5,2
	addu $t7,$t6,$t7 		# $t7 = &lista[i]
	sw $v0, 0($t6)			# $t7 = read_int()
	addi $t5,$t5,1			#i++;
	
	j while1

#fazer troca
do:	li $t4,FALSE			#houve_troca = false
	li $t3,0			#j = 0
	
while2:	bge $t3,9,end			#while(i < SIZE-1){ 
	
if:	sll $t7,$t7,2 			# $t7 = j * 4 (2 = multiplica por 4)
 	addu $t7,$t7,$t6 		# $t7 = &lista[j]
	lw $t8,0($t6) 			# $t8 = lista[j]
	addi $t0,$t3,1			# $t5 = j e $t0 = j+1
	lw $t9,4($t7) 			# $t9 = lista[j+1]
 	ble $t8,$t9,endif 		# if(lista[j] > lista[j+1]){
 	sw $t8,4($t0) 			# lista[j+1] = $t8
 	sw $t9,0($t3) 			# lista[j] = $t9
 	li $t4,TRUE 
 	j while2				# }

endif:	addi $t3,$t3,1			#j++
	bne $t4,TRUE,while2
	la $a0,str2			#print_string(str1)
	li $v0,4
	syscall
	li $t2,0

#imprimir
while3:	
	bgeu $t2,10,end			# while(k < SIZE) {
	lw $t1,0($t6)			# $t1 = lista;
					#print_int10(lista)
	
	move $a0,$t1
	li $v0,1			# print_int10(lista);
	syscall
	
 	la $a0,str3			#print_string(str3)
	li $v0,4
	syscall
	
 	addi $t2,$t2,4 			# k++ de 4 em 4
 				# } 


end:
	jr $ra				#termina o programa
