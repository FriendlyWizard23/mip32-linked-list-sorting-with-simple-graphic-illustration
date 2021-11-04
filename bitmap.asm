.data
	ad:
	Ad:
	x_quadrato:		.word 8
	y_quadrato:		.word 8
	bytes_per_riga: 	.word 128 #64 quadrati per riga 	
	bytes_per_colonna:	.word 128 #64 quadrati per colonna
	quad_per_colonna:	.word 32
	quad_per_riga:		.word 32
	
	.globl bytes_per_riga
	.globl bytes_per_colonna
	.globl quad_per_colonna
	.globl quad_per_riga
.text

	.globl stampaQuadrato
	.globl pulisci_matrice
	.globl rappresenta_bitmap_lista

stampaQuadrato:	#REGISTRI --> [t0,t1,t2,t3]  
	move $t0 $a1 	# a1=colore
	move $t1 $a2 	# a2=posizione_x
	move $t2 $a3 	# a3=posizione_y
	lw $t3 bytes_per_riga
	
	mul $t2 $t2 $t3
	mul $t1 $t1 4
		
	add $t2 $t2 $t1
	add $t2 $gp $t2
	sw $t0 0($t2)
	jr $ra 
	
pulisci_matrice: #REGISTRI UTILIZZATI --> [t4]
	add $sp $sp -4
	sw $ra 0($sp)
	
	move $t4 $zero #counter nel loop	
	loop:
		beq $t4 32 end
		move $a1 $zero
		add $a1 $zero $t4
		jal pulisci_riga
		addi $t4 $t4 1	
		j loop	
	end:
	
	lw $ra 0($sp)
	add $sp $sp 4
	jr $ra
					
pulisci_riga: #REGISTRI UTILIZZATI --> [t7,t6]			
	add $sp $sp -4
	sw $ra 0($sp)
	
	move $t7 $zero #counter nel loop
	move $t6 $a1
	lw $a1 coloreNero
	
	loop_riga:
		beq $t7 32 end_riga
		move $a2  $zero
		move $a3 $zero
		add $a2 $zero $t7
		add $a3 $zero $t6
		jal stampaQuadrato
		addi $t7 $t7 1
		j loop_riga
	end_riga:
	
	lw $ra 0($sp)
	add $sp $sp 4
	jr $ra

rappresenta_bitmap_lista: #REGISTRI UTILIZZATI [$s0,$s1,$t9]
	addi $sp $sp -4	
	sw $ra 0($sp)
	move $t9 $a0
	jal pulisci_matrice
	lw $s0 firstNode
	beqz $s0 stack_zero_elementi
	lw $s1 quad_per_colonna
	sub $s1 $s1 1		
	move $s2 $zero
	move $a1 $t9
	
	loop_rappresenta: 
		addi $sp $sp -4
		sw $s1 0($sp)
		addi $sp $sp -4
		sw $s2 0($sp)
		
		move $a2 $s2
		lw $a3 4($s0)
		sub $a3 $s1 $a3
		jal stampaQuadrato 
		
		lw $s2 0($sp)
		addi $sp $sp 4
		lw $s1 0($sp)
		addi $sp $sp 4
		
		lw $s0 12($s0)
		addi $s2 $s2 2
		beqz $s0 fine_rappresenta
		j loop_rappresenta
	fine_rappresenta:
	
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra
