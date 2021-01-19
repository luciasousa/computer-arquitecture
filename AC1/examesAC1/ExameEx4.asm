	.data
f1:	.float 13.5
	
	.text
	.globl ypto
ypto:	mul.s $f0,$f12,$f12
	mtc1 $a0,$f2
	cvt.s.w $f2,$f2
	add.s $f0,$f0,$f2
if1:	xori $t0,$a0,3
	bne $t0,1,endif1
	l.s $f4,f1
	sub.s $f0,$f0,$f4
	
endif1:	mtc1 $0,$f4
	c.lt.s $f0,$f4
	bc1f endif2
	l.s $f4,f1
	sub.s $f0,$f0,$f4
	
endif2:	cvt.w.s $f4,$f0
	mfc1 $t0,$f0
	bne $t0,3,endif3
	add.s $f0,$f0,$f2
	
endif3:	jr $ra