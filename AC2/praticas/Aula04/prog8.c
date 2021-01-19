#include <detpic32.h>

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

int main(void){
    
    static const char display7codes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 
    0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};

    TRISB = (TRISB | 0x000F);   // configure RB3-RB0 as inputs RB8-RB14 as outputs
    TRISB = (TRISB & 0x80FF);
    TRISDbits.TRISD5 = 0;       // configure RD5-RD6 as outputs
    TRISDbits.TRISD6 = 0; 

    LATB = (LATB & 0x00FF);

    LATDbits.LATD6 = 0;         // display high inactive
    LATDbits.LATD5 = 1;         // display low active
    
    unsigned char put;
    char hex;
    
    while(1){
        // read dip-switch
        // convert to 7 segments code
        // send to display
        put = PORTB & 0x000F;
        hex = display7codes[put];
        LATB = (LATB & 0x0000) | ((int)hex << 8);
    }
    return 0;
}