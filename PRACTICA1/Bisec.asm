.data
Cero:.float 0
Dos:.float 2
.text
la $t2,Dos
lwc1 $f3,($t2)

li $v0,6
syscall

mov.s $f12 $f0#a

li $v0,6
syscall

mov.s $f13 $f0#b

mov.s $f16 $f12


jal Funcion

mov.s $f15 $f0

mov.s $f16 $f13

jal Funcion

mov.s $f16 $f0
li $v0,6
syscall
	
mov.s $f14 $f0

jal Bisec
move $a0 $v0
li $v0,1
syscall
mov.s $f12 $f0
li $v0 2
syscall
li $v0,10
syscall	
Bisec:  	addiu  $sp $sp -4#Guardar 
	sw $ra,($sp)
	
	mov.s $f16 $f12


	jal Funcion

	mov.s $f15 $f0

	mov.s $f16 $f13

	jal Funcion

	mov.s $f16 $f0
	
	la $t1,Cero
	lwc1 $f2,0($t1)
	
	c.eq.s $f15 $f2#Si a=0 acaba
	li $v0,0
	mov.s $f0 $f12
	bc1t DevolverBisec

	c.eq.s $f16 $f2# Si b=0 acaba
	li $v0,0
	mov.s $f0 $f13
	bc1t DevolverBisec

	c.lt.s $f15 $f2#a<0
	bc1t CompMay

	c.lt.s $f2 $f16#b>0
	li $v0,1
	bc1t DevolverBisec
	
	add.s $f4,$f4,$f3#comp=2
	jal Recur
	
	b DevolverBisec
	 
CompMay:
 	c.lt.s $f16 $f2#b<0
 	li $v0,1#No se puede dar
 	bc1t DevolverBisec
 	
 	add.s $f4,$f4,$f2#comp=0
 	jal Recur 
 
DevolverBisec: 	#Vuelve al main
	lw $ra($sp)
	addi $sp $sp 4
	jr $ra 
	
Recur:	addiu  $sp $sp -4#Guardar 
	sw $ra,($sp)
	
	la $t2, Dos
	lwc1 $f3,0($t2)
	
	add.s $f0 $f12 $f13
	div.s $f1 $f0 $f3 #p
	mov.s $f16 $f1
	
	jal Funcion#imagen p
	
	la $t1, Cero
	lwc1 $f2,0($t1)
	
	mov.s $f23 $f0#imagen p
	
	c.eq.s $f23 $f2#Igual que 0 acaba
	li $v0,0
	mov.s $f0, $f1
	bc1t  DevolverRecu
	
	sub.s $f17 $f12 $f13
	abs.s $f18 $f17
	c.le.s $f18 $f14#Menor que el error acaba
	
	li $v0,0
	mov.s $f0, $f1
	
	bc1t  DevolverRecu
	
	c.eq.s $f4,$f2 #Si a<0 y b>0
	bc1t  CompNeg
	
	c.lt.s $f23 $f2 #Si a>0 y p<0
	mov.s $f20 $f13
	mov.s $f13 $f1 #b=p
	bc1t  VolverRecu
	
	mov.s $f13 $f20
	mov.s $f12 $f1#a=p
	b  VolverRecu

	
 	
CompNeg:
		
	c.lt.s $f2 $f23 #p<0 y a<0 
	mov.s $f20 $f13
	mov.s $f13 $f1#b=p
	bc1t VolverRecu
	
	mov.s $f13 $f20
	mov.s $f12 $f1#a=p
	b VolverRecu
VolverRecu:
	jal Recur 	

DevolverRecu: 	#Vuelve al main
	lw $ra,4($sp)
	addi $sp $sp 4
	jr $ra 


.data

Uno:.float 1

.text

Funcion:
la $t1,Uno
lwc1 $f2 ($t1)
mul.s $f0 $f16 $f16
mul.s $f0 $f0 $f16
#add.s $f0 $f0 $f2
jr $ra

