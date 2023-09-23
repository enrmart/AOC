.data
.text
logaritmos:
	addi $sp $sp -4
	sw $ra ($sp)
	
	addi $sp $sp -4
	sw $s0 ($sp) 
	
	addi $sp $sp -4
	sw $s1 ($sp)
	
	addi $sp $sp -4
	sw $s2 ($sp)
	
	move $s1 $a1	#cadenafinal
	
	li $v1 0
	
	jal atoi
	
	move $a0 $v0
	move $s0 $v0	#resultado atoi
	
	
	jal log2
	
	beq $v1 1 ErrorLog
	
	move $s2 $v0	#resultado log2
	
	move $a0 $s0
	
	jal log10
	
	beq $v1 1 ErrorLog
	
	move $a0 $s2		#resultado log2
	
	move $a1 $s1		#cadena final
	
	jal itoa
	
	li $t0 32
	sb $t0($t6)		#espacio
	
	addi $t6 $t6 1
	
	move $a1 $t6		#cadena con log2 y espacio
	
	move $a0 $v0		#resultado log10
	
	jal itoa
	
	li $v0 0		#acierto
	
	j DevolverLog

ErrorLog: 	
	li $v0 3		#no posible calcular log
	
DevolverLog:
	lw $s2 ($sp)		#restauro $s2
	addi $sp $sp 4
	
	lw $s1 ($sp)		#restauro $s1
	addi $sp $sp 4
	
	lw $s0 ($sp)		#restauro $s0
	addi $sp $sp 4
	
	lw $ra ($sp)		#restauro $ra
	addi $sp $sp 4
	jr $ra
	
atoi:	
	li $t2,0
	li $t1,0
	li $t3,10
	li $t4,0

	
BuscaNum:#bucle hasta que encontramos algo que sea un numero
	lb $t0($a0)
	addi $a0 $a0 1
	beq $t0 45 Neg   #-
	beq $t0 '+' BuscaNum       #Ignoramos los +
	beq $t0 ' ' BuscaNum       #Ignoramos los espacios
	bgt $t0 '9' Errorcar       #Algo distinto de un numero error
	blt $t0 48 Errorcar        #Algo distinto de un numero error
	addi $t0 $t0 -48
	add $t2 $t2 $t0           #primer digito que es un numero
	
Calc:#calculamos el numero
	lb $t0($a0)
	beq $t0 $zero CompSig     #fin cadena 
	bgt $t0 '9' CompSig       # fin si distinto de numero 
	blt $t0 '0' CompSig       # fin si distinto de numero
	addi $t0 $t0 -48        #carac to num
	multu $t2 $t3           #*10
	mflo $t2
	mfhi $t4
	
	bne $t4 $zero Overflow	#HI!=0
	
	blt $t2 $zero Overflow	#LOW<0
			
	addu $t2 $t2 $t0 	#num
	
	blt $t2 $zero Min_Init	#num<0
	
	addi $a0 $a0 1
	
	b Calc
	
CompSig:
	beq $t1 0 AciertoPos	#detecta si es negativo
	subu $v0 $zero $t2            #numero en negativo
	 jr $ra
	 
AciertoPos:
	move $v0 $t2		#numero pos
	jr $ra
	
Neg:	
	addi $t1,$t1,1            #sirve para indicar que es un numero negativo
	j BuscaNum

Min_Init:
	bne $t2 -2147483648 Overflow	#Min_int
	
	bne $t1 $zero CompSig	#Minimo sin leer negativo no Overflow
	

Overflow:
	li $v0 2
	j VolverError
		
Errorcar:
	li $v0 1 
	
VolverError: #vuelve al main si hay un error
	lw $s2 ($sp)		#restauro $s2
	addi $sp $sp 4
	
	lw $s1 ($sp)		#restauro $s1
	addi $sp $sp 4
	
	lw $s0 ($sp)		#restauro $s0
	addi $sp $sp 4
	
	lw $ra ($sp)		#restauro $ra
	addi $sp $sp 4
	jr $ra

itoa:
	move $t0 $a0		# numero a convertir
	move $t4 $a1		
	move $t5 $t4		#donde se guarda el numero convertido
	li $t1 10		#cargamos un 10
	bgez $t0 Div		# <0?
		
Div:

	divu $t0 $t1
	mfhi $t2 		# guardo el resto
	addi $t2 $t2 48
	mflo $t0 		# guardo el cociente
	sb $t2 ($t5)		# almaceno el resto
	addi $t5 $t5 1 		
	bne $t0 0 Div 		# si es = 0 el cociente sale
	move $t6 $t5 		# guardo ultima posicion cadena
	addi $t5 $t5 -1		
	
Invertircad:

	lb $t2 ($t4) 		# cargo la primera posicion en t2
	lb $t3 ($t5)		# cargo la ultima  posicion en t3
	sb $t2 ($t5)		# almaceno t2 en t5 
	sb $t3 ($t4)		# almaceno t3 en t4
	addi $t4 $t4 1
	addi $t5 $t5 -1
	bge $t5 $t4 Invertircad 	# Comparamos si t5 es mayor que t4
	sb $zero ($t6) 		# fin de cadena
	jr $ra	


	
	

	

	
		
			
				
					
						
							
																															
									
