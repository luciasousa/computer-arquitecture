#include <detpic32.h>

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

void send2displays(unsigned char value){
    static const char display7Scodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 
    0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
    static char displayFlag = 0;
    // send digit_high (dh) to display_high: 
    unsigned char dh = (value & 0xF0) >> 4;
    // send digit_low (dl) to display_low: 
    unsigned dl = value & 0x0F;

    char hexCode;

    if(displayFlag){
        LATDbits.LATD5 = 1;
        LATDbits.LATD6 = 0;    
        hexCode = display7Scodes[dl];
        LATB = (LATB & 0x00FF) | ((int)hexCode << 8);
    }

    else{
        LATDbits.LATD5 = 0;
        LATDbits.LATD6 = 1;
        hexCode = display7Scodes[dh];
        LATB = (LATB & 0x00FF) | ((int)hexCode << 8);
    }

    displayFlag = !displayFlag;    
}

int main(void){
    

    // configure RB3-RB0 as inputs 
    TRISB = (TRISB | 0x000F);   
    // ler valores de entrada
    PORTB = PORTB & 0xFFF0;

    //RB8-RB14 as outputs
    TRISB = (TRISB & 0x80FF);
    // escrever valores no porto de saida
    LATB = (LATB & 0x00FF);

    // configure RD5-RD6 as outputs
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;

    LATDbits.LATD6 = 0;         // display high active
    LATDbits.LATD5 = 1;         // display low inactive
    
    unsigned char count = 0;
    unsigned int i = 0;

    while(1){
         for (i = 0; i < 20; i++){
            delay(10);
            send2displays(count);
        }

        count++;
    }
    return 0;
}