#include<detpic32.h>

void delay(int ms){
    for(; ms > 0; ms--){
       resetCoreTimer();
       while(readCoreTimer() < 20000);
    }
}

void putc(char byte2send){
    // wait while UTXBF == 1
    while(U1STAbits.UTXBF == 1);
    // Copy byte2send to the UxTXREG register
    U1TXREG = byte2send;
}
void puts(char *str){
    // use putc() function to send each charater ('\0' should not be sent)
    int i=0;
    while(str[i] != '\0'){
        putc(str[i]);
        i++;
    } 
}


void configUart(unsigned int baud, char parity, unsigned int stopbits){
    if(baud > 115200 || baud < 600){
        baud = 115200;
    }
    if(parity != 'N' && parity != 'E' && parity != 'O'){
        parity = 'N';
    }
    if(stopbits != 1 && stopbits != 2){
        stopbits = 1;
    }
    
    // Configure BaudRate Generator
    U1BRG = (20000000 + 8 * baud) / (16 * baud) - 1;
    // Configure number of data bits (8), parity and number of stop bits
    // Enable the trasmitter and receiver modules
    // Enable UART1

    U1MODEbits.BRGH = 0;
    if(parity == 'N'){
        U1MODEbits.PDSEL = 0;
    }
    else if(parity == 'E'){
        U1MODEbits.PDSEL = 1;
    }
    else if(parity == 'O'){
        U1MODEbits.PDSEL = 2;
    }

    U1MODEbits.STSEL = stopbits - 1;
    U1STAbits.UTXEN = 1;
    U1STAbits.URXEN = 1;
    U1MODEbits.ON = 1;
} 
char getc(){
    // If OERR == 1 then reset OERR
    // Wait while URXDA == 0
    // If FERR or PERR then
    // read UxRXREG (to discard the character) and return 0
    // else
    // Return U1RXREG 
    if (U1STAbits.OERR == 1){
       U1STAbits.OERR = 0; 
    } 
    while(U1STAbits.URXDA == 0);
    char toDisc;
    if (U1STAbits.FERR || U1STAbits.PERR){
        toDisc = U1RXREG;
        return 0;
    }
    return U1RXREG;
}
int main(void){
    configUart(115200,'N',1);
    while(1){
        putc(getc());

    }
    return 0;
}