.data
	#"variabili"
	lastNode: 		.word 0
	firstNode: 		.word 0	
	valoriTotali:		.word 0
	currentNode:		.word 0
	maxElements:		.word 16
	x_coord_counter:	.word 0
	
	#stringhe da stampare
	separator: 		.asciiz "\n"
	degreeValue: 		.asciiz "Voto: "
	examId: 		.asciiz "ID: "
	ordinata:		.asciiz "\nLISTA ORDINATA CON SUCCESSO\n"
	
	.globl firstNode
	.globl lastNode
	.globl valoriTotali	

.text
	.globl insertElement
	.globl BubbleSort
	.globl rimuoviElemento

insertElement:
	lw $t0 valoriTotali
	lw $t1 maxElements
	beq $t0 $t1 elementiOOB	#controllo che il valore da inserire non superi il limite di 16
			
	la $a1 examId		#
	jal printString		# Blocco che richiede input di "ID_ESAME"
	jal inputValue		#
	move $s0 $v0		# salvo input in s0	
	
	la $a1 degreeValue	#
	jal printString		# Blocco che richiede input del voto
	jal inputValue		#
	move $s1 $v0		# salvo input in s1
			
	move $a0 $s0		# 
	move $a1 $s1		# passaggio per argomento
	
	jal checkElementi
	beq $v0 0 insertElement 	#se checkElementi == False (0) allora faccio re-inserire i valori
	jal buildNode			#Creazione del nodo
	jal rappresenta_valori_inseriti #rappresentazione dell'elemento nel display
	jal aggiornaCounter		#aggiornamento del counter
	j menuCiclo			#ritorno al menu
	
buildNode:
	addi $sp $sp -4 		#riservo 4 bytes di spazio nello stack per salvare il registro $ra
	sw $ra 0($sp)			#salvataggio RA in stack
	
	move $s1 $a0			# id esame	
	move $s2 $a1			# voto
			
	li $v0,9			#
	li $a0,16			# "allocazione" di 16 bytes di spazio --> 2 int(8 bytes) +  previous_node (4 bytes) + next_node (4 bytes) = 16
	syscall				# 
	move $s0 $v0			# sposto in s0 l'indirizzo del base offset appena allocato
	
	move $a0 $zero			# pulizia contenuto del registro argomento
	lw $s3 firstNode		#
	move $a0 $s0			#
	beqz $s3 isFirstNode		# se ancora non c'e' un nodo iniziale metto quello corrente come iniziale 
	return_location:		# se entor nella BEQ devo ritornare qua
	
	sw $s1 0($s0)			#spazio[0] = ID 
	sw $s2 4($s0)			#spazio[1] = voto_ottenuto				
	lw $s1 lastNode
	sw $s1 8($s0)			#spazio[2]= nodo_precedente
	sw $zero 12($s0)		#spazio[3]= nodo_successivo
	
	lw $s1 firstNode		
	move $a1 $s0
	bne $s1 $s0 updatePreviousNode	#aggiorno il nodo precedente inserendogli come nodo successivo il nodo appena generato
	goback:
	sw $s0 lastNode			#aggiorno lastNode inserendo l'indirizzo dell'ultimo nodo generato
	
	#move $a1 $s0
	lw $ra ($sp)			
	addi $sp $sp 4
	jr $ra
	
	
	isFirstNode:
		sw $a0 firstNode
		sw $a0 lastNode
		j return_location

	updatePreviousNode:
		move $t0 $a1
		lw $t1 lastNode
		sw $t0 12($t1)
		j goback

rappresenta_valori_inseriti:
	addi $sp $sp -4 		
	sw $ra 0($sp)	
	
	move $s0 $a0
	lw $t1 x_coord_counter 
	lw $t2 4($s0) 
	
	lw $a1 coloreRosso
	move $a2 $t1	
	
	lw $t3 quad_per_colonna
	sub $t3 $t3 1		
	sub $t2 $t3 $t2
	move $a3 $t2
	
	add $sp $sp -4
	sw $t1 0($sp)
	jal stampaQuadrato								
	lw $t1 0($sp)
	add $sp $sp 4
	addi $t1 $t1 2
	sw $t1 x_coord_counter	#aggiorno il counter delle x per lasciare una colonna di spazio tra la rappresentazione di un valore e un altro
	
	lw $ra 0($sp)			
	addi $sp $sp 4
	jr $ra

aggiornaCounter:		#aggiorna il numero totale di valori inseriti
	addi $sp $sp -4	
	sw $ra 0($sp)
	lw $t0 valoriTotali
	addi $t0 $t0 1
	sw $t0 valoriTotali
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra

BubbleSort: 
	addi $sp $sp -4
	sw $ra 0($sp)
	move $s5 $a1

	lw $s0 valoriTotali
	beqz $s0 stack_zero_elementi		#se contiene 0 valori dico di inserirne 
	beq $s0 1 end_external_loop		#se contiene 1 elemento non serve fare il loop
	addi $s0 $s0 -1 			#t0 cotiene N per ciclo esterno
	move $s1 $s0				#t1 contiene N per ciclo interno			
	move $t2 $zero				#t2= COUNTER, parte da 0			
	move $s2 $s0				#contiene una copia di s0 per ottimizzare l'algoritmo
				
	external_loop:
		bge $t2 $s0 end_external_loop
		move $t3 $zero			#t3= COUNTER INTERNO parte da 0
		lw $t4 firstNode 		#carico in t4 il primo valore (i=0)
		sub $s1 $s2 $t2
		
		internal_loop:
			move $s7 $zero 			#FLAG
			move $v1 $zero			#pulisco ad ogni ciclo v1
			bge $t3 $s1 end_internal_loop
			lw $t5 12($t4)			#carico in t5 il valore del nodo in i+1
			move $a1 $t4			#metto in $a1 il valore del numero in posizione i
			move $a2 $t5			#metto in $a2 il valore del numero in posizione i+1	
			
			add $sp $sp -28		#
			sw $s0 0($sp)		#
			sw $s1 4($sp)		# salvataggio 
			sw $t2 8($sp)		# registri
			sw $t3 12($sp)		#
			sw $t4 16($sp)		#
			sw $s2 20($sp)		#
			sw $s5 24($sp)
			
			lw $t6 4($t4)		#primo elemento da controllare
			lw $t7 4($t5)		#secondo elemento da controllare
			
			beq $s5 2 scambia_per_ordinamento_dec
			return_scambia_ordinamento:
			
			bgt $t6 $t7 scambia_elementi
			return_swap:
			lw $a0 coloreVerdeLime
			jal rappresenta_bitmap_lista
			move $s7 $v1		#Abilito il flag definito dal valore di ritorno
			
			lw $s5 24($sp)
			lw $s2 20($sp)
			lw $t4 16($sp)		#	
			lw $t3 12($sp)		#	
			lw $t2 8($sp)		# Recupero	
			lw $s1 4($sp)		# Registri
			lw $s0 0($sp)		#
			add $sp $sp 28		
			beq $s7 1 salta_aggiornamento
			lw $t4 12($t4)
			salta_aggiornamento:
			addi $t3 $t3 1

			j internal_loop	
		end_internal_loop:	
		addi $t2 $t2 1
		j external_loop	
	
	scambia_per_ordinamento_dec:
		move $t0 $t6
		move $t6 $t7
		move $t7 $t0
		j return_scambia_ordinamento
		
	end_external_loop:
		lw $ra 0($sp)
		addi $sp $sp 4
		la $a1 ordinata
		jal printString
		j menuCiclo

	scambia_elementi:	#REGISTRI UTILIZZATI [t0,t1,t2,t3,t4]
	
		move $t0 $a1	#primo elemento (a)
		move $t1 $a2	#secondo elemento (b)
		lw $t2 firstNode 
		beq $t0 $t2 scambia_primo_nodo
		lw $t3 8($t0) 	#contiene l'indirizzo prima di quello attuale
		sw $t1 12($t3)	#faccio il re-link del nodo precedente a quello attuale dato che dovro swappare quello attuale con quello dopo
		
		lw $t4 12($t1)	#contiene l'indirizzo dopo di quello successivo
		beqz $t4 avoid_linking
		sw $t0 8($t4)	#faccio il re-link 
			avoid_linking:
			
		lw $t4 12($t1)	#t4=successivo(b)
		sw $t4 12($t0)	#successivo(a)=successivo(b)
	
		lw $t4 8($t0)	#t4=precedente(a)
		sw $t4 8($t1)	#precedente(b)=precedente(a)
	
		sw $t1 8($t0)	#precedente(a)=b
		sw $t0 12($t1)	#successivo(b)=a
		
		
		lw $t4 12($t0)
			return_scambia_primo_nodo:
		
		beqz $t4 aggiorna_lastNode
			return_aggiorna_lastNode:
		
		li $v1 1
		j return_swap
	
	scambia_primo_nodo:
		lw $t4 12($t1)	#contiene l'indirizzo dopo di quello successivo
		beqz $t4 avoid_linking_primo
		
		sw $t0 8($t4)	#faccio il re-link 
			avoid_linking_primo:
		
		lw $t2 12($t1)	#t2=successivo(b)
		sw $t2 12($t0)	#successivo(a)=successivo(b)
	
		sw $t1 8($t1)	#precedente(b)=b
	
		sw $t1 8($t0)	#precedente(a)=b
		sw $t0 12($t1)	#successivo(b)=a
	
		sw $t1 firstNode	#aggiorno firstNode dopo lo swap
		j return_scambia_primo_nodo

	aggiorna_lastNode:
		sw $t0 lastNode
		j return_aggiorna_lastNode


rimuoviElemento:
	addi $sp $sp -4
	sw $ra 0($sp)

	move $s0 $a0			#id_esame che voglio rimuovere
	lw $s1 firstNode		
	beqz $s1 stack_zero_elementi	#se ci sono zero elementi = errore
	move $v1 $zero
	
	loop_elimina:
		lw $t0 0($s1)
		beq $s0 $t0 elimina_nodo
		lw $s1 12($s1)
		beqz $s1 fine_elimina
		j loop_elimina
	fine_elimina:
	
	beqz $v1 stampa_errore_id	#se v1 è zero dopo la chiamata allora significa che non esiste l'ID
	return_controllo_errore_id:
	
	lw $ra 0($sp)			
	add $sp $sp 4
	jr $ra
	
	stampa_errore_id:
		la $a1 errIdNonPresente
		jal printString
		j return_controllo_errore_id
	
	elimina_nodo:	#a questo punto s1 conterrà l'indirizzo del nodo da eliminare 
		lw $s4 valoriTotali
		lw $s2 firstNode		
		lw $s3 lastNode
		beq $s4 1 elimina_unico
		beq $s1 $s2 elimina_primo_nodo	# se il nodo è il primo allora lo gestisco in maniera diversa
		beq $s1 $s3 elimina_ultimo_nodo	# se il nodo è l'ultimo allora lo gestisco in maniera diversa
		# gestisco il nodo come se fosse tra altri due nodi
		
		lw $s2 8($s1)	# s2 = nodo precedente a quello che si deve eliminare
		lw $s3 12($s1)	# s3 = nodo successivo a quello che si deve eliminare

		sw $s2 8($s3)	#re-linko i due nodi 
		sw $s3 12($s2)	#
		
		return_generale_eliminazione_nodo:
		addi $s4 $s4 -1			# valori totali -1
		sw $s4 valoriTotali 		#
		
		lw $s4 x_coord_counter		# 
		addi $s4 $s4 -1			# valori delle coordinate inserite -1
		sw $s4 x_coord_counter		#
		
		li $v1 1
		jal pulisci_matrice		#pulisco la matrice
		lw $a0 coloreAzzurro
		jal rappresenta_bitmap_lista	#rappresento la lista senza il valore rimosso
		j fine_elimina
		
		elimina_primo_nodo:		#se il primo nodo va rimosso allora devo linkare firstNode al secondo nodo e basta
			lw $s2 12($s1)
			sw $s2 8($s2)
			sw $s2 firstNode
			j return_generale_eliminazione_nodo
			
		elimina_ultimo_nodo:		#se l'ultimo nodo va rimosso allora devo linkare il penultimo nodo al lastNode
			lw $s2 8($s1)
			sw $zero 12($s2)
			sw $s2 lastNode
			j return_generale_eliminazione_nodo
		
		elimina_unico:			#se la lista contiene solo un valore allora linko firstNode e lastNode a zero
			sw $zero firstNode
			sw $zero lastNode
			j return_generale_eliminazione_nodo

