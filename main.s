 # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # PROGETTO ASSEMBLY RISC-V GESTIONE LISTE CIRCOLARI #
 # Nome: Riccardo Giannuzzi                          #
 # Anno Accademico: 2022-2023                        #
 # Data di Consegna: 10/09/2023                      #
 # Corso: Architetture degli Elaboratori             #
 # Versione Ripes: 2.2.5                             #
 # # # # # # # # # # # # # # # # # # # # # # # # # # #

.data
# puntatore alla testa della lista
pHead: .word 0x10000500
# stringa di input
listInput: .string "ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~ ADD(9) ~SSX~SORT~PRINT~DEL(b)~DEL(B)~PRI~SDX~REV~PRINT"
# numero massimo di comandi nella stringa di input
maxInputs: .word 30

#------------- MAIN -------------#
.text
# inizializzo
lw s0,pHead # puntatore alla testa della lista
la s1,listInput # puntatore alla stringa di input
lw s2,maxInputs # numero massimo di caratteri in input

# lettura della stringa di input
mv s3,s1 # puntatore al carrattere attuale della stringa di input
mv s4,zero # contatore di comandi
prossimoComando:
    # controllo se il contenuto della stringa è finito
    lb t0,0(s3)
    beq t0,zero, fineLetturaInput
    
    # controllo se ho superato il numero di comandi massimo
    addi s4,s4,1
    bgt s4,s2,fineLetturaInput
    
    # salto gli spazi vuoti prima del comando
    li t1,32 # spazio vuoto " "
    spazioVuoto:
    bne t0,t1,fineSpaziVuoti
    addi s3,s3,1
    lb t0,0(s3)
    j spazioVuoto
    fineSpaziVuoti:
    
    # controllo se il primo carattere è un carattere dei comandi
    li t1,65 # A
    li t2,68 # D
    li t3,80 # P
    li t4,82 # R
    li t5,83 # S
    beq t0,t1, sequenzaAdd
    beq t0,t2, sequenzaDel
    beq t0,t3, sequenzaPrint
    beq t0,t4, sequenzaRev
    beq t0,t5, sequenzeS
    # se non lo è ignoro tutti i caratteri fino alla prossima tilde
    j saltaFinoATilde
    
    sequenzaAdd:
        # Secondo carattere 
        addi s3,s3,1
        lb t0,0(s3)
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,68 # D
        bne t0,t1,saltaFinoATilde
        # Terzo carattere 
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        # in t1 c'è ancora D
        bne t0,t1,saltaFinoATilde
        # Quarto carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,40 # parentesi tonda aperta
        bne t0,t1,saltaFinoATilde
        # Quinto carattere (PARAMETRO) 
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        # controllo se il parametro è accettabile
        li t1,32 # min compreso
        li t2,125 # max compreso
        blt t0,t1,saltaFinoATilde
        bgt t0,t2,saltaFinoATilde
        mv a0,t0 # se è accettabile lo passo come parametro in a0
        # Sesto carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,41 # parentesi tonda chiusa
        bne t0,t1,saltaFinoATilde
        # Controllo se i caratteri dopo rendono il comando non valido
        ultimoControlloAdd:
            addi s3,s3,1
            lb t0,0(s3) 
            # se il comando si chiude lo eseguo
            beq t0,zero,addTermina 
            li t1,126 # Tilde
            beq t0,t1,addValida 
            # se non trovo uno spazio vuoto il comando non è valido
            li t1,32 # spazio vuoto " "
            bne t0,t1,saltaFinoATilde 
        j ultimoControlloAdd
        
        # comando valido e ho trovato una tilde
        addValida:
            jal add
            addi s3,s3,1 # sposto in avanti il puntatore della stringa di input
            j prossimoComando
        
        # comando valido e la stringa è finita
        addTermina:
            jal add
            j fineLetturaInput  
        
    sequenzaDel:
        # Secondo carattere
        addi s3,s3,1
        lb t0,0(s3)
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,69 # E
        bne t0,t1,saltaFinoATilde
        # Terzo carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,76 # L
        bne t0,t1,saltaFinoATilde
        # Quarto carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,40 # parentesi tonda aperta
        bne t0,t1,saltaFinoATilde
        # Quinto carattere (PARAMETRO)
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        # controllo se il parametro è accettabile
        li t1,32 # min compreso
        li t2,125 # max compreso
        blt t0,t1,saltaFinoATilde
        bgt t0,t2,saltaFinoATilde
        mv a0,t0 # se è accettabile lo passo come parametro in a0
        # Sesto carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,41 # parentesi tonda chiusa
        bne t0,t1,saltaFinoATilde
        # Controllo se i caratteri dopo rendono il comando non valido
            ultimoControlloDel:
            addi s3,s3,1
            lb t0,0(s3) 
            # se il comando si chiude lo eseguo
            beq t0,zero,delTermina
            li t1,126 # Tilde
            beq t0,t1,delValida
            # se non trovo uno spazio vuoto il comando non è valido
            li t1,32 # spazio vuoto " "
            bne t0,t1,saltaFinoATilde
        j ultimoControlloDel
        
        # comando valido e ho trovato una tilde
        delValida:
            jal del
            mv s0,a0 # aggiorno l'indirizzo della testa
            la t1,pHead
            sw a0,0(t1) # scrivo l'indirizzo della nuova testa in memoria
            addi s3,s3,1 # sposto in avanti il puntatore della stringa di input
            j prossimoComando
        
        # comando valido e la stringa è finita
        delTermina:
            jal del
            mv s0,a0 # aggiorno l'indirizzo della testa
            la t1,pHead
            sw a0,0(t1) # scrivo l'indirizzo della nuova testa in memoria
            j fineLetturaInput
        
    sequenzaPrint:
        # Secondo carattere
        addi s3,s3,1
        lb t0,0(s3)
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,82 # R
        bne t0,t1,saltaFinoATilde
        # Terzo carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,73 # I
        bne t0,t1,saltaFinoATilde
        # Quarto carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,78 # N
        bne t0,t1,saltaFinoATilde
        # Quinto carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,84 # T
        bne t0,t1,saltaFinoATilde
        # Controllo se i caratteri dopo rendono il comando non valido
        ultimoControlloPrint:
            addi s3,s3,1
            lb t0,0(s3) 
            # se il comando si chiude lo eseguo
            beq t0,zero,printTermina
            li t1,126 # Tilde
            beq t0,t1,printValida
            # se non trovo uno spazio vuoto il comando non è valido
            li t1,32 # spazio vuoto " "
            bne t0,t1,saltaFinoATilde
        j ultimoControlloPrint
        
        # comando valido e ho trovato una tilde
        printValida:
            jal print
            addi s3,s3,1 # sposto in avanti il puntatore della stringa
            j prossimoComando
        
        # comando valido e la stringa è finita
        printTermina:
            jal print
            j fineLetturaInput
        
    sequenzaRev:
        # Secondo carattere
        addi s3,s3,1
        lb t0,0(s3)
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,69 # E
        bne t0,t1,saltaFinoATilde
        # Terzo carattere 
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,86 # V
        bne t0,t1,saltaFinoATilde
        # Controllo se i caratteri dopo rendono il comando non valido
        ultimoControlloRev:
            addi s3,s3,1
            lb t0,0(s3) 
            # se il comando si chiude lo eseguo
            beq t0,zero,revTermina
            li t1,126 # Tilde
            beq t0,t1,revValida
            # se non trovo uno spazio vuoto il comando non è valido
            li t1,32 # spazio vuoto " "
            bne t0,t1,saltaFinoATilde
        j ultimoControlloRev
        
        # comando valido e ho trovato una tilde
        revValida:
            jal rev
            addi s3,s3,1 # sposto in avanti il puntatore della stringa
            j prossimoComando
        
        # comando valido e la stringa è finita
        revTermina:
            jal rev
            j fineLetturaInput
    
    # controllo se il secondo carattere dopo la prima S è un carattere dei comandi
    sequenzeS:
        addi s3,s3,1
        lb t0,0(s3)
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,79 # O
        beq t0,t1, sequenzaSort
        li t1,68 # D
        beq t0,t1, sequenzaSdx
        li t1,83 # S
        beq t0,t1, sequenzaSsx
    
    sequenzaSort:
        # Terzo carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,82 # R
        bne t0,t1,saltaFinoATilde
        # Quarto carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,84 # T
        bne t0,t1,saltaFinoATilde
        # Controllo se i caratteri dopo rendono il comando non valido
        ultimoControlloSort:
            addi s3,s3,1
            lb t0,0(s3) 
            # se il comando si chiude lo eseguo
            beq t0,zero,sortTermina
            li t1,126 # Tilde
            beq t0,t1,sortValida
            # se non trovo uno spazio vuoto il comando non è valido
            li t1,32 # spazio vuoto " "
            bne t0,t1,saltaFinoATilde
        j ultimoControlloSort
        
        # comando valido e ho trovato una tilde
        sortValida:
            jal sort
            addi s3,s3,1 # sposto in avanti il puntatore della stringa
            j prossimoComando
        
        # comando valido e la stringa è finita
        sortTermina:
            jal sort
            j fineLetturaInput
            
    sequenzaSdx:
        # Terzo carattere 
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,88 # X
        bne t0,t1,saltaFinoATilde
        # Controllo se i caratteri dopo rendono il comando non valido
        ultimoControlloSdx:
            addi s3,s3,1
            lb t0,0(s3) 
            # se il comando si chiude lo eseguo
            beq t0,zero,sdxTermina
            li t1,126 # Tilde
            beq t0,t1,sdxValida
            # se non trovo uno spazio vuoto il comando non è valido
            li t1,32 # spazio vuoto " "
            bne t0,t1,saltaFinoATilde
        j ultimoControlloSdx
        
        # comando valido e ho trovato una tilde
        sdxValida:
            jal sdx
            mv s0,a0 # aggiorno l'indirizzo della testa
            la t1,pHead
            sw a0,0(t1) # scrivo l'indirizzo della nuova testa in memoria
            addi s3,s3,1 # sposto in avanti il puntatore della stringa
            j prossimoComando
        
        # comando valido e la stringa è finita
        sdxTermina:
            jal sdx
            mv s0,a0 # aggiorno l'indirizzo della testa
            la t1,pHead
            sw a0,0(t1) # scrivo l'indirizzo della nuova testa in memoria
            j fineLetturaInput
            
    sequenzaSsx:
        # Terzo carattere
        addi s3,s3,1
        lb t0,0(s3) 
        beq t0,zero, fineLetturaInput # controllo se è finita la stringa
        li t1,88 # X
        bne t0,t1,saltaFinoATilde
        # Controllo se i caratteri dopo rendono il comando non valido
        ultimoControlloSsx:
            addi s3,s3,1
            lb t0,0(s3) 
            # se il comando si chiude lo eseguo
            beq t0,zero,ssxTermina
            li t1,126 # Tilde
            beq t0,t1,ssxValida
            # se non trovo uno spazio vuoto il comando non è valido
            li t1,32 # spazio vuoto " "
            bne t0,t1,saltaFinoATilde
        j ultimoControlloSsx
        
        # comando valido e ho trovato una tilde
        ssxValida:
            jal ssx
            mv s0,a0 # aggiorno l'indirizzo della testa
            la t1,pHead
            sw a0,0(t1) # scrivo l'indirizzo della nuova testa in memoria
            addi s3,s3,1 # sposto in avanti il puntatore della stringa
            j prossimoComando
        
        # comando valido e la stringa è finita
        ssxTermina:
            jal ssx
            mv s0,a0 # aggiorno l'indirizzo della testa
            la t1,pHead
            sw a0,0(t1) # scrivo l'indirizzo della nuova testa in memoria
            j fineLetturaInput
    
    # ingoro tutti i caratteri fino a che non trovo una tilde o finisce la stringa
    saltaFinoATilde:
        li t1,126 #Tilde
        ciclaTilde:
            addi s3,s3,1 # incremento prima in modo che anche se trovo una tilde sposto in avanti il puntatore comunque
            beq t0,t1 prossimoComando
            lb t0,0(s3)
            beq t0,zero, fineLetturaInput # controllo se è finita la stringa
            j ciclaTilde

