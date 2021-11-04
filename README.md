# mip32-linked-list-sorting-with-simple-graphic-illustration

## Project Description

This program allows you to create, manage and graphically view the results of a student's results of exams via
a list.
The list is defined by means of the data structure commonly known as "Doubly Linked List" and as such, it is therefore
implemented through the logic of dynamic nodes:
Each item on the list consists of:
  1) a numeric field "exam_id" which is used to uniquely identify the exam under consideration.
  2) a numerical "grade" field that defines the grade obtained for that exam.

Once started, the program allows, through a textual interface menu, to perform some operations. Between
most important:
	
	1)INSERTION of a new element: Through a textual input of the exam ID and the grade obtained, if applicable
	the data were valid and there was space available, the node will be created and inserted as the last element of the
	list. It will also be identified in the Display bitmap by a red square.
  
	2)SORTING: This function allows you to sort the list in ascending or descending order. For every
	sorting step, the change will be displayed in the bitmap Display. This will make it possible for the user to
	observe every single change in the list.
	

	3)DELETING an element: Through this function the user can delete a node from the list
	providing an exam id. If the entered id is not present, no changes will take place.
  

	4)TEXTUAL REPRESENTATION of the list: this function allows the user to print each individual node
	of the list via text interface. Each printed node will show, in addition to the data (exam_id and grade) the
	related links with adjacent nodes. For this reason, this function allows you to validate the
	structure of the list after its modifications.
  
	
	5)GRAPHIC representation on bitmap Display of the different votes in the list
  
## Technical Details
As mentioned in the description, the data structure used will be a version of the "Doubly Linked List": Each
node in the list contains a pointer to the previous node and the next node. The node before the first node
of the list, it will be the first node of the list itself and the node following the last node will be NULL (0)
The sorting of the list is implemented using the "Bubble Sort" algorithm
The MARS "Bitmap Display" tool will be used to represent each node of the list by vote.

## Installation
To run this project you will need MARS (http://courses.missouristate.edu/kenvollmar/mars/), a lightweight IDE for programming in MIPS assembly language.
Download the sources and then import the files into the IDE. 
Then run it.
