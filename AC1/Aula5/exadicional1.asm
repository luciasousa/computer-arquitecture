#Mapa de registos
#$t0 - i
#$t1 - j
#$t2 - aux
#$t3 - lista
# $t4 - lista + i
	
	.data
	.eqv SIZE, 40
	.eqv read_int, 5
	.eqv print_string,4
	.eqv print_int10,1
lista:	.space 10
str1:	.asciiz "\nIntroduza um número: "
str2:	.asciiz "\nFuncionou "
	.text
	.globl main
	
main:	la $t3,lista
	li $t0,0
	li $t1,0
	li $t2,0
	li $t6,0
	
while:	
	bge $t6,SIZE,endw		# while(i < SIZE)
	
	la $a0,str1			#print_string(str1)
	li $v0,4
	syscall
	
	li $v0,5			# $v0 = read_int();
	syscall
	
	la $t7,lista 			# $t1 = lista (ou &lista[0])
 	sll $t8,$t6,2 
 	addu $t8,$t7,$t8 		# $t2 = &lista[i]
	sw $v0,	0($t8)			# lista[i] = read_int();
	addi $t6,$t6,1 			# i++
	j while 			# }
	
endw: 	j while1

while1:	bge $t0, 36, endw1
	addi $t1, $t0, 1
	
while2: bge $t1,40,endw2
	addu $t4,$t3,$t0 	# $t4 = lista+i ou &lista[i]
	lb $t4,0($t3) 		# $t4 = lista[i]
	addu $t5,$t3,$t1 	# $t4 = lista+j ou &lista[j]
	lb $t5,0($t3) 		# $t4 = lista[j]
	ble $t4,$t5,endif
	move $t2,$t4
	move $t4,$t5
	move $t5,$t2
	
endif:	addi $t1,$t1,1
	j while2
endw2:	addi $t0,$t0,1
	j while1
endw1:	
	la $a0,str2			#print_string(str1)
	li $v0,4
	syscall
	
	jr $ra