.data
Cadena:.asciiz"2x+2y=5"
.align 2
Espacio:.space 20
.text
Main:
la $a0 Cadena 
la $a1 Espacio

jal String2Ecuacion

move $a0 $t2
li $v0 1
Syscall

move $a0 $t0
li $v0 11
Syscall

li $v0 10 
Syscall

String2Ecuacion:

	li $t1,0	
	li $t2,0
	li $t3,10
	li $t5,0
	li $t6,0
	addi $t7 $a1 12
	
Buscaincong:#bucle hasta que encontramos algo que sea un numero
	lb $t0($a0)
	addi $a0 $a0 1
	beq $t0 45 Negincong   #-
	beq $t0 '=' Buscaincong
	beq $t0 '+' Buscaincong      #Ignoramos los +
	beq $t0 ' ' Buscaincong      #Ignoramos los espacios
	bgt $t0 '9' CompruebaIncog    #Algo distinto de un numero error
	blt $t0 48 CompruebaIncog      #Algo distinto de un numero error
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
	beq $t1 0 CompruebaIncog	#detecta si es negativo
	subu $v0 $zero $t2            #numero en negativo
	
CompruebaIncog: 
	blt $t0 'a' Errorcar
	bgt $t0 'z' CompruebaMayus
	sw $t2 ($a1)
	sb $t0 ($t7)
	addi $a1 $a1 4
	addi $t7 $t7 1
	j Buscaincong
	
CompruebaMayus:
	bgt $t0 'Z' Errorcar
	blt $t0 'A' Errorcar
	sw $t2 ($a1)
	sb $t0 ($t7)
	addi $a1 $a1 4
	addi $t7 $t7 1
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