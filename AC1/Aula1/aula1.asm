	.data
				#nada
	.text
	.globl main

main:	#ori $t0, $0, 3		# $t0 = x (x = 3, p.e.)
				#fazer com vários valores para x
#exercicio 3
	ori $v0, $0, 5
	syscall			# chamada ao syscall "read_int()"
	
	or $t0, $0, $v0		# $t0 = $v0 = valor lido do teclado
				#valor de x 
	ori $t2, $0, 8		# $t2 = 8
	
	add $t1, $t0, $t0	# $t1 = $t0 + $t0 = x + x = 2 * x
	
#exercicio 1
	#add $t1, $t1, $t2	# $t1 = $t1 + $t2 = y = 2 * x + 8
	
#exercicio 2
	sub $t1, $t1, $t2	# $t1 = $t1 - $t2 = y = 2 * x - 8
	
	or $a0, $0, $t1
	
#exercicio 3
	ori $v0, $0, 36
	syscall 		# chamada ao syscall "print_int10()"
	
	jr $ra			# fim do programa
