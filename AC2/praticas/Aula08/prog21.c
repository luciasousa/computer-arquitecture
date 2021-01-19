#include<detpic32.h>

void putc(char byte2send){
    // wait while UTXBF == 1
    while(U1STAbits.UTXBF == 1);
    // Copy byte2send to the UxTXREG register
    U1TXREG = byte2send;
}

void _int_(24) isr_uart1(void){
    putc(U1RXREG);
    // Clear UART1 rx interrupt flag
    IFS0bits.U1RXIF = 0; 
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

int main(void){
    configUart(115200,'N',1);
    EnableInterrupts();
    while(1);
    return 0;
}