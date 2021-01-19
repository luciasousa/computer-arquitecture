#include<detpic32.h>

//exercicio1
#define DisableUart1RxInterrupt() IEC0bits.U1RXIE = 0
#define EnableUart1RxInterrupt() IEC0bits.U1RXIE = 1
#define DisableUart1TxInterrupt() IEC0bits.U1TXIE = 0
#define EnableUart1TxInterrupt() IEC0bits.U1TXIE = 1

#define FALSE 0
#define TRUE  1

//exercicio2
#define BUF_SIZE 8
#define INDEX_MASK (BUF_SIZE - 1)

typedef struct{
    unsigned char data[BUF_SIZE];
    unsigned int head;
    unsigned int tail;
    unsigned int count;
} circularBuffer;

volatile circularBuffer txb;            //transmission buffer
volatile circularBuffer rxb;            //reception buffer

//configUart aula passada
void comDrv_config(unsigned int baudrate, char parity, char data, char stopbits){
    if (baudrate > 115200 || baudrate < 600 ) baudrate = 115200;

    if (data != 8 && data != 9) data = 8;

    if (parity != 'N' && parity != 'E' && parity != 'O') parity = 'N';

    if (stopbits != 1 && stopbits != 2) stopbits = 1;

    U1BRG = (20000000 + 8 * baudrate) / ( 16 * baudrate) - 1;
    U1MODEbits.BRGH = 0;

    if (data == 9) U1MODEbits.PDSEL = 3;
    else{
        if (parity == 'N') U1MODEbits.PDSEL = 0;
        else if (parity == 'E') U1MODEbits.PDSEL = 1;
        else U1MODEbits.PDSEL = 2;
    }

    U1MODEbits.STSEL = stopbits - 1;

    U1STAbits.UTXEN = 1;
    U1STAbits.URXEN = 1;

    U1MODEbits.ON = 1;
    
    IEC0bits.U1RXIE = 1;
    IPC6bits.U1IP = 2;      //priority
    IFS0bits.U1RXIF = 0;    
    IFS0bits.U1TXIF = 0;
}

//exercicio3
void comDrv_flushRx(void){
    //initialize variables of the reception buffer 
    rxb.tail = 0;
    rxb.head = 0;
    rxb.count = 0;
    int i;
    for(i = 0; i < BUF_SIZE; i++){
        rxb.data[i] = 0;
    }
}

void comDrv_flushTx(void){
    //inicialize variables of the transmission buffer
    txb.tail = 0;
    txb.head = 0;
    txb.count = 0;
    int i;
    for(i = 0; i < BUF_SIZE; i++){
        txb.data[i] = 0;
    }
}

//exercicio4
void comDrv_putc(char ch){
    while(txb.count == BUF_SIZE){}           //wait while buffer is full
    txb.data[txb.tail] = ch;                //copy character to the transmission buffer at position tail
    txb.tail = (txb.tail + 1) & INDEX_MASK; //increment tail index (mod. buf_size)
    DisableUart1TxInterrupt();              //begin of critical section
    //increment count variable
    txb.count++;
    EnableUart1TxInterrupt();               //end of critical section
}

//exercicio5
void comDrv_puts(char *s){
    while((*s) != '\0'){
        comDrv_putc(*s);
        (s)++;
    }
}

//exercicio6
void _int_(24) isr_UART1(){
    //if U1TXIF is set
    if(IFS0bits.U1TXIF){
        // if "count" variable (transmission buffer, txb) is greater than 0
        if(txb.count > 0){
            // Copy character pointed by "head" to U1TXREG register
            U1TXREG = txb.data[txb.head];
            // Increment "head" variable (mod BUF_SIZE)
            txb.head = (txb.head + 1) & INDEX_MASK;
            // Decrement "count" variable
            txb.count--;
        }
        // if "count" variable is 0 then
        if(txb.count == 0){
            DisableUart1TxInterrupt();
        }
        // Reset UART1 TX interrupt flag
        IFS0bits.U1TXIF = 0;
    }
}

//exercicio8
int comDrv_getc(char *pchar){
    // Test "count" variable (reception buffer) and return FALSE if it is zero
    if(rxb.count == 0){
        return FALSE;
    }
    DisableUart1RxInterrupt(); // Begin of critical section
    // Copy character pointed by "head" to *pchar
    *pchar = rxb.data[rxb.head];
    // Decrement "count" variable
    rxb.count--;
    // Increment "head" variable (mod BUF_SIZE)
    rxb.head = (rxb.head + 1) & INDEX_MASK;
    EnableUart1RxInterrupt(); // End of critical section
    return TRUE;
}

//exercicio 7 e 10
int main(void){
    comDrv_config(115200,'N',8,1);        //default "pterm" parameters with tx and rx interrupts disable
    comDrv_flushRx();
    comDrv_flushTx();
    EnableInterrupts();
    char c = 'S';
    comDrv_puts("PIC32 UART Device-driver\n");
    while(1){
        //7
        //comDrv_puts("Teste do bloco de transmissao do device driver!...");
        //10
        //read character from reception buffer
        //send character to the transmission buffer
         if (comDrv_getc(&c)){
            // 11
            if (c == 'S'){
                comDrv_puts("Uma string com 30 caracteress.");
            }
            comDrv_putc(c);
        }
    }
    return 0;
}