#-------------------------------------------------
#EXERCICIO 3 c)
	#.data
#str1: 	.asciiz "Hello world"
#str2: 	.asciiz "AC1 – P"
	#.eqv 	print_string, 4
	#.text
	#.globl main
#main: 	la $a0, str2	#instrução virtual, decomposta pelo assembler
			#em 2 instruções nativas
	#ori $v0, $0, print_string #$v0 = 4
	#syscall		#print_string(str2)
	#jr $ra		#fim do programa
#--------------------------------------------------
	.data
str1: 	.asciiz "Introduza 2 numeros\n"
str2: 	.asciiz "A soma dos dois numeros é: "
	.eqv print_string,4
	.eqv read_int,4
	.eqv print_int10,4
	.text
	.globl main
main:	la $a0,str1
	ori $v0,$0,print_string
	syscall # print_string(str1)
	#ler inteiro a
	ori $v0,$0,read_int
	syscall # valor lido é retornado em $v0
	or $t0,$v0,$0 # $t0=read_int()
	#ler inteiro b
	ori $v0,$0,read_int
	syscall # valor lido é retornado em $v1
	or $t1,$v0,$0 # $t1=read_int()
	add $t2,$t1,$t0
	
	la $a0,str2
	ori $v0,$0,print_string
	syscall # print_string(str2)
	
	or $a0,$t3,$0
      	ori $v0,$0, print_int10
	syscall #print_int10(a + b)
	
	jr $ra # fim do programa
