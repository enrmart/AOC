.data
.text

atoi:	
	li $t0,0
	li $t2,0
	li $t2,0
BuscaNum:	
	lb $t0($a0)
	addi $a0 $a0 1
	beq $t0 45 Neg
	beq $t0 ' ' atoi
	bgt $t0 '9' Errorcar
	blt $t0 48 Errorcar
	addi $t0 $t0 -48
	add $t2 $t2 $t0
	li $t3 10
	
Calc:#calculamos el numero
	lb $t0($a0)
	beq $t0 $zero CompSig
	bgt $t0 '9' CompSig
	blt $t0 '0' CompSig
	addi $t0 $t0 -48
	mult $t2 $t3
	mflo $t2
	mfhi $t9
	bnez $t9 Overflow
	add $t2 $t2 $t0
	addi $a0 $a0 1
	b Calc
CompSig:
	beq $t1 0 AciertoPos
	li $v1 0
	sub $v0 $zero $t2
	 j Volver
AciertoPos:
	li $v1 0
	move $v0 $t2
	j Volver
Neg:	
	addi $t1,$t1,1
	j BuscaNum

Overflow:
	li $v1 2
	j Volver	
Errorcar:
	li $v1,1 
Volver: 
	jr $ra

	
	
