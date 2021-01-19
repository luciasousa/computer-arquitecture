# Mapa
# i = $t0
# bit = $t1
# quociente = $t2
# resto = $t3
# dividendo = $t8
# divisor = $t9
	
	.data
str1: 	.asciiz "Introduza um dividendo: "
str11: 	.asciiz "Introduza um divisor: "
str2: 	.asciiz "\nQuociente: "
str3: 	.asciiz "\nResto: "
	.eqv read_int, 5
	.eqv print_string, 4
	.eqv print_int10, 1 
	.text
	.globl main

main:	la $a0,str1
	li $v0,4
	syscall
	
	li $a0,5
	li $v0,5
	syscall
	
	move $a0,$v0
	move $t8, $a0
	
	la $a0,str11
	li $v0,4
	syscall
	
	li $a0,5
	li $v0,5
	syscall
	
	move $a0,$v0
	move $t9, $a0
	
	jal divi
	
	jr $ra	
			
divi:	
	
	sll $t9, $t9, 16		#divisor = divisor << 16; 
	andi $t4, $t8, 0xFFFF		#$t4 = (dividendo & 0xFFFF)
	sll $t8, $t4, 1			#dividendo = $t4 << 1; 
	
	li $t0,0			#i = 0
	 
for:	bge $t0,16,endfor		#i<16
	li $t1,0			#bit = 0
	
if:	blt $t8,$t9,endif		#if(dividendo >= divisor) 
	sub $t8,$t8,$t9			#dividendo = dividendo - divisor;
 	li $t1,1			#bit = 1; 
	
endif: 	sll $t5,$t8,1			#$t5 = (dividendo << 1)
	or $t8,$t5,$t1			#dividendo = $t5 | bit; 
	addi $t0,$t0,1			#i++
	j for
	
endfor:	srl $t6,$t8,1			#$t6 = (dividendo >> 1)
	andi $t3,$t6,0xFFFF0000		#resto = $t6 & 0xFFFF0000; 
	andi $t2,$t8,0xFFFF		#quociente = dividendo & 0xFFFF; 

	la $a0, str2
	li $v0,4
	syscall	
	
	li $v0, 1
	move $a0, $t2		
	syscall
	
	la $a0, str3			
	li $v0,4
 	syscall
 	
 	li $v0, 1
	move $a0, $t3		
	syscall
	
	jr $ra
