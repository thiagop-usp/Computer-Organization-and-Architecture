.data
	.align 0
	str_input: .asciiz "Digite um numero\n"
.text
	.globl main

main:
	la $a0, str_input # imprime 'Digite um numero\n'
	li $v0, 4
	syscall

	li $v0, 5 # armazena um int lido no stdin no registrador $v0
	syscall
	
	move $a0, $v0 #guarda o n inicial em $a0
	
	addi $t1, $zero, 1 # coloca o valor 1 no registrador $t1
	
	jal fatorial
	
	move $a0, $v0
	li $v0, 1
	syscall

	j exit
	
fatorial:
	# inicialmente
	# cada um eh 4 bytes
	# |---------| <- sp 
	# |---------| <- sp - 4
	# |---------| <- sp - 8
	# |---------| <- sp - 12

	addi $sp $sp -8 # move sp 2 ints (ou 8 bytes) pra baixo, ou seja, aloca 8 bytes
	
	# |---------| <- sp + 8
	# |---------| <- sp + 4
	# |---------| <- sp
	# |---------| <- sp - 4
	
	sw $a0 4($sp) # aqui eu vou armazenar o input 4 bytes pra cima em relacao a sp
	
	# |---------| <- sp + 8
	# |---$a0---| <- sp + 4
	# |---------| <- sp
	# |---------| <- sp - 4
	
	sw $ra 0($sp) # armazena o endereco de retorno da chamada atual no bloco de memoria em que sp aponta
	
	# |---------| <- sp + 8
	# |---$a0---| <- sp + 4
	# |---$ra---| <- sp
	# |---------| <- sp - 4
	
	ble $a0, $t1, retorno # se $a0 for menor do que 1, eu tenho que retornar a funcao de caso base
	
	# caso contrario, chamar fat(n-1) * n
	
	addi $a0, $a0, -1 # $a0--;
	jal fatorial # chamo recursivamente fatorial($a0), ou seja: fatorial(n-1)
	
	# quando voltar da recursao:
	
	lw $a0, 4($sp) # carrego o valor atual do meu n no a0
	mul $v0, $a0, $v0 # calculo n*fat(n-1)
	lw $ra 0($sp) # carrego o valor atual de retorno no ra
	
	addi $sp, $sp, 8 # desempilha os 8 bytes
	
	jr $ra #retorno essa chamada
	
	# apos algumas chamadas vai ter algo do tipo:
	
	# |---------| 
	# |---$a0---| 
	# |---$ra---| 
	# |---$a0---| 
	# |---$ra---| 
	# |---$a0---| 
	# |---$ra---| 
	# |---$a0---| 
	# |---$ra---| 
	# |---------| 
	
	# em que cada #a0 eh o n daquela chamada (f(3) -> f(2) -> ...) e #ra eh o  endereco daquela chamada
retorno:
	#desempilhar a stack (guardando os valores)
	lw $a0, 4($sp)
	lw $ra, 0($sp)

	addi	$v0	$zero	1 # retorna 1

	#retornar 
	addi $sp, $sp, 8 # desempilha 8 bytes
	jr $ra #retorna	
	
	
exit:
	li $v0, 10
	syscall