fineLetturaInput:
j fine

#------------- FUNZIONI -------------#

#- ADD(p) -#
# aggiunge un nodo in fondo alla lista contenente il parametro passato in a0
add:
    # controllo se il puntatore del primo elemento è zero
    lw t1, 1(s0)
    beq t1,zero, inizializza # se è zero inizializzo il primo nodo
    
    # salvo i valori nello stack
    addi sp,sp,-12 
    sw ra,8(sp) # salvo l'indirizzo di ritorno
    sw a0,4(sp) # salvo il valore da inserire passato
    
    #cerco l'indirizzo dell'elemento precedente della testa
    mv a0,s0
    jal cercaPrecedente
    sw a0,0(sp) # salvo l'indirizzo del precedente della testa
   
    #cerco un indirizzo di memoria libero partendo dall'ultimo elemento
    # a0 contiene l'indirizzo del precedente della testa
    jal cercaSpazioLibero
    # a0 contiene l'indirizzo dello spazio di memoria libero
    
    #recupero i valori dallo stack
    lw t2,0(sp) # indirizzo del precedente della testa
    lw t1,4(sp) # valore da inserire nel nuovo nodo
    lw ra,8(sp) # l'indirizzo di ritorno
    addi sp,sp,12

    inserimento:
        # aggiungo il nuovo nodo nello spazio di memoria indicato da a0
        sb t1,0(a0) # salvo il contenuto del nodo nel primo byte
        sw s0,1(a0) # salvo il puntatore alla testa nel nuovo nodo
        # s3 contiene l'undirizzo di quello che era dell'ultimo nodo prima della add
        sw a0,1(t2) # salvo il puntatore al nuovo nodo nel suo nodo precedente
        j fineAdd

    inizializza:
        # creo il primo nodo che punta a se stesso
        sb a0,0(s0) # scrivo il contenuto del primo nodo
        sw s0,1(s0) # scrivo l'indirizzo della testa nel puntatore
    
    fineAdd:
jr ra

#- DEL(p) -#
# elimina dalla lista tutti i nodi che contengono il parametro passato in a0
del:
    # salvo i valori nello stack
    addi sp,sp,-8
    sw ra,4(sp) # salvo l'indirizzo di ritorno
    sw a0,0(sp) # salvo il valore da eliminare passato
 
    # inizializzo i registri per il ciclo di eliminazione
    mv t0,s0 # indirizzo della testa dopo l'eliminazione
    mv t1,s0 # indirizzo nodo attuale (inizio dalla testa)
    
    # controllo se la lista è vuota
    lw t3,1(s0)
    beq t3,zero fineDel # salto se il puntatore del primo nodo è zero
    
    ciclaDel:
        lb t2,0(t1) # leggo il contenuto del nodo attuale
        lw t3,0(sp) # recupero il valore da eliminare dallo stack
        # controllo se il contenuto combacia con quelli da eliminare
        bne t2,t3,nonElimina
            # controllo se è l'ultimo elemento della lista 
           lw t2,1(t1) #leggo l'indirizzo del successivo del nodo attuale
           bne t1,t2, nonUltimoElemento #controllo se sono uguali
               # scrivo 00000 in memoria dove era il nodo
               sb zero,0(t1)
               sw zero,1(t1)
               j fineDel
            nonUltimoElemento:
           
            # salvo nello stack i dati
            addi sp,sp,-8
            sw t0,4(sp) # l'indirizzo della testa
            sw t1,0(sp) # l'indirizzo del nodo attuale
           
            # cerco il precedente del nodo attuale
            mv a0,t1
            jal cercaPrecedente
           
            # recupero i dati dallo stack
            lw t1,0(sp) # l'indirizzo della testa
            lw t0,4(sp) # l'indirizzo del nodo attuale
            addi sp,sp,8
           
            # eliminazione del nodo 
            lw t2,1(t1) # lettura del puntatore al successivo del nodo eliminato
            sw t2,1(a0) # scrittura del puntatore del nodo eliminato nel puntatore del nodo precedente
           
            # Controllo se è stata eliminata la testa e nel caso modifico t0
            bne t0,t1,nonElimina
                lw t0,1(t0) # sposto la testa in avanti
                mv t1,t0 # sposto il puntatore in avanti
                j ciclaDel
               
        nonElimina:
            # sposto il puntatore in avanti
            lw t1,1(t1)
            # se il nodo successivo è uguale alla testa si ferma
            bne t0,t1,ciclaDel
    
    fineDel:
    mv a0,t0 # restituisco l'indirizzo della nuova testa al chiamante
    # recupero l'indirizzo di ritorno dallo stack
    lw ra,4(sp)
    addi sp,sp,8
jr ra

#- PRINT -#
# stampa il contenuto di tutti i nodi partendo dalla testa
print:
    # controllo se la lista è vuota
    lw t0,1(s0)
    beq t0,zero, finePrint # salto se il puntatore del primo nodo è zero
    
    # stampo il contenuto della testa (do while)
    lb a0,0(s0)
    li a7,11
    ecall
    
    # stampo il contenuto di ogni nodo fino a che non torno alla testa
    ciclaPrint:
        # fermo il ciclo quando l'indirizzo del nodo successivo è uguale alla testa
        beq t0,s0, finePrint
        # leggo e stampo il valore del nodo
        lb a0,0(t0)
        li a7,11
        ecall
        # sposto il puntatore al successivo
        lw t0,1(t0)
        j ciclaPrint
    
    finePrint:
    # stampo a capo
    li a0,10
    li a7,11
    ecall
jr ra

#- SORT -#
# ordina gli elementi della lista scambiando il contenuto dei nodi
# quindi non vengono spostati nodi inclusa la testa che rimane invariata
sort:
    # salvo l'indirizzo di ritorno nello stack
    addi sp,sp,-4
    sw ra,0(sp)
    
    # controllo se la lista è vuota
    lw t0,1(s0)
    beq t0,zero, fineSort # salto se il puntatore del primo nodo è zero
    
    # controllo se la lista  ha un solo elemento
    beq t0,s0, fineSort # salto la testa e il successivo hanno lo stesso indirizzo
    
    # passo come parametri l'indirizzo della testa e del suo precedente
    mv a0,s0
    jal cercaPrecedente
    mv a1,a0 # precedente
    mv a0,s0 # testa
    jal quickSort
    
    fineSort:
    # recupero l'indirizzo di ritorno dallo stack
    lw ra,0(sp)
    addi sp,sp,4
jr ra


# QuickSort(a0,a1) a0 = inizio, a1 = fine #
quickSort:
    # salvo i dati nello stack
    addi sp,sp,-12
    sw ra,8(sp) # indirizzo di ritorno
    sw a1,4(sp) # indirizzo fine
    sw a0,0(sp) # indirizzo inizio
    
    # a0 (inizio), a1 (fine)
    jal partizionamento
    
    # recupero i dati dallo stack
    lw t0,0(sp) # indirizzo inizio
    addi sp,sp,4
    # leggo il successivo di inizio
    lw t1,1(t0)
    # salvo i dati nello stack
    addi sp,sp,-4
    sw a0,0(sp) # indirizzo posizione finale perno
    
    # controllo se la posizione del perno è uguale a inizio o il succ. di inizio
    beq a0,t0, noPartizioneSinistra
    beq a0,t1, noPartizioneSinistra
    # salvo i dati nello stack
    addi sp,sp,-4
    sw t0,0(sp) # indirizzo inizio
    # cerco il precedente del perno
    jal cercaPrecedente
    # chiamo il partizionamento sulla parte sinistra (prima del perno) della lista
    mv a1,a0 # indirizzo precedente del perno
    # recupero i dati dallo stack
    lw a0,0(sp) # inizizzo inizio
    addi sp,sp,4     
    jal quickSort
    
    noPartizioneSinistra:
    # recupero i dati dallo stack
    lw t0,0(sp) # indirizzo posizione finale perno
    lw t1,4(sp) # indirizzo fine
    addi sp,sp,8
    # controllo se la posizione del perno è uguale a fine
    beq t0,t1,noPartizioneDestra
    # controllo se la posizione del perno è uguale a al precedente di fine
    lw a0,1(t0) # leggo il successivo dopo il perno
    beq a0,t1,noPartizioneDestra
    # chiamo il partizionamento sulla parte destra (dopo il perno) della lista
    # a0 (successivo dopo il perno)
    mv a1,t1 # indirizzo fine
    jal quickSort
    
    noPartizioneDestra:
    # recupero dallo stack l'inrdirizzo di ritorno
    lw ra,0(sp)
    addi sp,sp,4
jr ra

#- SDX -#
# restituisce l'indirrizzo del precedente della testa che sarà la nuova testa
# per la proprietà della lista concatenata questo equivale a spostare i nodi a destra
sdx:
    mv a0,s0 # preparo il valore da ritornare al chiamante
    # controllo se la lista è vuota
    lw t0,1(a0)
    beq t0,zero fineSdx # se è vuota restituisco la vecchia testa
    # salvo l'indirizzo di ritorno nello stack
    addi sp,sp,-4
    sw ra,0(sp) 
    # cerco il precedente della testa
    # a0 contiene il valore di s0
    jal cercaPrecedente
    # restituisco in a0 il precedente della testa
    lw ra,0(sp) # recupero l'indirizzo di ritorno dallo stack
    addi sp,sp,4
    fineSdx:
jr ra

#- SSX -#
# restituisce l'indirrizzo del successivo della testa che sarà la nuova testa
# per la proprietà della lista concatenata questo equivale a spostare i nodi a sinistra
ssx:
    mv a0,s0 # preparo il valore da ritornare al chiamante
    # controllo se la lista è vuota
    lw t0,1(a0)
    beq t0,zero fineSsx # se è vuota restituisco la vecchia testa
    # leggo il successivo della testa
    lw a0,1(a0)
    # restituisco in a0 il successivo della testa
    fineSsx:
jr ra

#- REV -#
# inverte il contenuto dei nodi quindi lascia invariata la loro posizione
rev:
    addi sp,sp,-8
    sw ra,4(sp) # salvo l'indirizzo di ritorno
    # controllo se la lista è vuota
    lw t0,1(s0)
    beq t0,zero fineRev # salto se il puntatore del primo nodo è zero
    # cerco l'ultimo elemento della lista
    mv a0,s0
    jal cercaPrecedente
    mv t1,s0 # indirizzo puntatore che si sposta avanti
    mv t2,a0 # indirizzo puntatore che si sposta indietro
    ciclaScambi:
        # controllo se gli indirizzi dei puntatori sono uguali (num elem. dispari)
        beq t1,t2,fineRev # (se c'è un solo elemento nella lista termina subito quì)

        # scambio il contenuto dei nodi
        lw t3,0(t1) # leggo il contenuto del nodo avanti
        lw t4,0(t2) # leggo il contenuto del nodo indietro
        sb t3,0(t2) # salvo il contenuto del nodo indietro nel avanti
        sb t4,0(t1) # salvo il contenuto del nodo avanti nel indietro
        
        # sposto i puntatori nelle loro direzioni
        lw t1,1(t1) # successivo puntatore avanti
        sw t1,0(sp) # salvo il puntatore avanti nello stack
        mv a0,t2 
        jal cercaPrecedente
        mv t2,a0 # precedente puntatore indietro
        lw t1,0(sp) # recupero il puntatore avanti dallo stack
        
        # controllo se il puntatori si sono superati a vicenda (num. elm. pari)
        lw t0,1(t2) # successivo di indietro
        bne t0,t1,ciclaScambi

    fineRev:
    lw ra,4(sp)  #recupero l'indirizzo di ritorno dallo stack
    addi sp,sp,8
jr ra


#- FUNZIONI AGGIUNTIVE -#

