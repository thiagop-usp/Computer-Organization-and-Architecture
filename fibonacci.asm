.data
	.align 0
	str_input: .asciiz "Digite um numero\n"
	
.text
	.globl main
	
# main function
main:
	# imprime "Digite um numero\n"
	la $a0, str_input
	li $v0, 4
	syscall
	
	#le o input e coloca em $v0
	li $v0, 5
	syscall
	
	# salva o argumento $a0 da funcao fibonacci
	move $a0, $v0
	
	# coloca o valor um (caos base) no registrador $t1
	addi $t1, $zero, 1
	
	jal fibonacci

# caso geral da funcao fibonacci
fibonacci:
	addi $sp, $sp, -8 # aloca espaco pro argumento atual dessa chamada e pro endereco dessa chamada (vai ser usado p retorno)
	sw $a0, 4($sp) #coloca o argumento atual na stack
	sw $ra, 0($sp) #coloca o address atual na stack
	
	ble $a0, $t1, fib_base # caso $a0 <= 1 chama a funcao do caso base
	
	addi $a0, $a0, -1
	jal fibonacci
	
	# quando retornar do f(n-1)
	move $v1, $v0
	addi $a0, $a0, -1
	jal fibonacci
	
	# quando retornar do f(n-2)
	add $v0, $v1, $v0
	
	lw $a0, 4($sp) # carrega o que ta na stack
	lw $ra, 0($sp)
	
	addi $sp, $sp, 8 # desaloca
	jr $ra # retorna essa chamada
	
# caso base da funcao fibonacci	
fib_base:
	lw $a0, 4($sp) # carrega o que ta na stack
	lw $ra, 0($sp)
	
	addi $sp, $sp, 8 # desaloca
	addi $v0, $zero, 1 # retorno = 1
	
	jr $ra # retorna
# return 0
exit:
	li $v0, 10
	syscall