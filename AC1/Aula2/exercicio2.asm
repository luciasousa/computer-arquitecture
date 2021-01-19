	.data
	.text
	.globl main
main: 	li  $t0, 0x12345678 # instrução virtual decomposta em duas 
			    # instruçoes nativas
	#sll $t2, $t0, 4    # Shift left logical
	#srl $t3, $t0, 4    # Shift right logical
	#sra $t4, $t0, 4    # Shift right arithmetic
	
	# binary to gray
	or  $t5, $t0, $0   # $t5 contém o valor em bin
	sra $t2, $t5, 1    # bin >> 1 shift right arithmetic
	xor $t1, $t5, $t2  # bin ^ (bin >> 1)
	
	#gray to binary
	or  $t1, $t0, $0    #num = gray
	
	sra $t4, $t1, 4     #(num >> 4)
	xor $t1, $t1, $t4   #num = num ^ (num >> 4)

	sra $t5, $t1, 2     #(num >> 2)
	xor $t1, $t1, $t5   #num = num ^ (num >> 2)
	
	sra $t6, $t1, 1     #(num >> 1)
	xor $t1, $t1, $t6   #num = num ^ (num >> 1)
	
	or $t2, $t1, $0     #bin = num
	
	jr  $ra		    # Fim do programa
	