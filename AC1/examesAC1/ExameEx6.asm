.eqv	id,0
.eqv	count,4
.eqv	data, 8
	.data
	.text
	.globl sum
sum:	
	mtc1 $0,$f0
	li $t0,0
for1:	bge $t0,$a0,endfor1
	li $t1,0
for2:	mul $t3,$t0,48
	addu $t2,$t2,$a1
	lw $t4,count($t2)
	bge $t1,$t4,endfor2
	bge $t1,10,endfor2
	add $t5,$t2,data
	sll $t6,$t1,2
	addu $t5,$t5,$t6
	l.s $f2,0($t5)
	add.s $f0,$f0,$f2
	
	addi $t1,$t1,1
	j for2
endfor2:
	addi $t0,$t0,1
	j for1
endfor1:
	jr $ra