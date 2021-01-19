# Mapa de registos:
# $t0 – gray
# $t1 – mask
# $t2 - bin	
	.data
str1:	.asciiz "Introduza um número: "
str2:	.asciiz "Valor em código de Gray: "
str3: 	.asciiz "\nValor em binário: "
	.eqv print_string, 4
	.eqv read_int, 5
	.eqv print_int16, 34
	.text
	.globl main

main:
	#imprimir str1
	la $a0, str1
	li $v0, 4
	syscall
	
	#introduzir inteiro
	li $a0, 0
	li $v0, 5
	syscall
	
	#passar int para registo $t0
	move $t0, $v0
	
	#shift para a direita de 1
	srl $t1, $t0, 1
	
while:
	beqz $t1,endw
	xor $t2, $t2, $t1
	srl $t1, $t1, 1
	
endw:	#imprimir str2
	la $a0, str2
	li $v0, 4
	syscall
	
	#imprimir gray
	move $a0, $t0
	li $v0, 34
	syscall
	
	#imprimir str3
	la $a0, str3
	li $v0, 4
	syscall
	
	#imprimir binário
	move $a0, $t2
	li $v0, 34
	syscall
	
	jr $ra			#fim do programa