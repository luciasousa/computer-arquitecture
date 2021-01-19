# Mapa de registos
# array: $t0
# i: $t1
# pos: $t2
# 
#
 	.data
array: 	.space 12
str1: 	.asciiz ", "
 	.eqv print_string,4
 	.eqv print_int10,1
 	.eqv SIZE,3
 	.text
 	.globl main
 	
main:

insert:	li $t0,8
if:	ble $t2,SIZE,else
	li $v0,1
		
else:	blt $t1,$t2,endw
		 	
endw: 	
	li $v0,0

print_array:
