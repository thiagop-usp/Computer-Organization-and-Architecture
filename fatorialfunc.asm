.data
	.align 0
	input_str: .asciiz "Digite um numero:\n"
	ans_str: .asciiz "O fatorial de "
	ans2_str: .asciiz " eh "
.text
	.globl main
	
main:
	la $a0, input_str # Digite um numero
	li $v0, 4
	syscall
	
	li $v0, 5 # pega o input 
	syscall
	
	move $t0, $v0 # t0 = v0 (input)
	jal fat # chama fatorial e faz com que v0 = v0!
	move $a0, $v0 # guarda t0!==v0 em a0
	
	 # imprime a resposta
	li $v0, 1
	syscall
	
	j exit

fat:
	addi $t1, $zero, 1
	loop: ble $t0, $t1, endloop
		addi $t0, $t0, -1
		mul $v0, $v0, $t0
		j loop
	endloop:
	jr  $ra
	
exit:
	li $v0, 10
	syscall