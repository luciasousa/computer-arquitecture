	.text
	.globl zpto
zpto:	addiu $sp,$sp,-4
	sw $ra,0($sp)
	sw $s1,4($sp)
	s.s $f20,8($sp)
	s.s $f21,12($sp)

	move $s1,$a1
	mtc1 $a0,$f20
	cvt.d.w $f20,$f20
if:	ble $a0,10,else
	subi $a0,$a0,10
	addiu $a1,$a1,10
	jal zpto
	cvt.d.s $f4,$f0
	add.d $f20,$f4,$f20
	j endif
else:	l.d $f4,8($s1)
	add.d $f20,$f20,$f4
	l.d $f4,0($s1)
	l.d $f6,16($s1)
	c.le.d $f4,$f6
	bc1t endif2
	l.d $f4,24($s1)
	add.d $f20,$f20,$f4
endif2:	
endif:	cvt.s.d $f0,$f20
	lw $ra,0($sp)
	lw $s1,4($sp)
	l.s $f20,8($sp)
	l.s $f21,12($sp)
	jr $ra