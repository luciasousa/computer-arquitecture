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
    
    //unsigned char display7codes[] = {0x3F, 0x06, 0x5B, 0X4F, 0x66, 0x6D, 0X7D, 0X07, 0X7F, 0X6F, 0X77, 0X7C, 0X39, 0X5E, 0X79, 0X71};

    unsigned char segment;
    TRISB = (TRISB & 0x80FF);   // configure RB8-RB14 as outputs
    TRISDbits.TRISD5 = 1;       // configure RD5-RD6 as outputs
    TRISDbits.TRISD6 = 1; 

    LATDbits.LATD6 = 1;         // display high active
    LATDbits.LATD5 = 0;         // display low inactive

    while(1){
        LATDbits.LATD6 = !LATDbits.LATD6; //
        LATDbits.LATD5 = !LATDbits.LATD5; // toggle display selection
        segment = 1;
        int i;
        for(i=0; i < 7; i++){
            // send "segment" value to display
            LATB = (LATB & 0X00FF) | (segment << 8);
            segment = segment << 1;
            // wait 0.5 second
            delay(1000);
        }
    }
    return 0;
}