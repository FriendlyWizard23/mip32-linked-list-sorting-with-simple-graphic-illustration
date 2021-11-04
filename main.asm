.data
	mostraMenu:	.asciiz  "\n[1]inserimento\n[2]Mostra primo e ultimo\n[3]Stampa lista in CLI\n[4]Ordinamento per voto\n[5]Eliminazione nodo\n[6]rappresenta lista BITMAP\n[7]Termina\n"
	separatore:	.asciiz  "[=============================]"
	simboloInput:	.asciiz  "\n>>"
	erroreInvalido:	.asciiz  "\nErrore, selezione non valida!\n\n"	
	idEliminare:	.asciiz "\nID da Eliminare: "
	ordinamento:	.asciiz "(1) Ordinamento Crescente\n(2) Ordinamento decrescente\n>>"
	
.text
	.globl main
	.globl menuCiclo

	#BISOGNA settare il bitmap con le seguenti impostazioni prima di eseguire il programma:
	#	1) Unit Width in Pixels: 8
	#	3) Unit Height in Pixels: 8
	#	4) Display Width in Pixels: 256
	#	5) Display Height in Pixels: 256
	#	6) Base Address: $gp

main:
	menuCiclo:
		la $a1 separatore
		jal printString
		la $a1 mostraMenu
		jal printString
		la $a1 separatore
		jal printString
		la $a1 simboloInput
		jal printString
		
		jal inputValue
		move $s0 $v0
		beq $s0 1 insertElement
		beq $s0 2 primoUltimo
		beq $s0 3 stampa_linked_list
		beq $s0 4 ordina
		beq $s0 5 rimuovi
		beq $s0 6 rappresentaLista
		beq $s0 7 terminate
		bgt $s0 7 erroreOOB
		j menuCiclo
	endCiclo:

#scalabilita' e general purpose

stampa_linked_list:	
	jal stampa_lista
	j menuCiclo

primoUltimo:
	jal stampaFirstLast
	j menuCiclo

erroreOOB:
	la $t0 erroreInvalido
	move $a1 $t0
	jal printString
	j menuCiclo

rappresentaLista:
	jal rappresenta_bitmap_lista
	j menuCiclo	

rimuovi:
	la $a1 idEliminare
	jal printString
	jal inputValue
	move $a0 $v0
	jal rimuoviElemento
	j menuCiclo

ordina:
	la $a1 ordinamento
	jal printString
	jal inputValue
	move $a1 $v0
	jal BubbleSort
	j menuCiclo
		
