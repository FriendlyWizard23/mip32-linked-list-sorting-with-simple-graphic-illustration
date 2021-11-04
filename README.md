# mip32-linked-list-sorting-with-simple-graphic-illustration

Questo programma permette di creare, gestire e visualizzare graficamente i risultati dei diversi esami di uno studente tramite 
una lista. 
La lista è definita mediante la struttura dati comunemente conosciuta come “Doubly Linked List” e come tale, è quindi 
implementata mediante la logica dei nodi dinamici.
Ogni oggetto della lista è costituito da:
  1) un campo numerico “id_esame” che serve per identificare univocamente l’esame in considerazione.
  2) un campo numerico “voto” che definisce il voto ottenuto per quell’esame.
Una volta avviato, il programma permette, tramite un menu ad interfaccia testuale, di effettuare alcune operazioni. Tra le 
più importanti:
  1) Inserimento di un nuovo elemento: Tramite un input testuale dell’id esame e del voto ottenuto, nel caso 
  i dati fossero validi e ci fosse spazio disponibile, il nodo verrà creato e inserito come ultimo elemento della 
  lista. Inoltre verrà identificato nel bitmap Display tramite un quadrato di colore rosso.
  2) Ordinamento: Questa funzione permette di ordinare la lista in modo crescente o decrescente. Ad ogni 
  passo di ordinamento, il cambiamento verrà visualizzato nel bitmap Display. In questo modo sarà possibile 
  osservare ogni singola modifica della lista.
  3) Eliminazione di un elemento: Tramite questa funzione l ‘utente potrà cancellare un nodo della lista
  fornendo un id esame. Nel caso l’id inserito non fosse presente, non avverrà alcuna modifica.
  4) Rappresentazione Testuale della lista: questa funzione permette all’utente di stampare ogni singolo nodo 
  della lista tramite interfaccia testuale. ogni nodo stampato riporterà, oltre che ai dati (id_esame e voto) i
  rispettivi collegamenti con i nodi adiacenti. Per questo motivo, questa funzione permette di validare la 
  struttura della lista in seguito alle sue modifiche.
  5) Rappresentazione Grafica su bitmap Display dei diversi voti della lista

Come accennato nella descrizione, la struttura dati utilizzata sarà una versione della “Doubly Linked List”: Ogni 
nodo della lista contiene un puntatore al nodo precedente e al nodo successivo. Il nodo precedente al primo nodo
della lista, sarà il primo nodo della lista stesso e il nodo successivo all’ultimo nodo sarà NULL (0)
L’ordinamento della lista è implementato mediante l’algoritmo “Bubble Sort”
Verrà impiegato il tool di MARS “Bitmap Display” per rappresentare ogni nodo della lista tramite voto. 