# CercaPrecedente(a0) a0 = indirizzo di un nodo #
# restituisce l'indirizzo del nodo che punta al nodo passato (cioè il precedente)
# se l'indirizzo passato non è presente nella lista restituisce -1
cercaPrecedente:
    mv t0,a0 # inizializzo l'indice con l'indirizzo passato
    ciclaCercaPrecedente:
        lw t1,1(t0) # leggo il successivo del nodo attuale
        beq t1,a0,trovatoPrecedente # controllo se è uguale all'indirizzo passato
        mv t0,t1 # sposto il avanto l'indice 
        beq t0,a0,elementoNonPresente # controllo se sono tornato alla testa
        j ciclaCercaPrecedente
    trovatoPrecedente:
    mv a0,t0 # indirizzo precedente
    j fineCercaPrecedente
    # se sono stati controllati tutti i nodi della lista e non si è trovato il precedente
    elementoNonPresente:
    li a0,-1 # restitusco -1
    fineCercaPrecedente:  
jr ra

# cercaSpazioLibero(a0) a0 = indirizzo di memoria #
# Cerca indirizzo libero partendo dall'indirizzo di memoria passato
cercaSpazioLibero:
    addi a0,a0,5
    lb t1,0(a0)
    lw t2,1(a0)
    bne t1,zero cercaSpazioLibero
    bne t2,zero cercaSpazioLibero
    # a0 è usato come indice quindi contiene già il valore da restituire
jr ra

# compara(a0,a1) a0 = indirizzo primo byte, a1 = indirizzo secondo byte #
# compara il contenuto dei byte con indirizzo a0 e a1 
# se a0 < a1 restituisce 1 altrimenti 0
compara:
    # leggo il contenuto dei nodi
    lb t0,0(a0)
    lb t1,0(a1)
    # individuo l'insieme del primo elemento 
    # Controllo se è una lettera maiuscola
    li t2,90
    bgt t0,t2, primoNonMaiuscolo
    li t2,65
    blt t0,t2, primoNonMaiuscolo
    addi t0,t0,400 # assegno un peso da maiuscola al primo elemento
    j individuaSecondoElemento
    
    primoNonMaiuscolo:
    # Controllo se è una lettera minuscola
    li t2,122
    bgt t0,t2, primoNonMinuscolo
    li t2,97
    blt t0,t2, primoNonMinuscolo
    addi t0,t0,300 # assegno un peso da minuscola al primo elmento
    j individuaSecondoElemento
    
    primoNonMinuscolo:
    # Controllo se è una cifra
    li t2,57
    bgt t0,t2, individuaSecondoElemento
    li t2,48
    blt t0,t2, individuaSecondoElemento
    addi t0,t0,200 # assegno un peso da cifra al primo elmento

    # individuo l'insieme del secondo elemento
    individuaSecondoElemento:
    li t2,90
    bgt t1,t2, secondoNonMaiuscolo
    li t2,65
    blt t1,t2, secondoNonMaiuscolo
    addi t1,t1,400 # assegno un peso da maiuscola al secondo elmento
    j fineCompara
    
    secondoNonMaiuscolo:
    # Controllo se è una lettera minuscola
    li t2,122
    bgt t1,t2, secondoNonMinuscolo
    li t2,97
    blt t1,t2, secondoNonMinuscolo
    addi t1,t1,300 # assegno un peso da minuscola al secondo elmento
    j fineCompara
    
    secondoNonMinuscolo:
    # Controllo se è una cifra
    li t2,57
    bgt t1,t2, fineCompara
    li t2,48
    blt t1,t2, fineCompara
    addi t1,t1,200 # assegno un peso da cifra al secondo elmento
    
    fineCompara:
    slt a0,t0,t1 # comparo i due valori e restituisco il risultato
jr ra

