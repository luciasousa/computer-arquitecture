# void wait(int);
# int main(void)
# {
# int s = 0;
# int cnt = 0;
# char c;
# do
# {
# putChar('\r'); // Carriage return character
# printInt( cnt, 10 | 3 << 16 ); // 0x0003000A: decimal w/ 3 digits
# putChar('\t'); // Tab character
# printInt( cnt, 2 | 8 << 16 ); // 0x00080002: binary w/ 8 bits
# wait(5);
# c = inkey();
# if( c == '+' )
# s = 0;
# if( c == '-' )
# s = 1;
# if( s == 0 )
# cnt = (cnt + 1) & 0xFF;
# else
# cnt = (cnt - 1) & 0xFF;
# } while( c != 'q' );
# return 0;
# }
# void wait(int ts)
# {
# int i;
# for( i=0;i < 515000 * ts; i++ );
# } 

		.equ printInt,6
		.equ inkey,1
		.equ putChar,3
		.data
		
		.text
		.globl main
		
main: 	li $t0,0			#cnt=0
		li $t6,0			#s=0

do:		la $a0,'\r'
		li $v0,3
		syscall
		
		li $t1,3
		sll $t2,$t1,4
		ori $t3,$t2,10
		move $a0,$t0
		move $a1,$t3
		li $v0,6
		syscall
		
		li $a0,'\t'
		li $v0,3
		syscall
		
		li $t0,0
		li $t1,8
		sll $t2,$t1,4
		ori $t3,$t2,2
		move $a0,$t0
		move $a1,$t3
		li $v0,6
		syscall
		
		li $a0,5
		jal wait
		
		li $v0,1
		syscall
		move $t0, $v0
		
if1: 	bne $t0,'+',if2
		li $t6,0

if2: 	bne $t0,'-',if3
		li $t6,1

if3:	bne $t0,0,else
		add $t0,$t0,1
		and $t0,$t0,0xFF

else:	sub $t0,$t0,1
		and $t0,$t0,0xFF
		
while:  beq $t0,'q',do
		
		
		li $v0,0 # return 0;
		jr $ra 


########## W A I T ############

wait:	li $t0,0
	li $t2,515000
	mult $a0,$t2

for:	
	bge $t0, $t1, endf
	addi $t0,$t0,1
	j for

endf: 	jr $ra
