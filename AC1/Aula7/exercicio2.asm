	.data
	.eqv read_int, 5
	.eqv print_string, 4
	.text
	.globl main
	
main:	
	li $v0,5			# $v0 = read_int();
	syscall
	move $a0, $v0
	jal itoa
	
	move $a0, $v0			#print_string
	ori $v0, $0, 4
	syscall
	
	jr $ra

# Mapa de registos
# n: $a0 -> $s0
# b: $a1 -> $s1
# s: $a2 -> $s2
# p: $s3
# digit: $t0
# Sub-rotina intermédia
itoa: 	subu $sp,$sp,32 			# reserva espaço na stack
 	sw $s0,4($sp) 			# guarda registos $sx e $ra
 	sw $s1,8($sp)
 	sw $s2,16($sp)
 	sw $s3,0($sp)
 	sw $ra,0($sp)
 	move $s0,$a0 			# copia n, b e s para registos
 	move $s1,$a1			# "callee-saved"
 	move $s2,$a2
 	move $s3,$a2 			# p = s;
do: 					# do {
 					#
 	ble $s0,0,endo 			# } while(n > 0);
 	sb $0,0($s3) 			# *p = 0;
 	move $a0, $s2			#
 	jal strrev 			# strrev( s );
 	move $v0, $s2			# return s;
 	lw $s0,0($sp)			# repõe registos $sx e $ra
 	lw $s1,0($sp)
 	lw $s2,0($sp)
 	lw $s3,0($sp)
 	lw $ra,0($sp)
 	addiu $sp,$sp,32 		# liberta espaço na stack
endo: 	jr $ra 				# 

toascii: addiu $t0,$t0,'0'		# v += '0'

if:	ble $t0, '9', endif
	addiu $t0,$t0,'7'
endif:	jr $ra

strrev: addiu $sp,$sp,-32 	# reserva espaço na stack
 	sw $ra,0($sp) 		# guarda endereço de retorno
 	sw $s0,4($sp) 		# guarda valor dos registos
 	sw $s1,8($sp) 		# $s0, $s1 e $s2
 	sw $s2,16($sp) 		#
 	move $s0,$a0 		# registo "callee-saved"
 	move $s1,$a0 		# p1 = str
 	move $s2,$a0 		# p2 = str
while1: lb $t0, 0($s2)
	beq $t0,'\0',endw1	# while( *p2 != '\0' ) {
 	addi $s2,$s2,1		# p2++;
 	j while1		# }
endw1: 	addi $s2,$s2,-1		# p2--;
	jr $ra 