# partizionamento (a0,a1) a0 = indirizzo primo elemento, a1 = indirizzo ultimo elmento #
# funzione del quickSort che restituisce l'indirizzo in cui è stato spostato il perno
# come perno viene preso il pernultimo elemento al momento della chiamata
# alla fine del partizionamento gli elementi più grandi del perno saranno dopo il perno e quelli più piccoli prima
partizionamento:
    # salvo i dati nello stack
    addi sp,sp,-12
    sw ra,8(sp) # indirizzo di ritorno
    sw a0,4(sp) # indirizzo primo elemento
    sw a1,0(sp) # indirizzo ultimo elemento
    # cerco il precedente dell'ultimo elemento
    mv a0,a1
    jal cercaPrecedente
    # recupero i dati dallo stack
    lw t2,0(sp) # indirizzo ultimo elemento (perno)
    lw t0,4(sp) # indirizzo primo elemento (ciclaAvanti)
    mv t1,a0 # indirizzo penultimo elemento (ciclaIndietro)
    addi sp,sp,8
    
    ciclaAvanti:
        # salvo i dati nello stack
        addi sp,sp,-12
        sw t2,8(sp) # perno
        sw t1,4(sp) # puntatore cicla indietro
        sw t0,0(sp) # puntatore cicla avanti
        # puntatore cicla avanti < perno
        mv a0,t0
        mv a1,t2
        jal compara
        # recupero i dati dallo stack
        lw t0,0(sp) # puntatore cicla avanti
        lw t1,4(sp) # puntatore cicla indietro
        lw t2,8(sp) # perno
        addi sp,sp,12
        beq a0,zero,ciclaIndietro # se è maggiore del perno
        # sposto in avanti il puntatore di cila avanti
        lw a0,1(t0) # preparo il valore di ritorno in caso di fine
        # se supera il puntatore indietro salto a fine
        beq t0,t1,finePartizionamento
        mv t0,a0
        j ciclaAvanti
    
    ciclaIndietro:
        # salvo i dati nello stack
        addi sp,sp,-12
        sw t2,8(sp) # perno
        sw t1,4(sp) # puntatore cicla indietro
        sw t0,0(sp) # puntatore cicla avanti
        # ciclaIndietro < perno
        mv a0,t1
        mv a1,t2
        jal compara
        # recupero i dati dallo stack
        lw t0,0(sp) # puntatore cicla avanti
        lw t1,4(sp) # puntatore cicla indietro
        lw t2,8(sp) # perno
        addi sp,sp,12
        bne a0,zero,scambiaPartizionamento # se è minore o uguale al perno
        # se supera il puntatore indietro salto a fine
        mv a0,t0 # preparo il valore di ritorno in caso di fine
        beq t0,t1,finePartizionamento
        # sposto indietro il puntatore di cila indietro
        # salvo i dati nello stack
        addi sp,sp,-12
        sw t2,8(sp) # perno
        sw t1,4(sp) # puntatore cicla indietro
        sw t0,0(sp) # puntatore cicla avanti
        mv a0,t1
        jal cercaPrecedente
        # recupero i dati dallo stack
        lw t0,0(sp) # puntatore cicla avanti
        lw t1,4(sp) # puntatore cicla indietro
        lw t2,8(sp) # perno
        addi sp,sp,12
        mv t1,a0 # sposto il punatore indietro
        jal ciclaIndietro
        
    scambiaPartizionamento:
        # scambio il contenuto dei nodi fuori posto
        lb t3,0(t0) # contenuto puntatore cicla avanti
        lb t4,0(t1) # contenuto puntatore cicla indietro
        sb t3,0(t1) # salvo il contenuto di cicla avanti in indietro
        sb t4,0(t0) # salvo il contenuto di cicla indietro in avanti
        j ciclaAvanti
        
    finePartizionamento:
    # metto il perno nella sua posizione finale
    lb t0,0(a0) # leggo il valore della posizione in cui finirà il perno
    lb t1,0(t2) # leggo il valore della posizone originale del perno
    sb t1,0(a0) # salvo il perno nella posizione finale
    sb t0,0(t2) # salvo l'altro valore dove era il perno
    # ritorno al chiamante
    lw ra,0(sp)
    addi sp,sp,4
jr ra
    
#------------- TERMINA PROGRAMMA -------------#
fine:
nop