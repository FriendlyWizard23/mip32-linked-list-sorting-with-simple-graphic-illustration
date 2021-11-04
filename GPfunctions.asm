.data
	#stringhe formattazione
	primoNodo:		.asciiz "[+]Primo Nodo: "
	ultimoNodo:		.asciiz "[+]Ultimo Nodo: "
	terminato: 		.asciiz "!Terminato!"
	separator: 		.asciiz "\n"
	linea:			.asciiz "--------------------------------"
	idEsame: 		.asciiz "[+]ID: "
	voto: 			.asciiz "[+]Voto: "
	nodoPrecedente:		.asciiz "[+]Nodo Precedente: "
	nodoSuccessivo:		.asciiz "[+]Nodo Successivo: "
	nodoAttuale:		.asciiz "[=>] Nodo Attuale: "
	
	#codici di errore
	errElementNull: 	.asciiz "\nERRORE: Zero Elementi Inseriti\n"
	erroreElementiOOB:	.asciiz "\nErrore: limite elementi raggiunto\n\n"
	checkIdNonValido:	.asciiz "\nErrore: Id esame già inserito!\n\n"
	checkErroreNonValido:	.asciiz "\nErrore: Voto non valido [voto>=18 e voto <=30] !\n\n"
	errIdNonPresente:	.asciiz "\nErrore: ID Esame non presente nella lista !\n\n"
	
	#definizione dei colori
	coloreVerdeLime:	.word 0x32CD32
	coloreAzzurro:		.word 0x00B8FF
	coloreRosso:		.word 0xFF0000
	coloreNero:		.word 0x000000
	
	.globl coloreNero
	.globl errIdNonPresente
	.globl coloreVerdeLime
	.globl coloreAzzurro
	.globl coloreRosso
	
	
.text
	.globl printString
	.globl printValue
	.globl terminate
	.globl inputValue
	.globl stampaFirstLast
	.globl stampaElemento
	.globl stampa_lista
	.globl errore_zero_elementi
	.globl elementiOOB
	.globl checkElementi
	.globl stack_zero_elementi
	
printString:		#Funzione che stampa la stringa passata tramite $a1
	li $v0,4
	la $a0,0($a1)
	syscall
	jr $ra
	
printValue:		#Funzione che stampa il valore passato tramite  $a1
	li $v0,1
	move $a0,$a1	
	syscall
	jr $ra

terminate:		#terminazione del programma
	la $t0 terminato
	move $a1 $t0
	jal printString
	li $v0,10
	syscall
	
inputValue:		#inserimento del valore. Restituisce il valore nel registro $v0
	li $v0,5
	syscall	
	jr $ra

stampaFirstLast:
	addi $sp $sp -4 	
	sw $ra 0($sp)			#salvataggio RA in stack
	
	la $a1 primoNodo
	jal printString
	lw $a1 firstNode
	jal printValue
	
	la $a1 separator
	jal printString
	
	la $a1 ultimoNodo
	jal printString
	lw $a1 lastNode
	jal printValue
	
	la $a1 separator
	jal printString
	
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra

stampaElemento:
	addi $sp $sp -4	#salvo ra nello stack
	sw $ra 0($sp)
	
	#stampa: Nodo_Precedente nodo[2] offset di 8
	#	 ID		 nodo[0] offset di 0	
	#	 Voto		 nodo[1] offset di 4
	#	 Nodo_Successivo nodo[3] offset di 12
	
	move $s0 $a1	#contiene il base address dell'elemento
	
	la $a1 linea
	jal printString
	la $a1 separator
	jal printString
	
	la $a1 nodoAttuale
	jal printString
	move $a1 $s0
	jal printValue
	la $a1 separator
	jal printString
	la $a1 nodoPrecedente
	jal printString
	lw $a1 8($s0)
	jal printValue
	la $a1 separator
	jal printString
	
	la $a1 idEsame
	jal printString
	lw $a1 0($s0)
	jal printValue
	la $a1 separator
	jal printString
	
	la $a1 voto
	jal printString
	lw $a1 4($s0)
	jal printValue
	la $a1 separator
	jal printString
	
	la $a1 nodoSuccessivo
	jal printString
	lw $a1 12($s0)
	jal printValue
	la $a1 separator
	jal printString
	
	la $a1 linea
	jal printString
	la $a1 separator
	jal printString
	
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra

stampa_lista:
	addi $sp $sp -4	
	sw $ra 0($sp)
	
	lw $s0 firstNode
	beqz $s0 zero_elementi
	loop_stampa:
		move $a1 $s0
		jal stampaElemento 
		lw $s0 12($s0)
		beq $s0 0 fine_stampa
		j loop_stampa
	fine_stampa:
	
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra
	zero_elementi:
		addi $sp $sp 4
		j errore_zero_elementi

stack_zero_elementi:
	add $sp $sp 4
	j errore_zero_elementi

errore_zero_elementi:
	la $a1 errElementNull
	jal printString
	j menuCiclo

elementiOOB:
	la $a1 erroreElementiOOB
	jal printString
	j menuCiclo

checkElementi:	#controlla valori. Return 1 se valori sono scorretti, Return 0 se valori corretti
	addi $sp $sp -4
	sw $ra 0($sp)
		
	move $s0 $a0 #recupero id_esame
	move $s1 $a1 #recupero voto
	li $v0 1
	lw $s2 valoriTotali
	
	bgt $s1 30 stampaErroreVoto	#Se voto>30 non va bene
	blt $s1 1 stampaErroreVoto	#Se voto <1 non va bene
	error_ret_location:
	
	beqz $s2 salta_se_zero_elementi	#se è il primo elemento inserito non devo controllare che sia già stato inserito
	jal checkID	
	salta_se_zero_elementi:		#label di return nel caso debba saltare la verifica del ID
	
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra
	
	stampaErroreVoto:
		la $a1 checkErroreNonValido
		jal printString
		li $v0 0
		j error_ret_location
	
	stampaErroreId:
		la $a1 checkIdNonValido
		jal printString
		li $v0 0
		j fine_check_loop
	
	checkID:
		addi $sp $sp -4
		sw $ra 0($sp)
		
		lw $s3 firstNode
		loop_check:
			lw $t2 0($s3)
			beq $s0 $t2 stampaErroreId
			lw $s3 12($s3)
			beqz $s3 fine_check_loop
			j loop_check
		fine_check_loop:
		
		lw $ra 0($sp)
		addi $sp $sp 4
		jr $ra
		
