# Mapa de registos
# p: $t0
# *p $t1

	.data
str1:	.asciiz "Introduza string: "
str2: 	.asciiz "String alterada: "
str:	.space 20
	.eqv SIZE,20
	.eqv print_str,4
	.eqv read_str,8
	.text
	.globl main

main:	
	la $a0, str1		# imprimir string
	li $v0,print_str
	syscall
	
	la $a0, str		# ler do teclado
	li $a1, SIZE
	li $v0, read_str
	syscall
	
	la $t0,str		# p = str
	
while:  
	lb $t1,0($t0)		# while(*p != '\0')
	beq $t1, '\n', endw
	sub $t1, $t1, 0x41	# *p = *p - 'A'
	addi $t1, $t1, 0x61	# *p = *p + 'a'
	sb $t1,0($t0)		# substituir, guarda $t1 em $t0
	addi $t0,$t0,1		# p++
	j while

endw:
	la $a0, str2		# imprimir str2
	li $v0, print_str
	syscall
	
	la $a0, str		# imprimir a string alterada
	li $v0, print_str
	syscall
	
	jr $ra			#terminar programa
