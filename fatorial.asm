.data
	.align 0
	strfat: .asciiz "o fat de "
	streh: .asciiz " eh "
.text
	.globl main
	
main:
	li $v0, 5 # le um inteiro e joga no $v0
	syscall
	
	add $t0, $v0, $zero # copia o v0 pro t0
	addi $t1, $zero, 1 # coloca 1 no t1
	add $t2, $zero, $t0 # coloca t2 == t0
	move $t3, $t0 # t3 = t0, t3: ans
	
	#blt $t2, $t1 significa if(t2 < 1), ou seja, aqui terminou de calcular o fat
	loopfat: ble $t2, $t1, endloop
		addi $t2, $t2, -1
		mul $t3, $t3, $t2
		j loopfat
	endloop:
	

	la $a0, strfat # imprime "o fat de "
	li $v0, 4
	syscall

	move $a0, $t0 # imprime o valor de input
	li $v0, 1
	syscall
	
	la $a0, streh # imprime " eh"
	li $v0, 4
	syscall
	
	move $a0, $t3 # imprime o valor do fatorial
	li $v0, 1
	syscall
	
	li $v0, 10 # return 0
	syscall