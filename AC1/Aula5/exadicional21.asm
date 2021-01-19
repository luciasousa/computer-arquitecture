# Mapa de registos
# array: $t0
# i: $t1
# array + i: $t2
# array[i]: $a0
#
 	.data
array: 	.word str1,str2,str3
str1: 	.asciiz "Array"
str2: 	.asciiz "de"
str3: 	.asciiz "ponteiros"
 	.eqv print_string,4
 	.eqv print_char,11
 	.eqv SIZE,3
 	.text
 	.globl main
main: 	la $t0,array 			# $t0 = &(array[0]);
 	li $t1,0 			# i = 0;
for: 	bge $t1,SIZE,endw		# while(i < SIZE) {
	la $t8,array			# $t8 = lista (ou &lista[0])
 	addu $t1,$t8,$t1 		# $t1 = &array[i] array+i
	lw $a0,	0($t1)			# a0 = array[i];
	li $v0,4
 	syscall
 	li $a0,'\n'
 	li $v0,11
 	syscall
	lw $a0,	4($t1)			# a0 = array[i];
	li $v0,4
 	syscall
 	li $a0,'\n'
 	li $v0,11
 	syscall
	lw $a0,	8($t1)			# a0 = array[i];
 	li $v0,4
 	syscall
 	
 	addi $t1,$t1,1
 	j for
endw: 	jr $ra 
