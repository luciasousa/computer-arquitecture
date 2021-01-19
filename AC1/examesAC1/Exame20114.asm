	.data
	.text
	.globl total
total:	
	li $t0,1
	sub.s $f2,$f2,$f2
	sub.d $f0,$f0,$f0
	move $t1,$a0
	sll $a1,$a1,2
	add $t2,$a0,$a1
for:	bgeu $t1,$t2,endfor
	l.d $f4,0($t1)
	c.lt.d $f0,$f4
	bc1t if
	rem $t3,$t0,2
	bnez $t3,if
	j endif
if:
	mtc1 $t0,$f6
	cvt.d.w $f6,$f6
	mul.d $f6,$f6,$f4
	cvt.s.d $f6,$f6
	add.s $f2,$f2,$f6
endif:	
	addi $t0,$t0,1
	addiu $t1,$t1,4
	j for
endfor:
	mov.s $f0,$f2
	jr $ra