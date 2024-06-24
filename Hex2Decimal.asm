.data
	mensaje1: .asciiz "Por favor Introduzca un numero en Hexadecimal (ejemplo +F3): "
	# Definimos 8 espacios + espacio adicional
	num_cadena: .space 9
	mensaje2: .asciiz "El Numero Introducido convertido a Decimal es --> "
	salto: .asciiz "\n"

.text
	# Imprimir mensaje de lectura
	li $v0  4
	la $a0 mensaje1
	syscall
    
	# Leer la cadena de entrada
	li $v0 8
	la $a0 num_cadena
	li $a1 9
	syscall
	
	# Variable iteradora para recorrer la cadena
	li $t9 0           
	# Variable acumuladora para el resultado decimal
	li $t6 0	
	# Base hexadecimal           
	li $t8 16
      	# Signo         
	li $t5 1

	# Se lee el signo
	lb $t0 num_cadena($t9)
	beq $t0 0X2B positivo   
	beq $t0 0X2D negativo   

	positivo:
		# Avanzamos al siguiente caracter de la cadena
		addi $t9 $t9 1
		b loop1

	negativo:
		# Tomamos el signo negativo
		li $t5 -1       
		# Avanzamos al siguiente caracter de la cadena
		addi $t9 $t9 1        
		b loop1

	loop1:
		lb $t0 num_cadena($t9)
		
		# Condicion de parada
		beqz $t0 fin_loop1
		beq $t0 0xA fin_loop1
    
		# Convertir caracter hexadecimal a valor numérico
		# añadimos letra
		bgt $t0 0x39 revisar_letra
		addi $t0 $t0 -0x30
		b suma

		revisar_letra:
			sub $t0 $t0 0x37

		suma:
			# Multiplicamos el acumulador por 16
			mul $t6 $t6 $t8
			# Sumamos el valor numérico al acumulador
			add $t6 $t6 $t0
    
			addi $t9 $t9 1    
			b loop1
    
	fin_loop1:
    
    # Aplicacion de signo
	mul $t6 $t6 $t5

    # Printeo del resultado
	li $v0, 4
	la $a0, salto
	syscall
	
	li $v0, 4	
	la $a0, mensaje2
	syscall
	
	li $v0, 1
	move $a0, $t6
	syscall

    # termina el programa
    li $v0, 10
    syscall
