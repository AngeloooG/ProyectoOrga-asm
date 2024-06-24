.data
    # Mensaje de bienvenida
    mensaje1: .asciiz "Ingrese el numero en formato binario en complemento a 2 --> "
    # 1 byte por cada caracter + caracter adicional
    num_cadena: .space 33
    mensaje2: .asciiz "El numero en formato decimal es --> "

.text
    # Comienzo del programa
    # Imprimir mensaje de bienvenida
        li $v0 4
        la $a0 mensaje1
        syscall
        
        # Ingreso del numero en formato binario
        li $v0 8
        la $a0 num_cadena
        li $a1 33
        syscall
        
        li $t9 0           # Iterador de la cadena
        li $t6 0           # Acumulador
        li $t8 2           # Base binaria
        
        # Detectar el signo del número binario
        lb $t0 num_cadena($t9)
        beq $t0  '1' negativo
        
        # Caso numero positivo
        li $t6 0       
        loop1:
            lb $t0, num_cadena($t9)
            # Condición de parada
            beqz $t0 fin_loop_1
            beq $t0 0xA fin_loop_1
            
            addi $t0 $t0 -0x30 # Convertir carácter ASCII a valor numérico
            mul $t6 $t6 $t8
            add $t6 $t6 $t0
            
            # Avanzar al siguiente caracter
            addi $t9 $t9 1
            b loop1
        
        fin_loop_1:
            b imprimir_resultado
            
        # Caso numero negativo
        negativo:
            li $t6 -1
            # Saltamos el primer '1' 
            addi $t9, $t9, 1 
        loop2:
            lb $t0 num_cadena($t9)
            # Condición de parada
            beqz $t0 fin_loop_2
            beq $t0 0xA fin_loop_2
            
            # Convertir de cadena a valor entero
            addi $t0 $t0 -0x30
            mul $t6, $t6, $t8
            sub $t6, $t6, $t0
            
            # Avanzar al siguiente caracter
            addi $t9, $t9, 1
            b loop2
            
        fin_loop_2:
            b imprimir_resultado
        
        imprimir_resultado:
            li $v0, 4
            la $a0, mensaje2
            syscall
            
            li $v0, 1
            move $a0, $t6
            syscall
            
            li $v0, 10
            syscall
