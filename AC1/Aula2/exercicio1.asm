	.data
	.text
	.globl main

main:	ori $t0, $0, 0xe543 # substituir val_1 e val_2 
	ori $t1, $0, 0x000f # pelos valores pretendidos
	nor $t1, $t0, $0   # ~($t0 | $0) = ~ $t0 (bitwise)
	and $t2, $t0, $t1  # $t2 = $t0 & $t1    (bitwise)
	or  $t3, $t0, $t1  # $t3 = $t0 | $t1    (bitwise)
	nor $t4, $t0, $t1  # $t4 = ~($t0 | $t1) (bitwise)
	xor $t5, $t0, $t1  # $t5 = $t0 ^ $t1    (bitwise)
	jr $ra		   # fim do programa