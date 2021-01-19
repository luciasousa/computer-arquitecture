#int main(void)
#{
# 	char c;
# 	do
# 	{
# 		while( (c = inkey()) == 0 ); 
# 		if( c != '\n' )
# 			putChar( c );
# 	} while( c != '\n' );
# 	return 0;
#} 

	 .equ inkey,1
	 .equ putChar,3
	 .data
	 .text
	 .globl main
main: 
do:	  
	
	  li $v0,inkey
	  syscall
	  move $t0, $v0		#t0 = inkey
	  
while1: beq $t0,0,do	  

if:	  beq $t0,'\n',while2
	  move $a0,$t0
	  li $v0,putChar
	  syscall
	  
while2: beq $a0,'\n',endw2
	    j do
	  
endw2: li $v0,0 # return 0;
	   jr $ra 
