.data 
Numero:.asciiz "-------12A3"
.text 
la $a0, Numero
jal atoi
move $a0 $v0
li $v0 1 
syscall
li $v0 10
syscall

atoi:	
	li $t2,0
	li $t1,0
	li $t3,10
	li $t4,0
	li $t5,0
	li $t6,0
BuscaNum:#bucle hasta que encontramos algo que sea un numero
	lb $t0($a0)
	addi $a0 $a0 1
	beq $t0 45 Neg   #-
	beq $t0 '+' BuscaNum       #Ignoramos los +
	beq $t0 ' ' BuscaNum       #Ignoramos los espacios
	bgt $t0 '9' Errorcar       #Algo distinto de un numero error
	blt $t0 48 Errorcar        #Algo distinto de un numero error
	addi $t0 $t0 -48
	add $t4 $t4 $t0           #primer digito que es un numero
	
Calc:#calculamos el numero
	lb $t0($a0)
	beq $t0 $zero CompSig     #fin cadena 
	bgt $t0 '9' CompSig       # fin si distinto de numero 
	blt $t0 '0' CompSig       # fin si distinto de numero
	addi $t0 $t0 -48        #carac to num
	mult $t4 $t3           #*10
	mflo $t2
	or $t5, $t2, $t4  # $t0 = op1 ^ result
	or $t6, $t2, $t3   # $t1 = op2 ^ result
	and $t6, $t5, $t6   # $t0 = (op1 ^ result) & (op2 ^ result)
	blt  $t6 $zero Overflow
	addu $t4 $t2 $t0
	or $t5, $t2, $t4   # $t0 = op1 ^ result
	or $t6, $t0, $t4   # $t1 = op2 ^ result
	and $t6, $t5, $t6   # $t0 = (op1 ^ result) & (op2 ^ result)
	blt  $t6 $zero Overflow
	addi $a0 $a0 1
	b Calc
CompSig:
	beq $t1 0 AciertoPos	#detecta si es negativo
	li $v1 0
	sub $v0 $zero $t4             #numero en negativo
	 j Volver
AciertoPos:
	li $v1 0
	move $v0 $t4
	j Volver
Neg:	
	addi $t1,$t1,1            #sirve para indicar que es un numero negativo
	j BuscaNum

Overflow:
	li $v1 2
	j Volver	
Errorcar:
	li $v1,1 
Volver: #vuelve al main
	jr $ra
