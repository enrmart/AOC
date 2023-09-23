#Esta practica ha sido desarrollada por Martin Calvo,Enrique y San Jose Dominguez,Fernando
.data
.align 2
Ec_1:.space 20
.align 2
Ec_2:.space 20
.text
ResuelveSistema:
	sw $t0($sp)		#Guardamos extremos 
	addi $sp $sp -4
	move $s0 $a0
	move $s1 $a1
	move $s2 $t2
	move $s3 $t3
	sw $t1 ($sp)
	addi $sp $sp -4
	move $s4 $t4
	move $s5 $t5
	move $s6 $t6
	move $s7 $t7
	la $a1 Ec_1
	sw $ra ($sp)
	jal String2Ecuacion
	bne $v0 0 VolverMain	#Error acaba
	move $a0 $s1
	la $a1 Ec_2
	jal String2Ecuacion
	bne $v0 0 VolverMain 	#Error acaba 
	la $a0 Ec_1
	la $a1 Ec_2
	jal Cramer		 
	move $a0 $a2
	jal Solucion2String
	move $a2 $a1
	

	
	
	
VolverMain:
	move $a0 $s0
	move $a1 $s1
	move $t2 $s2
	move $t3 $s3
	move $t4 $s4
	move $t5 $s5
	move $t6 $s6
	move $t7 $s7
	lw $t0 4($sp)
	lw $t1 8($sp)
	lw $ra 12($sp)
	jr $ra

String2Ecuacion:
	li $t1,0	
	li $t2,0
	li $t3,10
	li $t5,0
	li $t6,0
	addi $t7 $a1 12
	li $t8,0
	
Buscaincong:#bucle hasta que encontramos algo que sea un numero
	lb $t0($a0)
	addi $a0 $a0 1
	beq $t0 45 Negincong   #-
	beq $t0 '=' Buscaincong
	beq $t0 '+' Buscaincong      #Ignoramos los +
	beq $t0 ' ' Buscaincong      #Ignoramos los espacios
	bgt $t0 '9' CompruebaIncog    #Algo distinto de un numero error
	blt $t0 48 CompruebaIncog      #Algo distinto de un numero error
	addi $t8 $t8 1
	addi $t0 $t0 -48
	add $t2 $t2 $t0           #primer digito que es un numero
	
Calcparam:#calculamos el numero
	lb $t0($a0)
	addi $a0 $a0 1
	beq $t0 $zero Volver  #fin cadena 
	bgt $t0 '9' CompruebaIncog       # fin si distinto de numero 
	blt $t0 '0' CompruebaIncog     # fin si distinto de numero
	addi $t0 $t0 -48        #carac to num
	multu $t2 $t3           #*10
	mflo $t2
	mfhi $t4
	
	bne $t4 $zero Overflow	#HI!=0
	
	blt $t2 $zero Overflow	#LOW<0
			
	addu $t2 $t2 $t0 	#num
	
	blt $t2 $zero Min_Init	#num<0
	
	b Calcparam
CompSig:
	
	subu $v0 $zero $t2            #numero en negativo
	bne $t8 0 Guardavariables
CompruebaIncog: 
	blt $t0 'a' Errorcar
	bgt $t0 'z' CompruebaMayus
	bne $t8 0 Guardavariables
	li $t2 1
	bne $t1 0 CompSig
	sw $t2 ($a1)
	sw $t0 ($t7)
	addi $a1 $a1 4
	addi $t7 $t7 4
	j Buscaincong
	
CompruebaMayus:
	bgt $t0 'Z' Errorcar
	blt $t0 'A' Errorcar
	bne $t8 0 Guardavariables
	li $t2 1
	bne $t1 0 CompSig
	sw $t2 ($a1)
	sw $t0 ($t7)
	addi $a1 $a1 4
	addi $t7 $t7 4
	j Buscaincong
Guardavariables:
	bne $t1 0 CompSig
	sw $t2 ($a1)
	sw $t0 ($t7)
	addi $a1 $a1 4
	addi $t7 $t7 4
	j Buscaincong
	
Negincong:	
	addi $t1,$t1,1            #sirve para indicar que es un numero negativo
	j Buscaincong
	
Min_Init:
	bne $t2 -2147483648 Overflow	#Min_int
	
	bne $t1 $zero CompSig	#Minimo sin leer negativo no Overflow


Overflow:
	li $v0 2
	j Volver
		
Errorcar:
	li $v0 1 

Volver:
	sw $t2 ($a1)
	jr $ra
