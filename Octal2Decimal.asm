.data
	mensaje1: .asciiz "Ingrese el numero en formato octal (ej. +52, -52): --> "
	num_cadena: .space 9
	mensaje2: .asciiz "El numero en formato decimal es --> "
	salto: .asciiz "\n"

.text
	# Imprimir mensaje de lectura
	li $v0 4
	la $a0 mensaje1
	syscall
    
	# Leer la cadena de entrada
	li $v0 8
	la $a0 num_cadena
	li $a1 9
	syscall

	# Iterador para recorrer la cadena
	li $t9 0           
	# Acumulador para el resultado decimal
	li $t6 0           
	# Base octal
	li $t8 8
	# Signo           
	li $t5 1           

	# Leer el primer caracter para determinar el signo
	lb $t0 num_cadena($t9)
	beq $t0 0x2B positivo   
	beq $t0 0x2D negativo  

positivo:
	addi $t9, $t9, 1       
	b loop1

negativo:
	# Se establece el  signo negativo
	li $t5 -1
	addi $t9 $t9 1        
	b loop1

loop1:
	lb $t0 num_cadena($t9)
	beqz $t0 fin_loop1
	beq $t0 0xA fin_loop1
    
    	# Convertir caracter octal a valor numérico
	sub $t0 $t0 0x30
    	mul $t6 $t6 $t8       
	add $t6 $t6 $t0       
    
	addi $t9 $t9 1        
	b loop1

fin_loop1:
    # Aplicar el signo al resultado
    mul $t6 $t6 $t5

    # Imprimir resultado
    li $v0 4
    la $a0 salto
    syscall
    li $v0 4
    la $a0 mensaje2
    syscall
    
    li $v0 1
    move $a0, $t6
    syscall
    
    # Terminar programa
    li $v0 10
    syscall
