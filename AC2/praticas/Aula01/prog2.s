#int main(void)
#{
# 	char c;
# 	do
# 	{
# 		c = getChar();
# 		if( c != '\n' )
# 		putChar( c );
# 	} while( c != '\n' );
# 	return 0;
#} 

	 .equ getChar,2
	 .equ putChar,3
	 .data
	 .text
	 .globl main
main: 
do:	  li $v0,getChar
	  syscall
	  move $t0, $v0		# (c = getChar())

if:	  beq $t0,'\n',while
	  move $a0,$t0
	  li $v0,putChar
	  syscall
	  
while: beq $a0,'\n',endw
	   j do
	  
endw: li $v0,0 # return 0;
	  jr $ra 
