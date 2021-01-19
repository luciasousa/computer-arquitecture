#int main(void)
# {
# int value;
# while(1)
# {
# printStr("\nIntroduza um numero (sinal e módulo): ");
# value = readInt10();
# printStr("\nValor lido, em base 2: ");
# printInt(value, 2);
# printStr("\nValor lido, em base 16: ");
# printInt(value, 16);
# printStr("\nValor lido, em base 10 (unsigned): ");
# printInt(value, 10);
# printStr("\nValor lido, em base 10 (signed): ");
# printInt10(value);
# }
# return 0;
# } 

	 .equ printStr,8
	 .equ printInt,6
	 .equ printInt10,7
	 .equ readInt10, 5
	 .data
s1:	 .asciiz "\nIntroduza um numero (sinal e módulo): "
s2:  .asciiz "\nValor lido, em base 2: "
s3:  .asciiz "\nValor lido, em base 16: "
s4:  .asciiz "\nValor lido, em base 10 (unsigned): "
s5:  .asciiz "\nValor lido, em base 10 (signed): "
	 .text
	 .globl main
main: 

while: la $a0,s1
	   li $v0,8
	   syscall
	   
	   li $v0,5
	   syscall
	   move $t0,$v0
	   
	   la $a0,s2
	   li $v0,8
	   syscall
	   
	   move $a0, $t0
	   li $a1, 2
	   li $v0,6
	   syscall
	   
	   la $a0,s3
	   li $v0,8
	   syscall
	   
	   move $a0, $t0
	   li $a1,16
	   li $v0,6
	   syscall
	   
	   la $a0,s4
	   li $v0,8
	   syscall
	   
	   move $a0, $t0
	   li $a1,10
	   li $v0,6
	   syscall
	   
	   la $a0,s5
	   li $v0,8
	   syscall
	   
	   move $a0,$t0
	   li $v0,7
	   syscall
	   
	   j while

endw:  li $v0,0 # return 0;
	   jr $ra 
